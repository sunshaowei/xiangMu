//
//  MainViewController.m
//  JiaoLian2.0.1
//
//  Created by 孙少伟 on 15/11/24.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "MainViewController.h"
#import "SetingViewController.h"
#import "SystemMessageViewController.h"
#import "StudentsViewController.h"

#import "WalletsViewController.h"

#import "UserCenterViewController.h"
#import "MD5.h"
#import "UTF8Two.h"
#import "Color.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *userCenterView;//个人中心
@property (weak, nonatomic) IBOutlet UIImageView *headView;//头像
@property (weak, nonatomic) IBOutlet UILabel *cNameLabel;//教练名
@property (weak, nonatomic) IBOutlet UILabel *jiaoLingLabel;//教齡
@property (weak, nonatomic) IBOutlet UILabel *c1Label;//c1标签
@property (weak, nonatomic) IBOutlet UILabel *c1PriceLabel;//c1价格
@property (weak, nonatomic) IBOutlet UILabel *c2Label;//c2标签
@property (weak, nonatomic) IBOutlet UILabel *c2PriceLabel;//c2价格
@property (weak, nonatomic) IBOutlet UILabel *studentCountLabel;//学员数量

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor=kUIColorFromRGB(0x6fc4b2);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=kUIColorFromRGB(0x6fc4b2);
    self.title=@"个人中心";
    
    [self jiaoLianData];//教练的个人信息
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toUserCenter)];
    [_userCenterView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserProfileSuccess:) name:@"Notification_GetUserProfileSuccess" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [self jiaoLianData];
}
- (void) getUserProfileSuccess:(NSNotification*)usrInofDic

{
//    NSLog(@"=========%@",usrInofDic.userInfo);


    
        NSString*infoState= [usrInofDic.userInfo objectForKey:@"key"];
        if ([infoState isEqualToString:@"1"]) {
//            NSLog(@"========学员列表");
            
            StudentsViewController*studentVc=[[StudentsViewController alloc] init];
            [self.navigationController pushViewController:studentVc animated:YES];
        }else if ([infoState isEqualToString:@"2"]){
//            NSLog(@"========审核通过");
    
        }else if ([infoState isEqualToString:@"3"]){
//            NSLog(@"========审核未通过");
    
        }else if ([infoState isEqualToString:@"4"]){
//            NSLog(@"========消息列表");
                SystemMessageViewController*systemMessageVc=[[SystemMessageViewController alloc] init];
                [self.navigationController pushViewController:systemMessageVc animated:YES];
        }

//    NSLog(@"消息中心＝＝方法＝＝%s，行数＝＝%d",__FUNCTION__,__LINE__);
//    NSLog(@"=============%@",aNotification);
}
//跳转个人中心
-(void)toUserCenter{
    UserCenterViewController*userCenterVc=[[UserCenterViewController alloc] init];
    [self.navigationController pushViewController:userCenterVc animated:YES];

}
//教练的个人信息
-(void)jiaoLianData{
    //获取教练的审核状态来显示个人中心的不同界面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
  
    //获得用户信息
    NSURL *url = [NSURL URLWithString:OWNERINFO_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];
    NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/findOwnerInfo%@%@",userid,token]];
   
    NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@",userid,sign];
    

    postString=[UTF8Two stringToUTF8Str:postString];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSLog(@"eeeeeee======%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        if (data!=nil) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//            NSLog(@"dddd=========%@",weatherDic);
            
            //从NSUserDefault 如果登陆成功就
            
            
            NSDictionary*beanDic=[weatherDic objectForKey:@"bean"];
//            NSLog(@"=========%@",[beanDic objectForKey:@"cname"]);
//            NSLog(@"=========%@",[beanDic objectForKey:@"photo_zip_url"]);
//            NSLog(@"=========%@",[beanDic objectForKey:@"count"]);
//            NSLog(@"=========%@",[beanDic objectForKey:@"teach_exp"]);
//            NSLog(@"=========%@",[beanDic objectForKey:@"c1_offer"]);
//            NSLog(@"=========%@",[beanDic objectForKey:@"c2_offer"]);
//            NSLog(@"=========%@",[beanDic objectForKey:@"telephone"]);
            NSString*telephoneStr=[beanDic objectForKey:@"telephone"];
            [userDefaults setObject:telephoneStr forKey:telephone];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSURL *url = [NSURL URLWithString:[beanDic objectForKey:@"photo_zip_url"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [[UIImage alloc] initWithData:data];
                _headView.image=image;
                
                _cNameLabel.text=[beanDic objectForKey:@"cname"];
                _jiaoLingLabel.text=[NSString stringWithFormat:@"%@年",[beanDic objectForKey:@"teach_exp"]];
                _c1PriceLabel.text=[beanDic objectForKey:@"c1_offer"];
                _c2PriceLabel.text=[beanDic objectForKey:@"c2_offer"];
                _studentCountLabel.text=[NSString stringWithFormat:@"%@位",[beanDic objectForKey:@"count"]];
            });
        }
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
    
}
//我的学员
- (IBAction)studentButton:(id)sender {
    StudentsViewController*studentVc=[[StudentsViewController alloc] init];
    [self.navigationController pushViewController:studentVc animated:YES];
}
//设置中心
- (IBAction)setCenterButton:(id)sender {
    SetingViewController*setVc=[[SetingViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}
//我的消息
- (IBAction)myMessageButton:(id)sender {
    SystemMessageViewController*messageVc=[[SystemMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVc animated:YES];
}
//钱包
- (IBAction)qianBaoButton:(id)sender {
    WalletsViewController*walletVc=[[WalletsViewController alloc] init];
    [self.navigationController pushViewController:walletVc animated:YES];
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
