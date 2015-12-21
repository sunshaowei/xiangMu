//
//  WithdrawalsViewController.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/17.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "BalanceWithdrawalsTableViewCell.h"
#import "AddStepTableViewCell.h"
#import "Color.h"
#import "ChooseView.h"
#import "WalletTableViewCell.h"
#import "AddTableViewCell.h"
#import "AddView.h"
#import "AddBankCardStepOneViewController.h"
#import "UTF8Two.h"
#import "MD5.h"

NSInteger currentRow;
@interface WithdrawalsViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseViewDelegate>
@property(nonatomic,retain) UIView *nightView;
@property(nonatomic,retain) UIView *downView;
@property(nonatomic,retain) UIButton *confirmWithdrawals;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) UITableView *downTableView;
@property(nonatomic,retain) AddStepTableViewCell *cell;
@property(nonatomic,retain) UIImageView *selectedPic;
@property(nonatomic,retain) NSMutableArray *resultArr;
@property(nonatomic,retain) NSString *cardId; //需要体现到哪个银行卡的银行卡号
@property(nonatomic,retain) NSString *moneyCount; //提现数目
@property(nonatomic,retain) NSIndexPath *path;
@property(nonatomic,retain) NSString *drawCardId; //提现的银行卡的id
@property(nonatomic,retain) NSMutableArray *cardIdArr; //银行卡的id的数组
@property(nonatomic,assign) NSInteger indRow; //默认展示在view上的cell是数组中的哪个银行卡
@end

@implementation WithdrawalsViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.resultArr = [NSMutableArray array];
        self.cardIdArr = [NSMutableArray array];
        _selectedPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 10, 10)];
        _selectedPic.image = [UIImage imageNamed:@"iconfont-zhengque-(1)@2x.png"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"余额提现";
    self.nightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    self.nightView.backgroundColor = [UIColor blackColor];
    self.nightView.alpha = 0.5;
    [self changeBackButton];
    [self createSubviews];
    [self handleData];
}

