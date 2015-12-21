//
//  CCBaoJiaViewController.m
//  JiaoLian2.0.1
//
//  Created by 孙少伟 on 15/11/25.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "CCBaoJiaViewController.h"
#import "Color.h"
#import "MD5.h"
#import "UTF8Two.h"

@interface CCBaoJiaViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ccBaoJiaLabel;//价格的 text

@property (weak, nonatomic) IBOutlet UIButton *guanBiButton;//关闭报价的button

@end

@implementation CCBaoJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem*rightButton=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveBaoJiaButton)];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=rightButton;
    self.title=[NSString stringWithFormat:@"%@价格",_ccBaojiaStr];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=kUIColorFromRGB(0x6fc4b2);
    //修改关闭报价的字体
    if ([_ccBaojiaStr isEqualToString:@"C1"]) {
        [_guanBiButton setTitle:[NSString stringWithFormat:@"关闭C1报价"] forState:UIControlStateNormal];
    }else{
        [_guanBiButton setTitle:[NSString stringWithFormat:@"关闭C2报价"] forState:UIControlStateNormal];
        
    }
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
-(void)saveBaoJiaButton{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSURL *url = [NSURL URLWithString:XIUGAI_CCPRICE_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];
    NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/findcloseOffer%@%@",userid,token]];


    NSString * postString;
    if ([_ccBaojiaStr isEqualToString:@"C1"]) {
        
        postString=[NSString stringWithFormat:@"id=%@&sign=%@&c1_offer=%@",userid,sign,_ccBaoJiaLabel.text];
        postString=[UTF8Two stringToUTF8Str:postString];

    }else{
        postString=[NSString stringWithFormat:@"id=%@&sign=%@&c2_offer=%@",userid,sign,_ccBaoJiaLabel.text];
        postString=[UTF8Two stringToUTF8Str:postString];
    }
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString*SSS=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"=========%@",SSS);
    }];
    //任务创建后，不会立即执行，调用resume立即执行;
    [dataTask resume];

}
//关闭报价
- (IBAction)bianBiBaoJiaButton:(id)sender {
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:XIUGAI_CCPRICE_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    //        NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
    //    NSString*password=[MD5 stringToMD5Str:@"123456"];
    
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];
    NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/findcloseOffer%@%@",userid,token]];
    NSString * postString;
    if ([_ccBaojiaStr isEqualToString:@"C1"]) {
        postString=[NSString stringWithFormat:@"id=%@&sign=%@&c1_offer=-1",userid,sign];
        postString=[UTF8Two stringToUTF8Str:postString];

    }else{

        postString=[NSString stringWithFormat:@"id=%@&sign=%@&c2_offer=-1",userid,sign];
        postString=[UTF8Two stringToUTF8Str:postString];

    }
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString*SSS=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"=========%@",SSS);
    }];
    //任务创建后，不会立即执行，调用resume立即执行;
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
