//
//  UserCenterViewController.m
//  JiaoLian2.0.1
//
//  Created by 孙少伟 on 15/11/25.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "UserCenterViewController.h"
#import "TouXaingCell.h"
#import "C1C2BaoJiaCell.h"
#import "JiaoLianModel.h"
#import "CCBaoJiaViewController.h"
#import "UIImageView+WebCache.h"
#import <AliyunOSSiOS/OSSService.h>
#import "MD5.h"
#import "UTF8Two.h"



@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property JiaoLianModel*oneJiaolian;
@property(nonatomic,retain) UIImagePickerController *picController;
@property  OSSClient*client;

@end


@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.title=@"个人中心";
    
    NSString *endpoint =@"http://oss-cn-hangzhou.aliyuncs.com";
    
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"oUUe8xpqpq5XrGSj"
                                                                                                            secretKey:@"Q722qe9Lzhe3gXFlYuCyU0k5jWsncO"];
    _client= [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    [self jiaoLianData];
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
          
            _oneJiaolian=[[JiaoLianModel alloc] init];
            [_oneJiaolian setValuesForKeysWithDictionary:beanDic];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                NSURL *url = [NSURL URLWithString:[beanDic objectForKey:@"photo_url"]];
//                NSData *data = [NSData dataWithContentsOfURL:url];
//                UIImage *image = [[UIImage alloc] initWithData:data];
                [_tableView reloadData];
            });
        }
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else
        return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            TouXaingCell   * cell = [[[NSBundle mainBundle] loadNibNamed:@"TouXaingCell"  owner:self options:nil] lastObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                                NSURL *url = [NSURL URLWithString:_oneJiaolian.photo_zip_url];



                
                [cell.touXiangView sd_setImageWithURL:url];

            });
            return cell;
        }else if (indexPath.row==1){
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"www"];
            cell.textLabel.text=@"名字";
            cell.detailTextLabel.text=_oneJiaolian.cname;

            return cell;
            
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"www"];
            cell.textLabel.text=@"性别";
            cell.detailTextLabel.text=_oneJiaolian.cname;
            return cell;
        }
        
    }else{
        if (indexPath.row==0) {
            C1C2BaoJiaCell   * cell = [[[NSBundle mainBundle] loadNibNamed:@"C1C2BaoJiaCell"  owner:self options:nil] lastObject];
            cell.c1c2BiaoQianLabel.text=@"C1价格";
            if ([_oneJiaolian.c1_offer intValue]<0) {
                cell.c1c2Pricelabel.text=@"点击报价";
            }else{
                cell.c1c2Pricelabel.text=[NSString stringWithFormat:@"￥%@",_oneJiaolian.c1_offer];;
            }
            
            
            return cell;
        }else if (indexPath.row==1){
            C1C2BaoJiaCell   * cell = [[[NSBundle mainBundle] loadNibNamed:@"C1C2BaoJiaCell"  owner:self options:nil] lastObject];
            cell.c1c2BiaoQianLabel.text=@"C2价格";
            
            if ([_oneJiaolian.c2_offer intValue]<0) {
                cell.c1c2Pricelabel.text=@"点击报价";
            }else{
                cell.c1c2Pricelabel.text=[NSString stringWithFormat:@"￥%@",_oneJiaolian.c2_offer];;
            }
            return cell;

        }else if (indexPath.row==2){
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"www"];
            cell.textLabel.text=@"驾校名称";
            cell.detailTextLabel.text=_oneJiaolian.schname;
            return cell;

        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"www"];
            cell.textLabel.text=@"训练场地";
            cell.detailTextLabel.text=_oneJiaolian.driving_coaching_grid;
            return cell;
        }
       
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 20;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 100;
        }else{
            return 44;
        }
    }else{
        return 44;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
//        NSLog(@"=========头像");
        
        self.picController = [[UIImagePickerController alloc] init];
        self.picController.delegate = self;
        self.picController.allowsEditing = YES;
        self.picController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picController animated:YES completion:nil];
        
        
        
        
        
        
    }else if (indexPath.section==1&&indexPath.row==0){
        CCBaoJiaViewController*ccBaoJiaVc=[[CCBaoJiaViewController alloc] init];
        ccBaoJiaVc.ccBaojiaStr=@"C1";
        [self.navigationController pushViewController:ccBaoJiaVc animated:YES];
    }else if (indexPath.section==1&&indexPath.row==1){
        CCBaoJiaViewController*ccBaoJiaVc=[[CCBaoJiaViewController alloc] init];
        ccBaoJiaVc.ccBaojiaStr=@"C2";
        [self.navigationController pushViewController:ccBaoJiaVc animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = @"sxposs";

   
    
    
        //设置上传的名字
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString*userId=[userDefaults objectForKey:USER_ID];
    
        //从字典中获得图片类型
        NSString*str=[NSString stringWithFormat:@"%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
    NSArray *array = [str componentsSeparatedByString:@"="];
    
    NSString*str2=array[array.count-1];

    
        put.objectKey = [NSString stringWithFormat:@"coachupload/%@/4.%@",userId,str2];

//    NSLog(@"=========%@",put.objectKey);


    UIImage *newPic = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    NSData* data = UIImageJPEGRepresentation(newPic, 0.01);
    
    
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [_client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
//            NSLog(@"upload object success!");
            TouXaingCell   * cell=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                
                cell.touXiangView.image=newPic;
                
                [self.picController dismissViewControllerAnimated:YES completion:nil];
                
            });
           
        } else {
//            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];


    
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