- (void)changeBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40 * OffWidth, 40 * OffHeight)];
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
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            self.resultArr = [weatherDic objectForKey:@"beans"];
        NSLog(@"%@",self.resultArr);
        for (NSDictionary *dic in _resultArr) {
            _cardId = [dic valueForKey:@"id"];
            _drawCardId = [dic valueForKey:@"draw_mcard_id"];
            if ([_cardId isEqualToString:_drawCardId]) {
                NSLog(@"indRow == %ld",_indRow);
                _indRow = [_resultArr indexOfObject:dic];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
                [self createTableView];
        });
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 * OffHeight, self.view.frame.size.width, 250*OffHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 2;
    }else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%ld",self.resultArr.count);
    if (tableView == self.tableView) {
        return 1;
    }else {
        return self.resultArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 12*OffHeight;
    }else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return 130*OffHeight;
        }else return 90*OffHeight;
    }else return 125*OffHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentRow= indexPath.row;
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            static NSString *bank = @"bank";
            BalanceWithdrawalsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bank];
            if (!cell) {
                cell = [[BalanceWithdrawalsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bank];
            }
            _path = indexPath;
            NSLog(@"%ld",_indRow);
            if (_resultArr.count > 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSString *bankName = [[self.resultArr objectAtIndex:_indRow] valueForKey:@"myhname"];
                NSLog(@"%@",bankName);
                cell.bankName.text = bankName;
                
                NSString *str = [[self.resultArr objectAtIndex:_indRow] valueForKey:@"mnum"] ;
                NSString *newStr = @"";
                newStr = [str substringFromIndex:str.length - 4];
                NSLog(@"%@",newStr);
                NSString *numText = [NSString stringWithFormat:@"**** **** **** %@",newStr];
                cell.cardNumber.text = numText;
                
                NSString *type = [[self.resultArr objectAtIndex:_indRow] valueForKey:@"mtype"];
                if ([type isEqualToString:@"1"]) {
                    cell.cardStyle.text = @"信用卡";
                }else{
                    cell.cardStyle.text = @"储蓄卡";
                }
                if ([cell.bankName.text isEqualToString:@"中国银行"]) {
                    cell.cardImage.image = [UIImage imageNamed:@"iconfont-zhongguoyinxing@2x.png"];
                }else if([cell.bankName.text isEqualToString:@"农业银行"]){
                    cell.cardImage.image = [UIImage imageNamed:@"iconfont-nongyeyinxing@2x.png"];
                }else if ([cell.bankName.text isEqualToString:@"中国建设银行"]){
                    cell.cardImage.image = [UIImage imageNamed:@"iconfont-zhongguojiansheyinxing@3x.png"];
                }else if ([cell.bankName.text isEqualToString:@"交通银行"]){
                    cell.cardImage.image = [UIImage imageNamed:@"iconfont-jiaotongyinxing@3x.png"];
                }else if ([cell.bankName.text isEqualToString:@"中国工商银行"]){
                    cell.cardImage.image = [UIImage imageNamed:@"iconfont-gongshangyinxing@3x.png"];
                }
            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            NSString *bankName = [[self.resultArr objectAtIndex:_indRow] valueForKey:@"myhname"];
//            NSLog(@"%@",bankName);
//            cell.bankName.text = bankName;
//            
//            NSString *str = [[self.resultArr objectAtIndex:_indRow] valueForKey:@"mnum"] ;
//            NSString *newStr = @"";
//            newStr = [str substringFromIndex:str.length - 4];
//            NSLog(@"%@",newStr);
//            NSString *numText = [NSString stringWithFormat:@"**** **** **** %@",newStr];
//            cell.cardNumber.text = numText;
//           
//            NSString *type = [[self.resultArr objectAtIndex:_indRow] valueForKey:@"mtype"];
//            if ([type isEqualToString:@"1"]) {
//                cell.cardStyle.text = @"信用卡";
//            }else{
//                cell.cardStyle.text = @"储蓄卡";
//            }
//            if ([cell.bankName.text isEqualToString:@"中国银行"]) {
//                cell.cardImage.image = [UIImage imageNamed:@"iconfont-zhongguoyinxing@2x.png"];
//            }else if([cell.bankName.text isEqualToString:@"农业银行"]){
//                cell.cardImage.image = [UIImage imageNamed:@"iconfont-nongyeyinxing@2x.png"];
//            }else if ([cell.bankName.text isEqualToString:@"中国建设银行"]){
//                cell.cardImage.image = [UIImage imageNamed:@"iconfont-zhongguojiansheyinxing@3x.png"];
//            }else if ([cell.bankName.text isEqualToString:@"交通银行"]){
//                cell.cardImage.image = [UIImage imageNamed:@"iconfont-jiaotongyinxing@3x.png"];
//            }else if ([cell.bankName.text isEqualToString:@"中国工商银行"]){
//                cell.cardImage.image = [UIImage imageNamed:@"iconfont-gongshangyinxing@3x.png"];
//            }
            
            return cell;
        }else {
            static NSString *balance = @"Balance";
            self.cell = [tableView dequeueReusableCellWithIdentifier:balance];
            if (!_cell) {
                _cell = [[AddStepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:balance];
            }
            _cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _cell.nameLable.text = @"金额 (元)";
            NSString *bStr = [NSString stringWithFormat:@"当前可提现余额为%@元",_banlanceStr];
            _cell.nameField.placeholder = bStr;
            _cell.nameField.keyboardType = UIKeyboardTypeNumberPad;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:_cell.nameField];
           return _cell;
        }
    }else {
            static NSString *chooseCard = @"chooseCard";
            WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseCard];
            if (!cell) {
                cell = [[WalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseCard];
            }
        
        cell.bankName.text = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"myhname"];
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
        
        NSString *str = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"mnum"] ;
        NSString *newStr = @"";
        newStr = [str substringFromIndex:str.length - 4];
        NSString *numText = [NSString stringWithFormat:@"**** **** **** %@",newStr];
        cell.cardNumber.text = numText;
        NSString *type = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"mtype"];
