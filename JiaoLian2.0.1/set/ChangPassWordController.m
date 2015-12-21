//
//  ChangPassWordController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "ChangPassWordController.h"
#import "ChangPassCell.h"
#import "MD5.h"
#import "Color.h"
#import "UTF8Two.h"
@interface ChangPassWordController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//成功button
@property (weak, nonatomic) IBOutlet UIButton *successButon;
@end

@implementation ChangPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"修改密码";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=kUIColorFromRGB(0x6fc4b2);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
//    _successButon.con
    _successButon.layer.masksToBounds = YES;
    _successButon.layer.cornerRadius = 6.0;
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    
    ChangPassCell*cell0=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ChangPassCell*cell1=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ChangPassCell*cell2=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSString*ordPass=cell0.rightFeid.text;
    NSString*newPass1=cell1.rightFeid.text;
    NSString*newPass2=cell2.rightFeid.text;
    if ([newPass1 isEqualToString:newPass2]) {
        NSURL *url = [NSURL URLWithString:UP_PASSWORD_URL];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod=@"POST";
        
        NSString*userid =[userDefaults objectForKey:USER_ID];
//        NSString*token=[userDefaults objectForKey:TOKEN];
//        NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/upPassword%@%@",userid,token]];
      
        
        NSString*password=[MD5 stringToMD5Str:ordPass];
        NSString*password2=[MD5 stringToMD5Str:newPass2];
        
        NSString * postString =[NSString stringWithFormat:@"id=%@&password=%@&password2=%@&sign=123",userid,password,password2];
        postString=[UTF8Two stringToUTF8Str:postString];
        NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
        request.HTTPBody=postData;
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSLog(@"=========%@",request.HTTPMethod);
//            
//            NSLog(@"eeeeeee======%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }];
        //任务创建后，不会立即执行，调用resume 立即执行;
        [dataTask resume];
    }else{
//        NSLog(@"=========%@",@"两次输入的密码不一样");
     UIAlertController*alert=[UIAlertController alertControllerWithTitle:nil message:@"验证失败请重新获得验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];

    }
    
    
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
ChangPassCell   * cell = [[[NSBundle mainBundle] loadNibNamed:@"ChangPassCell"  owner:self options:nil] lastObject];
    if (indexPath.row==0) {
        cell.leftLabel.text=@"当前密码";
    }else if (indexPath.row==1)
        cell.leftLabel.text=@"新密码  ";
    else
        cell.leftLabel.text=@"确认密码";
    return cell;
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
