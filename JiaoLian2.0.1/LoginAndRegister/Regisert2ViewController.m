//
//  Regisert2ViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/21.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "Regisert2ViewController.h"
#import "MD5.h"
#import "UTF8Two.h"
@interface Regisert2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passText;//密码

@property (weak, nonatomic) IBOutlet UIButton *registerButton;//注册button
@end

@implementation Regisert2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"注册2/2";
    UIBarButtonItem*rightButton=[[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(loginButton  )];
    self.navigationItem.rightBarButtonItem=rightButton;
    [rightButton setTintColor:[UIColor whiteColor]];
    _registerButton.layer.masksToBounds = YES;
    _registerButton.layer.cornerRadius = 6.0;
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
//登陆界面
-(void)loginButton{
//    UIStoryboard *LoginAndRegisterSb = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
//    UINavigationController*LoginAndRegisterNc = [LoginAndRegisterSb instantiateViewControllerWithIdentifier:@"LoginAndRegister"];
//    [self.navigationController presentViewController:LoginAndRegisterNc animated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
//注册
- (IBAction)registerButton:(id)sender {
//    NSLog(@"=========%@",_phoneStr);

    NSURL *url = [NSURL URLWithString:REGESTE_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    NSString*passWordStr=[MD5 stringToMD5Str:_passText.text];
    NSString * postString = [NSString stringWithFormat:@"username=%@&password=%@&sign=123",_phoneStr,passWordStr];
    
    postString=[UTF8Two stringToUTF8Str:postString];
    
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"=========%@",request.HTTPMethod);
        
//        NSLog(@"eeeeeee======%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];

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
