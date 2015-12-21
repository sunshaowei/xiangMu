//
//  BackpassQueController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "BackpassQueController.h"
#import "ChangPassCell.h"
#import "MD5.h"

@interface BackpassQueController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BackpassQueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"找回密码";
    _tableView.delegate=self;
    _tableView.dataSource=self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangPassCell   * cell = [[[NSBundle mainBundle] loadNibNamed:@"ChangPassCell"  owner:self options:nil] lastObject];
    cell.rightFeid.placeholder=@"请输入";
    if (indexPath.row==0)
        cell.leftLabel.text=@"新密码  ";
    else
        cell.leftLabel.text=@"确认密码";
    return cell;
}
//完成button
- (IBAction)successButton:(id)sender {
    ChangPassCell*cell=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ChangPassCell*cell1=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString*pass1=cell.rightFeid.text;
    NSString*pass2=cell1.rightFeid.text;
    if ([pass1 isEqualToString:pass2]) {
            NSURL *url = [NSURL URLWithString:BACK_PASS_URL];
            NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod=@"POST";
            //获取教练的审核状态来显示个人中心的不同界面
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString*phoneStr=[userDefaults objectForKey:telephone];
            NSString*password=[MD5 stringToMD5Str:pass1];
        
            NSString * postString =[NSString stringWithFormat:@"username=%@&password=%@&test=123",phoneStr,password];
            NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
            request.HTTPBody=postData;
            NSURLSession *session = [NSURLSession sharedSession];
        
            NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"=========%@",request.HTTPMethod);
        
                NSLog(@"eeeeeee======%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            }];
            //任务创建后，不会立即执行，调用resume 立即执行;
            [dataTask resume];
    }else{
        NSLog(@"=========%@",@"再次输入的密码不一样");
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
