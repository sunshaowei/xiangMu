//
//  IncomeDetailViewController.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/24.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "IncomeDetailViewController.h"
#import "IncomeDetailTableViewCell.h"
#import "Color.h"
#import "MD5.h"
#import "UTF8Two.h"
@interface IncomeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *incomeArray;
@end

@implementation IncomeDetailViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.incomeArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  =[UIColor whiteColor];
    self.navigationItem.title = @"收入明细";
    [self creatableView];
    [self changeBackButton];
    
}
- (void)changeBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40*OffWidth, 40*OffHeight)];
    [backButton setImage:[UIImage imageNamed:@"back@3x.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self handleData];
}

- (void)handleData
{
    
    NSURL *url = [NSURL URLWithString:@"http://qqxueche.cn-hangzhou.aliapp.com/rest/native/coach/ol/findCountRcd"];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];
    NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/findCountRcd%@%@",userid,token]];
    
    NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@",userid,sign];
    postString=[UTF8Two stringToUTF8Str:postString];
   // NSLog(@"=========%@",postString);

    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //if (dataTask != nil) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//            NSLog(@"========%@",weatherDic);
            self.incomeArray = [weatherDic objectForKey:@"beans"];
            //[self.tableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        //}
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
}
- (void)creatableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.incomeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*OffHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *incomeReuse = @"incomeReuse";
    IncomeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:incomeReuse];
    if (!cell) {
        cell = [[IncomeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:incomeReuse];
    }
    if ([[[self.incomeArray objectAtIndex:indexPath.row] valueForKey:@"change_type"] isEqualToString:@"1"]) {
        cell.reasonLable.textColor = kUIColorFromRGB(0x6fc4b2);
        cell.timeLable.textColor = kUIColorFromRGB(0x6fc4b2);
        cell.money.textColor = kUIColorFromRGB(0x6fc4b2);
        NSString *str1 = [[self.incomeArray objectAtIndex:indexPath.row] valueForKey:@"rcd_desc"];
        NSString *str2 = [[self.incomeArray objectAtIndex:indexPath.row] valueForKey:@"change_num"];
        cell.reasonLable.text = str1;
        cell.money.text = str2;
        cell.timeLable.text = [[self.incomeArray objectAtIndex:indexPath.row] valueForKey:@"rcd_time"];
        
//        id result;
//        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//        result=[f numberFromString:str2];
//        if(!(result))
//        {
//            result=str2;
//        }
//        NSLog(@"%.2f",[result floatValue]);
//        
//        
//        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//        _moneyCount = [numberFormatter stringFromNumber:result];
//        NSLog(@"%@",_moneyCount);
//        [self.delegate sendMoneyCount:_moneyCount];
        
    }else if ([[[self.incomeArray objectAtIndex:indexPath.row] valueForKey:@"change_type"] isEqualToString:@"2"]){
        cell.reasonLable.textColor = [UIColor redColor];
        cell.timeLable.textColor = [UIColor redColor];
        cell.money.textColor = [UIColor redColor];
        NSString *str1 = [[self.incomeArray objectAtIndex:indexPath.row] valueForKey:@"rcd_desc"];
        NSString *str2 = [[self.incomeArray objectAtIndex:indexPath.row] valueForKey:@"change_num"];
        cell.reasonLable.text = str1;
        cell.money.text = str2;
        cell.timeLable.text = [[self.incomeArray objectAtIndex:indexPath.row] valueForKey:@"rcd_time"];
    }
    
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
