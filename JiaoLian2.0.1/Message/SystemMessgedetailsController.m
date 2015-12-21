//
//  SystemMessgedetailsController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "SystemMessgedetailsController.h"

@interface SystemMessgedetailsController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UITextView *messageLabel;//消息内容
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UIButton *diButton;

@end

@implementation SystemMessgedetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _nameLabel.text=_oneMessageModel.cname;
    _messageLabel.text=_oneMessageModel.msg_content;
    _timeLabel.text=_oneMessageModel.crt_time;
    [self changXiaoXiZhuangTai];//修改消息已读未读状态
    
    if ([_oneMessageModel.msg_type isEqualToString:@"1"]) {
        [_diButton setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        [_diButton setTitle:@"查处详情" forState:UIControlStateNormal];
//        NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);
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
//修改消息已读未读状态
-(void)changXiaoXiZhuangTai{
    NSURL *url = [NSURL URLWithString:HULEU_SINGMESSAGE_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    //        NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
    //    NSString*password=[MD5 stringToMD5Str:@"123456"];
    
    NSString * postString =[NSString stringWithFormat:@"id=1118&test=1&msgId=%@",_oneMessageModel.ID];
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
//确定或者查看详情
- (IBAction)diButton:(id)sender {
    if ([_oneMessageModel.msg_type isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
//        NSLog(@"=========账户消息");
    }
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
