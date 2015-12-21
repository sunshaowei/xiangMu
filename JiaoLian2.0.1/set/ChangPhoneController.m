//
//  ChangPhoneController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "ChangPhoneController.h"
#import "MD5.h"
#import "UTF8Two.h"


@interface ChangPhoneController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//手机号
@property (weak, nonatomic) IBOutlet UIButton *successButton;//完成Ｂutton
@property (weak, nonatomic) IBOutlet UIButton *keFuButton;
//咨询客服
@property (weak, nonatomic) IBOutlet UIButton *yanZhengMaButton;//验证码
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaFeld;//

@property (weak, nonatomic) IBOutlet UITextField *passworldFeld;//密码

@property (weak, nonatomic) IBOutlet UITextField *xinPhoneFeld;//新手机号


@end

@implementation ChangPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*phone=[userDefaults objectForKey:telephone];
    _phoneLabel.text=[NSString stringWithFormat:@"+86 %@",phone];
    
    
    
    
    
    
    

    self.title=@"换绑定手机号";
    _successButton.layer.masksToBounds = YES;
    _successButton.layer.cornerRadius = 6.0;
    
    _keFuButton.layer.masksToBounds = YES;
    _keFuButton.layer.cornerRadius = 6.0;
    _keFuButton.layer.borderWidth=2.0;
    _keFuButton.layer.borderColor=_successButton.backgroundColor.CGColor;
    
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
//完成
- (IBAction)successButton:(id)sender {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
   
        NSURL *url = [NSURL URLWithString:CHANG_PHONE_URL];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod=@"POST";
        //获取教练的审核状态来显示个人中心的不同界面

//        NSString*phoneStr=[userDefaults objectForKey:telephone];
    
        NSString*userid =[userDefaults objectForKey:USER_ID];
        NSString*token=[userDefaults objectForKey:TOKEN];
        NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/upTelephone%@%@",userid,token]];
        
        NSString*password=[MD5 stringToMD5Str:_passworldFeld.text];
        
        
        NSString * postString =[NSString stringWithFormat:@"id=%@&username=%@&password=%@&sign=%@",userid,_xinPhoneFeld.text,password,sign];
//    NSLog(@"=========%@",postString);

        postString=[UTF8Two stringToUTF8Str:postString];
        NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
        request.HTTPBody=postData;
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data!=nil) {
                NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                NSLog(@"=========%@",dic);
                NSString*code=[dic objectForKey:@"returnCode"];
                if ([code isEqualToString:@"-2"]) {
                    UIStoryboard *LoginAndRegisterSb = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
                    UINavigationController*LoginAndRegisterNc = [LoginAndRegisterSb instantiateViewControllerWithIdentifier:@"LogiRegister"];
                    [self.navigationController presentViewController:LoginAndRegisterNc animated:YES completion:nil];
                }
            }
        }];
        //任务创建后，不会立即执行，调用resume 立即执行;
        [dataTask resume];
//    }else{
//        UIAlertController*alert=[UIAlertController alertControllerWithTitle:nil message:@"验证失败请重新获得验证码" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            
//            
//        }];
//        
//        [alert addAction:okAction];
//        
//        [self presentViewController:alert animated:YES completion:^{
//            
//        }];
//    }

}
//咨询客服
- (IBAction)keFuButton:(id)sender {
    NSString *phoneNum = @"4000916960";// 电话号码
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
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
