//
//  TuiChuController.m
//  JiaoLian2.0.1
//
//  Created by 孙少伟 on 15/11/26.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "TuiChuController.h"
#import "RegisterViewController.h"

@interface TuiChuController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;//登陆button
@property (weak, nonatomic) IBOutlet UIButton *zhuCeButton;//注册button

@end

@implementation TuiChuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 6.0;
//    _loginButton.layer.borderWidth = 1.0;
//    _loginButton.layer.borderColor = _loginButton.backgroundColor.CGColor;
    
    _zhuCeButton.layer.masksToBounds = YES;
    _zhuCeButton.layer.cornerRadius = 6.0;
    _zhuCeButton.layer.borderWidth = 2.0;
    _zhuCeButton.layer.borderColor = _loginButton.backgroundColor.CGColor;
    [_zhuCeButton setTitleColor:_loginButton.backgroundColor forState:UIControlStateNormal];
    
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
//登陆
- (IBAction)loginButton:(id)sender {
    UIStoryboard *LoginAndRegisterSb = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    UINavigationController*LoginAndRegisterNc = [LoginAndRegisterSb instantiateViewControllerWithIdentifier:@"LogiRegister"];
    [self.navigationController presentViewController:LoginAndRegisterNc animated:YES completion:nil];
}
//注册
- (IBAction)registerButton:(id)sender {
//    UIStoryboard *LoginAndRegisterSb = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
//    UINavigationController*LoginAndRegisterNc = [LoginAndRegisterSb instantiateViewControllerWithIdentifier:@"LogiRegister"];
//    [self.navigationController presentViewController:LoginAndRegisterNc animated:YES completion:nil];
    
    RegisterViewController*registerVc=[[RegisterViewController alloc] init];
    UINavigationController*registerNc=[[UINavigationController alloc] initWithRootViewController:registerVc];
    [self.navigationController presentViewController:registerNc animated:YES completion:nil];

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