//        if ([type isEqualToString:@"1"]) {
//            cell.cardStyle.text = @"储蓄卡";
//        }else if ([type isEqualToString:@"2"]){
//            cell.cardStyle.text = @"信用卡";
//        }
        cell.cardStyle.text = type;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            [self.view.window addSubview:self.nightView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [self.nightView addGestureRecognizer:tap];
            self.nightView.userInteractionEnabled = YES;
            
            self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height - 300)];
            [self.view addSubview:_downView];
            _downView.backgroundColor = [UIColor whiteColor];
            
            ChooseView *topView = [[ChooseView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
            topView.delegate = self;
            [self.downView addSubview:topView];
            
            
            self.downTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.downView.frame.size.height-180) style:UITableViewStylePlain];
            self.downTableView.dataSource = self;
            self.downTableView.delegate = self;
            [self.downView addSubview:self.downTableView];
            [self.downTableView reloadData];
            
            //添加银行卡的view
            AddView *addView = [[AddView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height + self.downTableView.frame.size.height, self.view.frame.size.width, 55)];
            UITapGestureRecognizer *addtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addClick:)];
            [addView addGestureRecognizer:addtap];
            addView.userInteractionEnabled = YES;
            [self.downView addSubview:addView];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, addView.frame.origin.y + addView.frame.size.height, self.view.frame.size.width, 5)];
            [self.downView addSubview:lineView];
            lineView.backgroundColor = [UIColor grayColor];
            lineView.alpha = 0.3;
            
            
            //选择完银行卡后点击的确定按钮
            UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, addView.frame.origin.y + addView.frame.size.height + 10, self.view.frame.size.width, 60)];
            [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            confirmButton.titleLabel.font = [UIFont systemFontOfSize:22.5];
            [confirmButton setTitleColor:kUIColorFromRGB(0x61bfab) forState:UIControlStateNormal];
            [confirmButton addTarget:self action:@selector(conAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.downView addSubview:confirmButton];
            
        }
    }
    else{
        currentRow = indexPath.row;
        if (currentRow == indexPath.row) {
            //WalletTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            //[cell.selectedButton setImage:nil forState:UIControlStateNormal];
//            BOOL isSelected = [cell.selectedButton isSelected];
//            NSLog(@"***%d",isSelected);
//            if (!isSelected) {
//                [cell.selectedButton setImage:[UIImage imageNamed:@"iconfont-zhengque-(1)@3x.png"] forState:UIControlStateNormal];
//            }else{
//            [cell.selectedButton setImage:nil forState:UIControlStateSelected];
//            }
           // _currentRow = indexPath.row;
            
//            if (cell.selectedButton.isSelected == YES) {
//                [cell.selectedButton setImage:_selectedPic.image forState:UIControlStateSelected];
//            }else if (cell.selectedButton.isSelected == NO){
//                [cell.selectedButton setImage:_selectedPic.image forState:UIControlStateNormal];
//            }
           // [self.downTableView reloadData];
        }else{
            NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
            WalletTableViewCell *cell =(WalletTableViewCell *)[tableView cellForRowAtIndexPath:path];
            [cell.selectedButton setImage:nil forState:UIControlStateNormal];
        }
//        [[NSUserDefaults standardUserDefaults] setValue:[_resultArr objectAtIndex:indexPath.row] forKey:@"bankName"];
    }
    //NSLog(@"%ld",currentRow);
}

