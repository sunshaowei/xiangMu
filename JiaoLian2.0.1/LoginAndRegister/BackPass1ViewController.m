//
//  BackPass1ViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/21.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "BackPass1ViewController.h"
#import "LoginBackPassViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "Color.h"
@interface BackPass1ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;//手机号

@property (weak, nonatomic) IBOutlet UITextField *yanZhengText;//验证码
@property (weak, nonatomic) IBOutlet UIButton *yanZhengButton;//验证码button

@property (weak, nonatomic) IBOutlet UIButton *nextButton;//下一步button

@end
@implementation BackPass1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _yanZhengButton.layer.masksToBounds = YES;
    _yanZhengButton.layer.cornerRadius = _yanZhengButton.bounds.size.height/2;
    
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 6.0;
    _nextButton.userInteractionEnabled=NO;
    [self changeBackButton];
}
- (void)changeBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back@3x.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//验证码
- (IBAction)yanZhengButton:(id)sender {
    if ([self isValidateMobile:_phoneText.text]) {
                [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneText.text
                                               zone:@"86"
                                   customIdentifier:nil
                                             result:^(NSError *error)
                 {
                     if (!error)
                     {
//                         NSLog(@"验证码发送成功");
                         _nextButton.backgroundColor=kUIColorFromRGB(0x6fc4b2);
                         _nextButton.userInteractionEnabled=YES;
                     }
                     else
                     {
//                         NSLog(@"验证码发送失败");
                     }
                 }];
            }else{
//                NSLog(@"=========%@",@"不是手机号");
            }
        }
//判断手机号
-(BOOL) isValidateMobile:(NSString *)mobile
{
        //手机号以13， 15，18开头，八个 \d 数字字符
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        //    NSLog(@"phoneTest is %@",phoneTest);
        return [phoneTest evaluateWithObject:mobile];
}
//    //下一步
//    -(void)registerNextEvent{
//
//下一步
- (IBAction)nextButton:(id)sender {
    [SMSSDK commitVerificationCode:_yanZhengText.text phoneNumber:_phoneText.text zone:@"86" result:^(NSError *error) {
    if (!error) {
       
    LoginBackPassViewController*backPassVc=[[LoginBackPassViewController alloc] init];
        backPassVc.phoneStr=_phoneText.text;
    [self.navigationController pushViewController:backPassVc animated:YES];
    }
    else
    {
//    NSLog(@"验证失败");
    }
    }];
    
//    LoginBackPassViewController*backPassVc=[[LoginBackPassViewController alloc] init];
//    backPassVc.phoneStr=_phoneText.text;
//    [self.navigationController pushViewController:backPassVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
