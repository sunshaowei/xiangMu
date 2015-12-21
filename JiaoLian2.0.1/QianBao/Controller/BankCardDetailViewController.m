//
//  BankCardDetailViewController.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "BankCardDetailViewController.h"
#import "WalletTableViewCell.h"
@interface BankCardDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,assign) NSInteger numRow;
@end

@implementation BankCardDetailViewController

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
    self.navigationItem.title = @"银行卡";
    [self createTableView];
    [self changeNavigationController];
    _numRow = 1;
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
- (void)changeNavigationController
{
    //解除绑定银行卡
    UIButton *deleteCardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [deleteCardButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    [deleteCardButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteCardButton];
}

- (void)deleteAction:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"解除绑定" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"http://192.168.55.100:8080/rest/native/coach/ol/delCountRcd"];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod=@"POST";
        
        NSString * postString =[NSString stringWithFormat:@"id=1118&test=1&card_id=%@",self.cardId];
        NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
        request.HTTPBody=postData;
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                _numRow = 0;
                [self.tableView reloadData];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }];
        //任务创建后，不会立即执行，调用resume 立即执行;
        [dataTask resume];
    }];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:^{
        
        
    }];
                                
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numRow;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cardDetail = @"cardDetail";
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardDetail];
    if (!cell) {
        cell = [[WalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardDetail];
    }
    cell.cardImage.image = _picture;
    cell.bankName.text = _name;
    cell.cardStyle.text = _cardType;
    cell.cardNumber.text = _cardNum;
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
