//
//  SystemMessageViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessgedetailsController.h"
#import "SystemMessageModel.h"
#import "SystemMessageCell.h"
@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray*beansArray;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"系统消息";
    UIBarButtonItem*ignoreUnreadButton=[[UIBarButtonItem alloc] initWithTitle:@"忽略未读" style:UIBarButtonItemStyleDone target:self action:@selector(ignoreUnreadButton)];
    self.navigationItem.rightBarButtonItem=ignoreUnreadButton;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _beansArray=[NSMutableArray arrayWithCapacity:8];
    [self sysTemMessage];
}
-(void)sysTemMessage{
    NSURL *url = [NSURL URLWithString:SYSTEM_MESSAGE_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
   
    
    NSString * postString =[NSString stringWithFormat:@"id=1118&test=1"];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data!=nil) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"消息=========%@",weatherDic);
            NSArray*beansArray=[weatherDic objectForKey:@"beans"];
            
            for (NSDictionary*dic in beansArray) {
                SystemMessageModel*oneSystemMessageModel=[[SystemMessageModel alloc] init];
                [oneSystemMessageModel setValuesForKeysWithDictionary:dic];
                [_beansArray addObject:oneSystemMessageModel];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            
        });
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];

}
-(void)ignoreUnreadButton{
    NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _beansArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    SystemMessageCell   * cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemMessageCell"  owner:self options:nil] lastObject];
    
    SystemMessageModel*oneSystemMessageModel=_beansArray[indexPath.row];
    cell.messageLabel.text=oneSystemMessageModel.msg_content;
    cell.timeLabel.text=oneSystemMessageModel.crt_time;
    // Configure the cell...
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemMessgedetailsController*systemMessageDetailsVc=[[SystemMessgedetailsController alloc] init];
    SystemMessageModel*oneSystemMessageModel=_beansArray[indexPath.row];

    systemMessageDetailsVc.oneMessageModel=oneSystemMessageModel;
    [self.navigationController pushViewController:systemMessageDetailsVc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
