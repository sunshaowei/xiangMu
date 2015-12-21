//
//  WalletsViewController.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/16.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "WalletsViewController.h"
#import "BankCardViewController.h"
#import "WithdrawalsViewController.h"
#import "BalanceTableViewCell.h"
#import "CardAndIncomeDetailTableViewCell.h"
#import "Color.h"
#import "IncomeDetailViewController.h"
#import "AddBankCardStepOneViewController.h"
#import "MD5.h"
#import "UTF8Two.h"

@interface WalletsViewController ()<UITableViewDataSource,UITableViewDelegate,BalanceTableViewCellDelegate>
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSIndexPath *firstIndexPath;
@property(nonatomic,strong) NSString *banlanceStr;
@end

@implementation WalletsViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的钱包";
    self.navigationController.navigationBar.barTintColor = kUIColorFromRGB(0x6fc4b2);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self createTableViews];
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
    NSURL *url = [NSURL URLWithString:@"http://qqxueche.cn-hangzhou.aliapp.com/rest/native/coach/ol/queryBanlance"];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];
    NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/queryBanlance%@%@",userid,token]];
    
    NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@",userid,sign];
    postString=[UTF8Two stringToUTF8Str:postString];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSDictionary *beanDic = [weatherDic valueForKey:@"bean"];
            _banlanceStr = [beanDic valueForKey:@"banlance"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
}
- (void)createTableViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *balance = @"balance";
        BalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:balance];
        if (!cell) {
            cell = [[BalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:balance];
        }
        _firstIndexPath = indexPath;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *bStr = [NSString stringWithFormat:@"余额 %@",_banlanceStr];
        cell.balanceLable.text = bStr;
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            static NSString *card = @"card";
            CardAndIncomeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:card];
            if (!cell) {
                cell = [[CardAndIncomeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:card];
            }
            cell.picView.image = [UIImage imageNamed:@"iconfont-yinxingqia@3x.png"];
            cell.nameLable.text = @"银行卡";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            static NSString *income = @"income";
            CardAndIncomeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:income];
            if (!cell) {
                cell = [[CardAndIncomeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:income];
            }
            cell.picView.image = [UIImage imageNamed:@"iconfont-mingxi@3x.png"];
            cell.nameLable.text = @"收入明细";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 76*OffHeight;
    }else
    return 70*OffHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10*OffHeight;
    }else{
        return 20*OffHeight;
    }
}

- (void)withdrawsButtonAction:(id)sender
{
    WithdrawalsViewController *withdrawals = [[WithdrawalsViewController alloc] init];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://qqxueche.cn-hangzhou.aliapp.com/rest/native/coach/ol/findBind"];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];
      NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/findBind%@%@",userid,token]];
    NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@",userid,sign];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        NSArray *arr = [weatherDic objectForKey:@"beans"];
        if (arr.count == 0) {
            AddBankCardStepOneViewController *oneStep = [[AddBankCardStepOneViewController alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:oneStep animated:YES];
            });
            
            
        }else{
            withdrawals.banlanceStr = _banlanceStr;
            withdrawals.hidesBottomBarWhenPushed = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:withdrawals animated:YES];
            });
           // [self.navigationController pushViewController:withdrawals animated:YES];
            
        }
        
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            BankCardViewController *bankCard = [[BankCardViewController alloc] init];
            bankCard.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bankCard animated:YES];
        }else {
            IncomeDetailViewController *incomeDetail = [[IncomeDetailViewController alloc] init];
            [self.navigationController pushViewController:incomeDetail animated:YES];
        }
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
