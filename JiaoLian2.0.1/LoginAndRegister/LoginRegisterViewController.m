//
//  LoginRegisterViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/13.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "MD5.h"
#import "RegisterViewController.h"
#import "Color.h"
#import "APService.h"
#import "UTF8Two.h"

#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height


@interface LoginRegisterViewController ()
//@property UIView*loginRegisterView;//登陆注册界面
//@property UITextField*phoneField;//手机号
//@property UITextField*yanZhengField;//验证码
//@property UITextField*passwordField;//密码

@property (weak, nonatomic) IBOutlet UITextField *phoneText;//手机号
@property (weak, nonatomic) IBOutlet UITextField *passTex;//密码

@property (weak, nonatomic) IBOutlet UIView *lineView1;


@property (weak, nonatomic) IBOutlet UIView *lineView2;


@property (weak, nonatomic) IBOutlet UIButton *loginButton;//登录button




@end

@implementation LoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setViews];
    _lineView1.backgroundColor=kUIColorFromRGB(0x6fc4b2);
    _lineView2.backgroundColor=kUIColorFromRGB(0x6fc4b2);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=kUIColorFromRGB(0x6fc4b2);
    
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 6.0;
//    _loginButton.layer.borderWidth = 2.0;
//    _zhuCeButton.layer.borderColor = _loginButton.backgroundColor.CGColor;
//    [_zhuCeButton setTitleColor:_loginButton.backgroundColor forState:UIControlStateNormal];
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
//注册
- (IBAction)registerButton:(id)sender {
    
    RegisterViewController*registerVc=[[RegisterViewController alloc] init];
    UINavigationController*registerNc=[[UINavigationController alloc] initWithRootViewController:registerVc];
    [self.navigationController presentViewController:registerNc animated:YES completion:nil];
}
//登陆
- (IBAction)loginButton:(id)sender {
    NSURL *url = [NSURL URLWithString:LOING_URL];
//    NSLog(@"=========%@",LOING_URL);
    
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    NSString*passWordStr=[MD5 stringToMD5Str:_passTex.text];
    
//    NSLog(@"=========%@",passWordStr);

    
    NSString * postString = [NSString stringWithFormat:@"username=%@&password=%@&sign=123",_phoneText.text,passWordStr];
    postString=[UTF8Two stringToUTF8Str:postString];
    
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"eeeeeee======%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        if (data!=nil) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if ([[weatherDic objectForKey:@"returnCode"] isEqual:@"1"]) {
                //从NSUserDefault 如果登陆成功就
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);
                NSDictionary*beanDic=[weatherDic objectForKey:@"bean"];
                NSString*userId=[beanDic objectForKey:USER_ID];//由于id是系统关键字，所以用userId来代id
                //登陆成功后把用户别名给激光服务器
                [APService setAlias:userId callbackSelector:nil object:nil];

                NSString*token=[beanDic objectForKey:TOKEN];
                [userDefaults setBool:YES forKey:LOING_SATAE];
                [userDefaults setObject:userId forKey:USER_ID];
                [userDefaults setObject:token forKey:TOKEN];
                UIStoryboard *MainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController*MainNc = [MainSb instantiateViewControllerWithIdentifier:@"Main"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController presentViewController:MainNc animated:YES completion:nil];
                });
            }
        }
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
}
//-(void)setViews{
//    
//    UIButton*leftButton=[UIButton buttonWithType:UIButtonTypeSystem];
//    leftButton.frame=CGRectMake(0, 20, VIEW_WIDTH/2, 44);
//    [leftButton setTitle:@"登陆" forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(setLoginViews) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:leftButton];
//
//    UIButton*rightButton=[UIButton buttonWithType:UIButtonTypeSystem];
//    rightButton.frame=CGRectMake(VIEW_WIDTH/2, 20, VIEW_WIDTH/2, 44);
//    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(setRegisertViews) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rightButton];
//    
//    //默认显示登陆界面
//    [self setLoginViews];
//}
////#pragma ------------ 登陆界面的布局---------------------
////-(void)setLoginViews{
////    [_loginRegisterView removeFromSuperview];
////   _loginRegisterView =[[UIView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT-64)];
////
////    //账号
////    UILabel*phonelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 30)];
////    phonelabel.text=@"账号";
////    [_loginRegisterView addSubview:phonelabel];
////_phoneField=[[UITextField alloc] initWithFrame:CGRectMake(70, 100, 100, 30)];
////    _phoneField.backgroundColor=[UIColor greenColor];
////    [_loginRegisterView addSubview:_phoneField];
////    
////    //密码
////    UILabel*passwordlabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 150, 50, 30)];
////    passwordlabel.text=@"密码";
////    [_loginRegisterView addSubview:passwordlabel];
////    
////    _passwordField=[[UITextField alloc] initWithFrame:CGRectMake(70, 150, 100, 30)];
////    _passwordField.backgroundColor=[UIColor greenColor];
////    [_loginRegisterView addSubview:_passwordField];
////    
////    
////    UIButton*loginButton=[UIButton buttonWithType:UIButtonTypeSystem];
////    loginButton.frame=CGRectMake(20, 200, 200, 30);
////    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
////    [loginButton addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
////    [_loginRegisterView addSubview:loginButton];
////    
////    //忘记密码
////    UIButton*forgetPassButton=[UIButton buttonWithType:UIButtonTypeSystem];
////    forgetPassButton.frame=CGRectMake(220, 200, 70, 30);
////    [forgetPassButton setTitle:@"忘记密码" forState:UIControlStateNormal];
////    [forgetPassButton addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
////    [_loginRegisterView addSubview:forgetPassButton];
////    
////    
////    [self.view addSubview:_loginRegisterView];
////}
////////忘记密码方法
//////-(void)forgetPasswordEvent{
//////}
////////登陆请求
//////-(void)loginEvent{
//////    NSURL *url = [NSURL URLWithString:LOING_URL];
//////    NSLog(@"=========%@",LOING_URL);
//////
//////    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
//////    request.HTTPMethod=@"POST";
//////    NSLog(@"=========%@",_passwordField.text);
//////
//////    NSString*passWordStr=[MD5 stringToMD5Str:_passwordField.text];
//////
//////
//////
//////    NSString * postString = [NSString stringWithFormat:@"username=%@&password=%@",_phoneField.text,passWordStr];
//////
//////
//////    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
//////    request.HTTPBody=postData;
//////    NSURLSession *session = [NSURLSession sharedSession];
//////    
//////    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//////        NSLog(@"eeeeeee======%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//////        if (data!=nil) {
//////                   NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//////            if ([[weatherDic objectForKey:@"returnCode"] isEqual:@"1"]) {
//////                //从NSUserDefault 如果登陆成功就
//////                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//////                NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);
//////                NSDictionary*beanDic=[weatherDic objectForKey:@"bean"];
//////                NSString*userId=[beanDic objectForKey:USER_ID];//由于id是系统关键字，所以用userId来代id
//////                NSString*token=[beanDic objectForKey:TOKEN];
//////                [userDefaults setBool:YES forKey:LOING_SATAE];
//////                [userDefaults setObject:userId forKey:USER_ID];
//////                [userDefaults setObject:token forKey:TOKEN];
//////                UIStoryboard *MainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//////                UITabBarController*MainNc = [MainSb instantiateViewControllerWithIdentifier:@"Main"];
//////                dispatch_async(dispatch_get_main_queue(), ^{
//////                    [self.navigationController presentViewController:MainNc animated:YES completion:nil];
//////                });
//////            }
//////        }
//////    }];
//////    //任务创建后，不会立即执行，调用resume 立即执行;
//////    [dataTask resume];
//////   }
//////
//////
//////
//////
////////
////////#pragma ------------注册界面布局---------------
////////-(void)setRegisertViews{
////////    [_loginRegisterView removeFromSuperview];
////////    _loginRegisterView =[[UIView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT-64)];
////////    //手机
////////    UILabel*phonelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 30)];
////////    phonelabel.text=@"手机";
////////    [_loginRegisterView addSubview:phonelabel];
////////   _phoneField =[[UITextField alloc] initWithFrame:CGRectMake(70, 100, 150, 30)];
////////    _phoneField.backgroundColor=[UIColor greenColor];
////////    [_loginRegisterView addSubview:_phoneField];
////////    
////////    //验证码
////////    UILabel*yanZhenglabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 150, 70, 30)];
////////    yanZhenglabel.text=@"验证码";
////////    [_loginRegisterView addSubview:yanZhenglabel];
////////    
////////    _yanZhengField=[[UITextField alloc] initWithFrame:CGRectMake(90, 150, 100, 30)];
////////    _yanZhengField.backgroundColor=[UIColor greenColor];
////////    [_loginRegisterView addSubview:_yanZhengField];
////////    
////////    //获取验button
////////    UIButton*getYanZhengButton=[UIButton buttonWithType:UIButtonTypeSystem];
////////    getYanZhengButton.frame=CGRectMake(190, 150, 80, 30);
////////    [getYanZhengButton setTitle:@"获取验正码" forState:UIControlStateNormal];
////////    [getYanZhengButton addTarget:self action:@selector(getYanZhengMaEvent) forControlEvents:UIControlEventTouchUpInside];
////////    [_loginRegisterView addSubview:getYanZhengButton];
////////    
////////    UIButton*loginButton=[UIButton buttonWithType:UIButtonTypeSystem];
////////    loginButton.frame=CGRectMake(20, 200, 200, 30);
////////    [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
////////    [loginButton addTarget:self action:@selector(registerNextEvent) forControlEvents:UIControlEventTouchUpInside];
////////    [_loginRegisterView addSubview:loginButton];
////////    [self.view addSubview:_loginRegisterView];
////////}
//////////获取难正码
////////-(void)getYanZhengMaEvent{
////////    if ([self isValidateMobile:_phoneField.text]) {
////////        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneField.text
////////                                       zone:@"86"
////////                           customIdentifier:nil
////////                                     result:^(NSError *error)
////////         {
////////             
////////             if (!error)
////////             {
////////                 NSLog(@"验证码发送成功");
////////                 
////////             }
////////             else
////////             {
////////                 NSLog(@"验证码发送失败");
////////             }
////////         }];
////////    }else{
////////        NSLog(@"=========%@",@"不是手机号");
////////    }
////////    
////////
////////
////////}
////////////判断手机号
//////////-(BOOL) isValidateMobile:(NSString *)mobile
//////////{
//////////    //手机号以13， 15，18开头，八个 \d 数字字符
//////////    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//////////    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//////////    //    NSLog(@"phoneTest is %@",phoneTest);
//////////    return [phoneTest evaluateWithObject:mobile];
//////////}
//////////
////////////下一步
//////////-(void)registerNextEvent{
//////////    [SMSSDK commitVerificationCode:_yanZhengField.text phoneNumber:_phoneField.text zone:@"86" result:^(NSError *error) {
//////////        
//////////        if (!error) {
//////////            
//////////            NSLog(@"验证成功");
//////////            [self setToRegisterViews];
//////////            
//////////        }
//////////        else
//////////        {
//////////            NSLog(@"验证失败");
//////////            
//////////            
//////////        }
//////////    }];
//////////    
//////////    
//////////
//////////}
////验正好之后的注册界面
//-(void)setToRegisterViews{
//    [_loginRegisterView removeFromSuperview];
//    _loginRegisterView =[[UIView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT-64)];
//    //    UIView*nextView =[[UIView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT-64)];
//    _loginRegisterView.backgroundColor=[UIColor whiteColor];
//    //密码
//    UILabel*passwordlabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 30)];
//    passwordlabel.text=@"密码";
//    [_loginRegisterView addSubview:passwordlabel];
//    _passwordField =[[UITextField alloc] initWithFrame:CGRectMake(70, 100, 100, 30)];
//    _passwordField.backgroundColor=[UIColor greenColor];
//    [_loginRegisterView addSubview:_passwordField];
//    
////    //邀请码
////    UILabel*yaoQinglabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 150, 70, 30)];
////    yaoQinglabel.text=@"邀请码";
////    [_loginRegisterView addSubview:yaoQinglabel];
//    
////    _yaoQingField=[[UITextField alloc] initWithFrame:CGRectMake(90, 150, 100, 30)];
////    _yaoQingField.backgroundColor=[UIColor greenColor];
////    [_loginRegisterView addSubview:_yaoQingField];
//    
//    
//    
//    UIButton*registerButton=[UIButton buttonWithType:UIButtonTypeSystem];
//    registerButton.frame=CGRectMake(20, 200, 100, 30);
//    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
//    [registerButton addTarget:self action:@selector(registerEvent) forControlEvents:UIControlEventTouchUpInside];
//    [_loginRegisterView addSubview:registerButton];
//    [self.view addSubview:_loginRegisterView];
//}
////发起注册请求
//-(void)registerEvent{
//    NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);
//
//        NSURL *url = [NSURL URLWithString:REGESTE_URL];
//        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
//        request.HTTPMethod=@"POST";
//    NSString*passWordStr=[MD5 stringToMD5Str:_passwordField.text];
//        NSString * postString = [NSString stringWithFormat:@"username=%@&password=%@",_phoneField.text,passWordStr];
//        NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
//        request.HTTPBody=postData;
//        NSURLSession *session = [NSURLSession sharedSession];
//    
//        NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSLog(@"=========%@",request.HTTPMethod);
//    
//            NSLog(@"eeeeeee======%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        }];
//        //任务创建后，不会立即执行，调用resume 立即执行;
//        [dataTask resume];
//
//
//}

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
