//
//  BackPassController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "BackPassController.h"
#import "BackpassQueController.h"
#import "Color.h"
#import <SMS_SDK/SMSSDK.h>

@interface BackPassController ()
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaFeld;
@property NSString*phoneStr;//手机号
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//下一步button
@property (weak, nonatomic) IBOutlet UIButton *yanZhengMaButton;
//验证码button
@end

@implementation BackPassController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"找回密码";
    //获取教练的审核状态来显示个人中心的不同界面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:telephoneStr forKey:telephone];
   
    _phoneStr=[userDefaults objectForKey:telephone];
//    NSLog(@"=========%@",_phoneStr);


    _phoneLabel.text=[NSString stringWithFormat:@"当前绑定的手机:+86 %@",_phoneStr];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=kUIColorFromRGB(0x6fc4b2);
  
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 6.0;
    [_nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _yanZhengMaButton.layer.masksToBounds = YES;
    _yanZhengMaButton.layer.cornerRadius = _yanZhengMaButton.bounds.size.height/2;
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
//发验证码
- (IBAction)faYanZhengMaButton:(id)sender {

    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneStr
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error)
     {
         
         if (!error)
         {
//             NSLog(@"验证码发送成功");
             
         }
         else
         {
//             NSLog(@"验证码发送失败");
         }
     }];
}
//找回密码的下一步
- (void)nextButton:(id)sender {
//    BackpassQueController*backQueVc=[[BackpassQueController alloc] init];
//    [self.navigationController pushViewController:backQueVc animated:YES];
    [SMSSDK commitVerificationCode:_yanZhengMaFeld.text  phoneNumber:_phoneStr zone:@"86" result:^(NSError *error) {
        if (!error) {
            BackpassQueController*backQueVc=[[BackpassQueController alloc] init];
            [self.navigationController pushViewController:backQueVc animated:YES];
        }
        else
        {
            UIAlertController*alert=[UIAlertController alertControllerWithTitle:nil message:@"验证失败请重新获得验证码" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
            
        }
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
