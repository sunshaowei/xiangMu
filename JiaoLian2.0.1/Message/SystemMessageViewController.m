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
#import "MJRefresh.h"
#import "UTF8Two.h"
#import "MD5.h"

@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray*beansArray;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"消息";
    UIBarButtonItem*ignoreUnreadButton=[[UIBarButtonItem alloc] initWithTitle:@"忽略未读" style:UIBarButtonItemStyleDone target:self action:@selector(ignoreUnreadButton)];
    self.navigationItem.rightBarButtonItem=ignoreUnreadButton;
    
    UIBarButtonItem*backButton=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backView)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    
    _beansArray=[NSMutableArray arrayWithCapacity:8];
    [self sysTemMessage];
    
    [self changeBackButton];
}
-(void)backView{
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);

}
-(void)viewDidAppear:(BOOL)animated{
    [_beansArray removeAllObjects];
    [self sysTemMessage];
//    NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);
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
-(void)headerRereshing{
    //创建串行队列
    dispatch_queue_t  queue= dispatch_queue_create("wendingding", NULL);
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性，一般来说串行队列不需要赋值任何属性，所以通常传空值（NULL）
    
    //    //2.添加任务到队列中执行
    //    dispatch_async(queue, ^{
    //        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    //    });
    //    dispatch_async(queue, ^{
    //        for (int i=0; i<1000; i++) {
    //            NSLog(@"方法＝＝%s，行数＝＝%d",__FUNCTION__,__LINE__);
    //        }
    //    });
    dispatch_async(queue, ^{
//        NSLog(@"下载图片3----%@",[NSThread currentThread]);
        [self.tableView headerEndRefreshing];
    });
}
//获得消息列表
-(void)sysTemMessage{
    NSURL *url = [NSURL URLWithString:SYSTEM_MESSAGE_URL];
   
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];

    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";


     NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/findMysgs%@%@",userid,token]];
    NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@",userid,sign];
//    NSLog(@"=========%@",postString);

    postString=[UTF8Two stringToUTF8Str:postString];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data!=nil) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//            NSLog(@"=========%@",weatherDic);

            NSArray*beansArray=[weatherDic objectForKey:@"beans"];
            
            for (NSDictionary*dic in beansArray) {
                SystemMessageModel*oneSystemMessageModel=[[SystemMessageModel alloc] init];
                [oneSystemMessageModel setValuesForKeysWithDictionary:dic];
                if (![oneSystemMessageModel.state isEqualToString:@"0"]) {
                    [_beansArray addObject:oneSystemMessageModel];
                }
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
    NSURL *url = [NSURL URLWithString:HULEU_YIDU_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    //        NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
    //    NSString*password=[MD5 stringToMD5Str:@"123456"];
    
    NSString * postString =[NSString stringWithFormat:@"id=1118&test=1"];
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
    [_beansArray removeAllObjects];
    [self sysTemMessage];
    
}
//进入编辑模式，删除数据和cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    
    [_beansArray removeObjectAtIndex:indexPath.row];
    // Delete the row from the data source.
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
    NSURL *url = [NSURL URLWithString:DEL_SINGMESSAGE_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    //        NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
    //    NSString*password=[MD5 stringToMD5Str:@"123456"];
    SystemMessageModel*oneSystemMessageModel=_beansArray[indexPath.row];

    NSString * postString =[NSString stringWithFormat:@"id=1118&test=1&msg_id=%@",oneSystemMessageModel.ID];
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
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _beansArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    SystemMessageCell   * cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemMessageCell"  owner:self options:nil] lastObject];
    
    SystemMessageModel*oneSystemMessageModel=_beansArray[indexPath.row];
    cell.messageLabel.text=oneSystemMessageModel.msg_content;
    cell.timeLabel.text=oneSystemMessageModel.crt_time;
    //消息状态0已删除，1未读，2已读
    if ([oneSystemMessageModel.state isEqualToString:@"2"]) {
            cell.messageLabel.textColor=[UIColor grayColor];
    }

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
