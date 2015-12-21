//
//  LoginBackPassViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/21.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "LoginBackPassViewController.h"
#import "MD5.h"
#import "UTF8Two.h"

@interface LoginBackPassViewController ()


@property (weak, nonatomic) IBOutlet UITextField *xinPassText;//新密码
@property (weak, nonatomic) IBOutlet UIButton *successButton;//完成button

@end

@implementation LoginBackPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _successButton.layer.masksToBounds = YES;
    _successButton.layer.cornerRadius = 6.0;
    self.title=@"找回密码";
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
//完成button
- (IBAction)successButton:(id)sender {
    NSURL *url = [NSURL URLWithString:BACK_PASS_URL];
//    NSLog(@"=========%@",BACK_PASS_URL);

    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    //获取教练的审核状态来显示个人中心的不同界面
    NSString*password=[MD5 stringToMD5Str:_xinPassText.text];
    
    NSString * postString =[NSString stringWithFormat:@"username=%@&password=%@&sign=123",_phoneStr,password];
    postString=[UTF8Two stringToUTF8Str:postString];
//    NSLog(@"=========%@",postString);

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
