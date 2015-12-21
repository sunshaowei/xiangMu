//
//  BackPassController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "BackPassController.h"
#import "BackpassQueController.h"
//#import <SMS_SDK/SMSSDK.h>

@interface BackPassController ()
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaFeld;
@property NSString*phoneStr;//手机号

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
    
    _phoneLabel.text=[NSString stringWithFormat:@"当前绑定的手机:+86 %@",_phoneStr];



}
//发验证码
- (IBAction)faYanZhengMaButton:(id)sender {

    
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneStr
//                                   zone:@"86"
//                       customIdentifier:nil
//                                 result:^(NSError *error)
//     {
//         
//         if (!error)
//         {
//             NSLog(@"验证码发送成功");
//             
//         }
//         else
//         {
//             NSLog(@"验证码发送失败");
//         }
//     }];
}
//找回密码的下一步
- (IBAction)nextButton:(id)sender {
    BackpassQueController*backQueVc=[[BackpassQueController alloc] init];
    [self.navigationController pushViewController:backQueVc animated:YES];
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
