//
//  AdviceViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "AdviceViewController.h"

@interface AdviceViewController ()
//提交内容
@property (weak, nonatomic) IBOutlet UITextView *textView;
//手机号邮箱
@property (weak, nonatomic) IBOutlet UITextField *phoneEmailField;


@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"意见反馈";
    _textView.layer.cornerRadius = 6;
    _textView.layer.masksToBounds = YES;
    _textView.contentInset = UIEdgeInsetsMake(-_textView.bounds.size.height/2+5, 10.0f, 10.0f, 10.0f);
    _textView.textAlignment = NSTextAlignmentLeft;
}

//提交反馈
- (IBAction)commentButton:(id)sender {
    NSLog(@"=========%@",_textView.text);
    NSLog(@"=========%@",_phoneEmailField.text);
    //获取教练的审核状态来显示个人中心的不同界面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*userId=[userDefaults objectForKey:USER_ID];

    NSURL *url = [NSURL URLWithString:YIJIAN_FANKUI_URL];
    NSLog(@"=========%@",YIJIAN_FANKUI_URL);

    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    //    NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
    //    NSString*password=[MD5 stringToMD5Str:@"123456"];
    //f_content评价内容，
    NSString * postString =[NSString stringWithFormat:@"f_content=%@&id=%@&way=%@&test=123",_textView.text,userId,_phoneEmailField.text];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"=========%@",request.HTTPMethod);
        NSLog(@"eeeeeee======%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
}
-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
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
