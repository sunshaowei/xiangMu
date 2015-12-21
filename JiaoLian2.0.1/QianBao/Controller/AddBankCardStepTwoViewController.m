//
//  AddBankCardStepTwoViewController.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "AddBankCardStepTwoViewController.h"
#import "AddStepTableViewCell.h"
#import "Color.h"
#import "UTF8Two.h"
#import "MD5.h"

@interface AddBankCardStepTwoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSString *idCardStr;
@property(nonatomic,retain) NSString *phoneNumStr;
@property(nonatomic,retain) NSIndexPath *idcardIndexPath;
@property(nonatomic,retain) NSIndexPath *phoneNumIndexPath;
@end

@implementation AddBankCardStepTwoViewController
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
    self.navigationItem.title = @"添加银行卡 2/2";
    [self createTableView];
    [self createConfirmButton];
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
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*OffHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90*OffHeight;
}

- (void)sendBankName:(NSString *)bankName cardStype:(NSString *)stype logourl:(NSString *)logo cardNum:(NSString *)cardNum cardHolder:(NSString *)holder
{
    _bankname = bankName;
    _cardtype = stype;
    _logourl = logo;
    _cardNum = cardNum;
    _cardHolder = holder;
//    NSLog(@"%@== %@== %@== %@== %@==",_bankname,_cardtype,_logourl,_cardNum,_cardHolder);
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = [NSString stringWithFormat:@"卡类型   %@  %@",_bankname,_cardtype];
    return str;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *idCard = @"idCard";
        AddStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCard];
        if (!cell) {
            cell = [[AddStepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCard];
        }
        cell.nameLable.text = @"身份证号";
        cell.nameField.placeholder = @"请输入您的身份证号";
        cell.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.nameField.keyboardType = UIKeyboardTypeNumberPad;
        _idcardIndexPath = indexPath;
        return cell;
    }else{
        static NSString *phone = @"phone";
        AddStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phone];
        if (!cell) {
            cell = [[AddStepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:phone];
        }
        _phoneNumIndexPath = indexPath;
        cell.nameLable.text = @"预留手机号";
        cell.nameField.placeholder = @"请输入您常用的手机号码";
        cell.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.nameField.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
    }
    return nil;
}

- (void)createConfirmButton
{
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 80*OffWidth, 44*OffHeight)];
    confirmButton.backgroundColor = kUIColorFromRGB(0x61bfab);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 10;
    [self.view addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.center = self.view.center;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:22.5];
    
}
- (void)confirmAction:(id)sender
{
    AddStepTableViewCell *idCardCell = [self.tableView cellForRowAtIndexPath:_idcardIndexPath];
    _idCardStr = idCardCell.nameField.text;
    
    AddStepTableViewCell *phoneCell = [self.tableView cellForRowAtIndexPath:_phoneNumIndexPath];
    _phoneNumStr = phoneCell.nameField.text;
    if (_phoneNumStr.length != 11 && _idCardStr.length == 18) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:^{
        
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
                }];
                [alert addAction:okAction];
    }else if (_idCardStr.length != 18){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"身份证号输入有误" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
    }else{
    NSURL *url = [NSURL URLWithString:@"http://qqxueche.cn-hangzhou.aliapp.com/rest/native/coach/ol/myBind"];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString*userid =[userDefaults objectForKey:USER_ID];
        NSString*token=[userDefaults objectForKey:TOKEN];
        NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/myBind%@%@",userid,token]];
        
    NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@&mname=%@&mnum=%@&mtype=%@&myhname=%@&id_card=%@&mtel=%@",userid,sign,_cardHolder,_cardNum,_cardtype,_bankname,_idCardStr,_phoneNumStr];
        NSLog(@"%@",postString);
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//            NSLog(@"weatherDic=========%@",weatherDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert  =[UIAlertController alertControllerWithTitle:@"提示" message:@"此银行卡已经绑定成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
        });
        
    }];
    [dataTask resume];
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
