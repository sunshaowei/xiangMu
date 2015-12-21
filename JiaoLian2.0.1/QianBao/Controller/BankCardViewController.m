//
//  BankCardViewController.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/16.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "BankCardViewController.h"
#import "WalletTableViewCell.h"
#import "AddTableViewCell.h"
#import "BankCardDetailViewController.h"
#import "AddBankCardStepOneViewController.h"
#import "UTF8Two.h"
#import "MD5.h"
@interface BankCardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) NSMutableArray *cardArr;
@property(nonatomic,retain) NSString *cardId;
@property(nonatomic,assign) NSInteger cellRow;
@end

@implementation BankCardViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cardArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"银行卡";
    [self createTableView];
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
    
    NSURL *url = [NSURL URLWithString:@"http://qqxueche.cn-hangzhou.aliapp.com/rest/native/coach/ol/findBind"];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];
     NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/findBind%@%@",userid,token]];
    
    NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@",userid,sign];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            self.cardArr = [weatherDic objectForKey:@"beans"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
    }];
    [dataTask resume];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12*OffHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 89*OffHeight;
    }else return 160*OffHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }else return self.cardArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        static NSString *add = @"add";
        AddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:add];
        if (!cell) {
            cell = [[AddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:add];
        }
        return cell;
    }else if (indexPath.section == 0){
    static NSString *walletReuse = @"cardReuse";
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:walletReuse];
    if (cell == nil) {
        cell = [[WalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:walletReuse];
    }
        _cellRow = indexPath.row;
        //银行名字
        cell.bankName.text = [[self.cardArr objectAtIndex:indexPath.row] valueForKey:@"myhname"];
        //根据银行名字赋图片
        if ([cell.bankName.text isEqualToString:@"中国银行"]) {
            cell.cardImage.image = [UIImage imageNamed:@"iconfont-zhongguoyinxing@3x.png"];
        }else if ([cell.bankName.text isEqualToString:@"农业银行"]){
            cell.cardImage.image = [UIImage imageNamed:@"iconfont-nongyeyinxing@2x.png"];
        }else if ([cell.bankName.text isEqualToString:@"中国建设银行"]){
            cell.cardImage.image = [UIImage imageNamed:@"iconfont-zhongguojiansheyinxing@3x.png"];
        }else if ([cell.bankName.text isEqualToString:@"交通银行"]){
            cell.cardImage.image = [UIImage imageNamed:@"iconfont-jiaotongyinxing@3x.png"];
        }else if ([cell.bankName.text isEqualToString:@"中国工商银行"]){
            cell.cardImage.image = [UIImage imageNamed:@"iconfont-gongshangyinxing@3x.png"];
        }
        //银行卡号
        NSString *str = [[self.cardArr objectAtIndex:indexPath.row] valueForKey:@"mnum"] ;
        NSString *newStr = @"";
        newStr = [str substringFromIndex:str.length - 4];
        NSString *numText = [NSString stringWithFormat:@"**** **** **** %@",newStr];
        cell.cardNumber.text = numText;
        
        //银行卡类型
        NSString *type = [[self.cardArr objectAtIndex:indexPath.row] valueForKey:@"mtype"];
//        NSLog(@"%@",type);
//        if ([type isEqualToString:@"1"]) {
//            cell.cardStyle.text = @"储蓄卡";
//        }else if ([type isEqualToString:@"2"]){
//            cell.cardStyle.text = @"信用卡";
//        }
        cell.cardStyle.text = type;
        
        //银行卡id
        self.cardId = [[self.cardArr objectAtIndex:indexPath.row] valueForKey:@"id"];
    return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        AddBankCardStepOneViewController *addCard = [[AddBankCardStepOneViewController alloc] init];
        [self.navigationController pushViewController:addCard animated:YES];
    }else{
        BankCardDetailViewController *detail = [[BankCardDetailViewController alloc] init];
        detail.hidesBottomBarWhenPushed = YES;
        
        detail.name = [[self.cardArr objectAtIndex:indexPath.row] valueForKey:@"myhname"];
        //根据银行名字赋图片
        if ([detail.name isEqualToString:@"中国银行"]) {
            detail.picture = [UIImage imageNamed:@"iconfont-zhongguoyinxing@3x.png"];
        }else if ([detail.name isEqualToString:@"农业银行"]){
            detail.picture = [UIImage imageNamed:@"iconfont-nongyeyinxing@2x.png"];
        }else if ([detail.name isEqualToString:@"中国建设银行"]){
            detail.picture = [UIImage imageNamed:@"iconfont-zhongguojiansheyinxing@3x.png"];
        }else if ([detail.name isEqualToString:@"交通银行"]){
            detail.picture = [UIImage imageNamed:@"iconfont-jiaotongyinxing@3x.png"];
        }else if ([detail.name isEqualToString:@"中国工商银行"]){
            detail.picture = [UIImage imageNamed:@"iconfont-gongshangyinxing@3x.png"];
        }
        //银行卡号
        NSString *str = [[self.cardArr objectAtIndex:indexPath.row] valueForKey:@"mnum"] ;
        NSString *newStr = @"";
        newStr = [str substringFromIndex:str.length - 4];
        NSString *numText = [NSString stringWithFormat:@"**** **** **** %@",newStr];
        detail.cardNum = numText;
        
        //银行卡类型
        NSString *type = [[self.cardArr objectAtIndex:indexPath.row] valueForKey:@"mtype"];
//        if ([type isEqualToString:@"1"]) {
//            detail.cardType = @"储蓄卡";
//        }else if ([type isEqualToString:@"2"]){
//            detail.cardType = @"信用卡";
//        }
//
        detail.cardType = type;
        //银行卡id
        detail.cardId = [[self.cardArr objectAtIndex:indexPath.row] valueForKey:@"id"];
        [self.navigationController pushViewController:detail animated:YES];
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