- (void)conAction:(id)sender
{
    NSDictionary *dic = [self.resultArr objectAtIndex:currentRow];
    _drawCardId = [dic valueForKey:@"draw_mcard_id"];
    BalanceWithdrawalsTableViewCell *cell =[self.tableView cellForRowAtIndexPath:_path];
    
    _cardId = [dic valueForKey:@"id"];
    NSString *name = [dic valueForKey:@"myhname"];
    cell.bankName.text = name;
    
    NSString *type = [dic valueForKey:@"mtype"];
//    if ([type isEqualToString:@"1"]) {
//        cell.cardStyle.text = @"储蓄卡";
//    }else{
//        cell.cardStyle.text = @"信用卡";
//    }
    cell.cardStyle .text = type;
    NSString *number = [dic valueForKey:@"mnum"];
    NSString *newStr = [number substringFromIndex:number.length - 4];
    NSString *numText = [NSString stringWithFormat:@"**** **** **** %@",newStr];
    cell.cardNumber.text = numText;
    
    if ([name isEqualToString:@"中国银行"]) {
        cell.cardImage.image = [UIImage imageNamed:@"iconfont-zhongguoyinxing@3x.png"];
    }else if ([name isEqualToString:@"中国建设银行"]){
        cell.cardImage.image = [UIImage imageNamed:@"iconfont-zhongguojiansheyinxing@3x.png"];
    }else if ([name isEqualToString:@"农业银行"]){
        cell.cardImage.image = [UIImage imageNamed:@"iconfont-nongyeyinxing@3x.png"];
    }else if ([name isEqualToString:@"交通银行"]){
        cell.cardImage.image = [UIImage imageNamed:@"iconfont-jiaotongyinxing@3x.png"];
    }else if ([name isEqualToString:@"工商银行"]){
        cell.cardImage.image = [UIImage imageNamed:@"iconfont-gongshangyinxing@3x.png"];
    }
    
    [self.nightView removeFromSuperview];
    [self.downView removeFromSuperview];
}

- (void)pushBack:(UITapGestureRecognizer *)tap
{
    [self.nightView removeFromSuperview];
    [self.downView removeFromSuperview];
}
- (void)addClick:(UITapGestureRecognizer *)tap
{
    [self.nightView removeFromSuperview];
    [self.downView removeFromSuperview];
    AddBankCardStepOneViewController *stepOne = [[AddBankCardStepOneViewController alloc] init];
    [self.navigationController pushViewController:stepOne animated:YES];
}
- (void)createSubviews
{
    //确认提现按钮
    self.confirmWithdrawals = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 80, 90)];
    [self.view addSubview:_confirmWithdrawals];
    _confirmWithdrawals.layer.cornerRadius = 10;
    _confirmWithdrawals.center =self.view.center;
    [_confirmWithdrawals setTitle:@"确认提现" forState:UIControlStateNormal];
    _confirmWithdrawals.titleLabel.textColor = kUIColorFromRGB(0xcccccc);
    [_confirmWithdrawals setEnabled:NO];
    _confirmWithdrawals.backgroundColor = kUIColorFromRGB(0xdddddd);
}

- (void)textChanged:(NSString *)text
{
    if (![self.cell.nameField.text isEqualToString:@" "]) {
        [_confirmWithdrawals setEnabled:YES];
        _confirmWithdrawals.backgroundColor = kUIColorFromRGB(0x6fc4b2);
        [_confirmWithdrawals addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)confirmAction:(id)sender
{
    NSInteger m = [_cell.nameField.text floatValue];
    if (m <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入金额数目有误,请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [self.navigationController presentViewController:alert animated:YES completion:^{
            
        }];
    }else if (m > [_banlanceStr floatValue]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"余额不足" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [self.navigationController presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else{
    _moneyCount = _cell.nameField.text;
    NSURL *url = [NSURL URLWithString:@"http://192.168.55.100:8080/rest/native/coach/ol/drawMoney"];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    
    NSString * postString =[NSString stringWithFormat:@"id=1118&test=1&cardId=%@&money=%@",_cardId,_moneyCount];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *warningStr = [weatherDic objectForKey:@"returnMessage"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:warningStr preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        });
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
    }
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.nightView removeFromSuperview];
    [self.downView removeFromSuperview];
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
