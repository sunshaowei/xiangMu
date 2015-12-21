//
//  AddBankCardStepOneViewController.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "AddBankCardStepOneViewController.h"
#import "AddStepTableViewCell.h"
#import "Color.h"
#import "AddBankCardStepTwoViewController.h"
#import "UTF8Two.h"
#import "MD5.h"
@interface AddBankCardStepOneViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSString *numStr;
@property(nonatomic,retain) NSString *nameStr;
@property(nonatomic,retain) NSIndexPath *namePath;
@property(nonatomic,retain) NSIndexPath *numPath;

@property(nonatomic,retain) AddBankCardStepTwoViewController *stepTwo;

@property(nonatomic,retain) NSString *cardtype;
@property(nonatomic,retain) NSString *cardlength;
@property(nonatomic,retain) NSString *bankname;
@property(nonatomic,retain) NSString *logourl;

@property(nonatomic,retain) NSString *statusStr;
@property(nonatomic,retain) UIAlertController *alertCotroller;

@property(nonatomic,strong) NSMutableArray *cardNumArr;

@end

@implementation AddBankCardStepOneViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cardNumArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加银行卡 1/2";
    [self createTableView];
    [self createNextButton];
    [self cardNum];
    [self changeBackButton];
}
- (void)changeBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40*OffWidth, 40 * OffHeight)];
    [backButton setImage:[UIImage imageNamed:@"back@3x.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cardNum
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
            self.cardNumArr = [[weatherDic objectForKey:@"beans"] valueForKey:@"mnum"];
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
}
- (void)createTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40 * OffHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *contentStr = @"请绑定持卡人本人的银行卡";
    return contentStr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 * OffHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *name = @"name";
        AddStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
        if (!cell) {
            cell = [[AddStepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
        }
        cell.nameLable.text = @"持卡人";
        cell.nameField.placeholder = @"请输入持卡人姓名";
        cell.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _namePath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        static NSString *card = @"cardNum";
        AddStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:card];
        if (!cell) {
            cell = [[AddStepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:card];
        }
        cell.nameLable.text = @"银行卡";
        cell.nameField.placeholder = @"请输入银行卡号";
        cell.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.nameField.keyboardType = UIKeyboardTypeNumberPad;
        _numPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (void)createNextButton
{
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width -80 * OffWidth, 44 * OffHeight)];
    nextButton.center = self.view.center;
    [self.view addSubview:nextButton];
    nextButton.backgroundColor = kUIColorFromRGB(0x61bfab);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 10;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:22.5];
}

- (void)nextAction:(id)sender
{
    _stepTwo = [[AddBankCardStepTwoViewController alloc] init];
    AddStepTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:_namePath];
    AddStepTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_numPath];
    _nameStr = nameCell.nameField.text;
    _numStr = cell.nameField.text;
    _stepTwo.cardHolder = _nameStr;
    _stepTwo.cardNum = _numStr;
    
    //银行卡号个数不对,则弹出提示框
    if (_numStr.length >19 || _numStr.length < 14) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"卡号输入有误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [self.navigationController presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
    NSString *httpUrl = @"http://apis.baidu.com/datatiny/cardinfo_vip/cardinfo_vip";
    NSString *str = [NSString stringWithFormat:@"cardnum=%@",_numStr];
    NSString *httpArg = str;
    [self request: httpUrl withHttpArg: httpArg];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController pushViewController:_stepTwo animated:YES];
//    });
    
    for (NSString *number in self.cardNumArr) {
        if ([number isEqualToString:_numStr]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"此卡已经被绑定过" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:okAction];
        }
    }
}


-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg
{
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"ee7d2c9a2a0ea944749ec03c1183f331" forHTTPHeaderField: @"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"HttpResponseCode:%ld", responseCode);
        NSLog(@"HttpResponseBody %@",responseString);
        
        
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *dic = [weatherDic valueForKey:@"data"];
       // NSLog(@"%@",dic);
        
        _cardtype = [dic valueForKey:@"cardtype"];
        _cardlength = [dic valueForKey:@"cardlength"];
        _bankname = [dic valueForKey:@"bankname"];
        _logourl = [[[dic valueForKey:@"bankinfo"] objectAtIndex:0]objectForKey:@"logourl"];
        _stepTwo.bankname = _bankname;
        _stepTwo.cardtype = _cardtype;
        
        //如果不是五大银行则弹出提示框:对不起,此app目前只支持五大银行
        if ((![_bankname isEqualToString:@"中国银行"]) && (![_bankname isEqualToString:@"中国建设银行"]) && (![_bankname isEqualToString:@"中国工商银行"]) && (![_bankname isEqualToString:@"交通银行"]) && (![_bankname isEqualToString:@"中国农业银行"])) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起,此APP目前只支持五大银行" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:okAction];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            });        }
        
        [_stepTwo sendBankName:_bankname cardStype:_cardtype logourl:_logourl cardNum:_numStr cardHolder:_nameStr];
//        NSLog(@"%@-----%@",_stepTwo.bankname,_stepTwo.cardtype);
        NSDictionary *dataDic = [weatherDic valueForKey:@"data"];
        BOOL isLuhn = [dataDic valueForKey:@"isLuhn"];
       // NSLog(@"---%d",isLuhn);
        if (isLuhn == 0) {
            _alertCotroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的卡号" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [_alertCotroller addAction:action];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:_alertCotroller animated:YES completion:^{
                    
                }];
            });
            
            
        }
        else if (isLuhn == 1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:_stepTwo animated:YES];
            });
            
        }
        
    }];
    [dataTask resume];
    //任务创建后，不会立即执行，调用resume 立即执行;
    
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
