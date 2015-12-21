//
//  RegisterViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/21.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "RegisterViewController.h"
#import "Regisert2ViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "Color.h"
#import "UTF8Two.h"
@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;//手机号
@property (weak, nonatomic) IBOutlet UITextField *yanZhengText;//验证码
@property (weak, nonatomic) IBOutlet UIButton *yanZhengMaButton;//验证码
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//下一步button

@property UIAlertController*alert;
@property NSTimer*timer;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"注册1/2";
    //修改导航栏
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=kUIColorFromRGB(0x6fc4b2);
    
    UIBarButtonItem*rightButton=[[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(loginButton  )];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    _yanZhengMaButton.layer.masksToBounds = YES;
    _yanZhengMaButton.layer.cornerRadius = _yanZhengMaButton.bounds.size.height/2;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 6.0;
    [_nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
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
//回到登陆界面
-(void)loginButton{
   [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//获取验证码
- (IBAction)getYanZhengButton:(id)sender {
    
    if ([self isValidateMobile:_phoneText.text]) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneText.text
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error)
         {
             
             if (!error)
             {
//                 NSLog(@"验证码发送成功");
                 
             }
             else
             {
//                 NSLog(@"验证码发送失败");
             }
         }];
    }else{
//        NSLog(@"=========%@",@"不是手机号");
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


//下一步
- (void)nextButton:(id)sender {
    [SMSSDK commitVerificationCode:_yanZhengText.text phoneNumber:_phoneText.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            Regisert2ViewController*regisert2Vc=[[Regisert2ViewController alloc] init];
            regisert2Vc.phoneStr=_phoneText.text;
            [self.navigationController pushViewController:regisert2Vc animated:YES];
            
            
        }
        else
        {

            _alert = [UIAlertController alertControllerWithTitle:nil message:@"验证失败请重新获得验证码" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:_alert animated:YES completion:^{
                _timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
                [_timer fire];
            }];
           
        }
    }];

   

}
- (void)dismiss{
    [_alert dismissViewControllerAnimated:YES completion:^{
        [_timer invalidate];
    }];
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
