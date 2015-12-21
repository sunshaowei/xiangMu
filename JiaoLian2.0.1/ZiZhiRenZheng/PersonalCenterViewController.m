//
//  PersonalCenterViewController.m
//  PersonalCenter
//
//  Created by 戴文博 on 15/11/20.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalInfoTableViewCell.h"
#import "CostCellTableViewCell.h"
#import "Color.h"
#import "PictureView.h"
#import <AliyunOSSiOS/OSSService.h>
#import "MD5.h"
#import "UTF8Two.h"

@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) UIImagePickerController *picController;
@property(nonatomic,assign) NSInteger n; //第几张图片
@property(nonatomic,retain) NSOperationQueue *_queue;
@property UIView*shengHeView;//教练的多种状态都在一个View

@property  OSSClient*client;//上传阿里云用的

@property NSString*name;
@property NSString*id_card;
@property NSString*jiaoLing;
@property NSString*JiaXiao;
@property NSString*changDi;
@property NSString*c1Price;
@property NSString*c2Price;

//提交教练申核的4张图片的url
@property NSString*cordZhengUrl;//身份证段面
@property NSString*codeFuUrl;//身份证反面
@property NSString*jiaoLianUrl;//教练证
@property NSString*headUrl;//个人头像



@end

@implementation PersonalCenterViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        __queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

//审核中布局
-(void)setShengHeingViews{

    _shengHeView=[[UIView alloc] initWithFrame: SCREEN_FRAME];
    _shengHeView.backgroundColor=[UIColor whiteColor];
    
    //审核中图片
    UIImageView*resultImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 136, 150, 150)];
    resultImageView.center=CGPointMake(SCREEN_WIDTH/2, resultImageView.center.y);
    resultImageView.image=[UIImage imageNamed:@"矢量智能对象@3x"];
    [_shengHeView addSubview:resultImageView];
    
    UILabel*shengHeLabel1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 70)];
    shengHeLabel1.numberOfLines=2;
    shengHeLabel1.textAlignment=NSTextAlignmentCenter;
    shengHeLabel1.text=@"您的资料正在审核中，\n如有任何疑问可联系客服";
    shengHeLabel1.center=CGPointMake(SCREEN_WIDTH/2, resultImageView.center.y+120);
    [_shengHeView addSubview:shengHeLabel1];
    
    //客服/建议button
    UIButton*keFuButton=[UIButton buttonWithType:UIButtonTypeSystem];
    keFuButton.frame=CGRectMake(0, 0, 200, 50);
    
    keFuButton.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*4/5);
    [keFuButton setTitle:@"联系客服投诉/建议" forState:UIControlStateNormal];
//    keFuButton.backgroundColor=kUIColorFromRGB(0x6fc4b2);
    [keFuButton setTintColor:kUIColorFromRGB(0x6fc4b2)];

    [keFuButton addTarget:self action:@selector(keFuButtonDianHua) forControlEvents:UIControlEventTouchUpInside];
//    [keFuButton setImage:[UIImage imageNamed:@"customer_service_32px_1138201_easyicon.net@2x.png"] forState:UIControlStateNormal];
    [keFuButton setImage:[UIImage imageNamed:@"customer_service_32px_1138201_easyicon.net@3x"] forState:UIControlStateNormal];//给button添加image
//    keFuButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,keFuButton.titleLabel.bounds.size.width);//设置i
    [_shengHeView addSubview:keFuButton];
    [self.view addSubview:_shengHeView];
    
}
//审核失败布局
-(void)setShengHeFailViews{
    _shengHeView=[[UIView alloc] initWithFrame: SCREEN_FRAME];
    _shengHeView.backgroundColor=[UIColor whiteColor];
    
    //审核中图片
    UIImageView*resultImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    resultImageView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*2/5);
    resultImageView.image=[UIImage imageNamed:@"no@3x"];
    [_shengHeView addSubview:resultImageView];
    
    UILabel*shiBaiLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,200, 60)];
    shiBaiLabel.center=CGPointMake(SCREEN_WIDTH/2,resultImageView.center.y+resultImageView.bounds.size.height/2+30);
    shiBaiLabel.text=@"您的资料审核未通过，点击查看详情或咨询客服^_^";
    shiBaiLabel.numberOfLines=2;
    [_shengHeView addSubview:shiBaiLabel];
    //查处详情button
    UIButton*detailsButton=[UIButton buttonWithType:UIButtonTypeSystem];
    detailsButton.frame=CGRectMake(0, 0, 200, 50);
    detailsButton.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*4/5-100);
    [detailsButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [detailsButton addTarget:self action:@selector(detailsButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    detailsButton.layer.cornerRadius = 8;
    detailsButton.layer.masksToBounds = YES;
    detailsButton.layer.borderWidth = 5;
    detailsButton.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];

    [_shengHeView addSubview:detailsButton];
    
    //客服/建议button
    UIButton*keFuButton=[UIButton buttonWithType:UIButtonTypeSystem];
    keFuButton.frame=CGRectMake(0, 0, 200, 50);
    keFuButton.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*4/5);
    [keFuButton setTitle:@"联系客服投诉/建议" forState:UIControlStateNormal];
    [keFuButton setImage:[UIImage imageNamed:@"customer_service_32px_1138201_easyicon.net@2x.png"] forState:UIControlStateNormal];
    [keFuButton addTarget:self action:@selector(keFuButtonDianHua) forControlEvents:UIControlEventTouchUpInside];
    [_shengHeView addSubview:keFuButton];
    [self.view addSubview:_shengHeView];
}
//查看详情
-(void)detailsButtonEvent{
    [self createTableView];
    [_shengHeView removeFromSuperview];
}
-(void)keFuButtonDianHua{
    NSString *phoneNum = @"4000916960";// 电话号码
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人中心";
    [self changeNavigationcontroller];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*shengHeState=[userDefaults objectForKey:SHENGHE_SATAE];
//    NSLog(@"=========%@",shengHeState);

        if ([shengHeState isEqualToString:@"2"])
            //申核成功
        NSLog(@"");
        else if ([shengHeState isEqualToString:@"0"])
        //没有申核
            [self createTableView];
        else if ([shengHeState isEqualToString:@"3"])
            //失败
            [self setShengHeFailViews];
        else
        //申核中
        [self setShengHeingViews];
    
    
    //上传阿里云需要的东西
    NSString *endpoint =@"http://oss-cn-hangzhou.aliyuncs.com";
    
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"oUUe8xpqpq5XrGSj"
                                                                                                            secretKey:@"Q722qe9Lzhe3gXFlYuCyU0k5jWsncO"];
    _client= [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
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
- (void)changeNavigationcontroller
{
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(commentButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
}



//提交button
-(void)commentButton{
    //名字
    PersonalInfoTableViewCell*cell0=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //身份证号
    PersonalInfoTableViewCell*cell1=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    //教龄
    PersonalInfoTableViewCell*cell2=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
     //驾校
    PersonalInfoTableViewCell*cell3=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
     //场地
    PersonalInfoTableViewCell*cell4=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
     // c1价格
    CostCellTableViewCell*cell10=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
     //c2价格
     CostCellTableViewCell*cell11=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//    NSLog(@"11=========%@",cell0.infoField.text);
//    NSLog(@"22=========%@",cell1.infoField.text);
//    NSLog(@"33=========%@",cell2.infoField.text);
//    NSLog(@"44=========%@",cell3.infoField.text);
//    NSLog(@"55=========%@",cell4.infoField.text);
//    
//    NSLog(@"66=========%@",cell10.moneyField.text);
//    NSLog(@"77=========%@",cell11.moneyField.text);
//    NSLog(@"gjhgiy=========%@",_jiaoLianUrl);

    BOOL shengHe=(_name==nil)&(_id_card==nil)&(_jiaoLing==nil)&(_JiaXiao==nil)&(_changDi==nil);


    BOOL priceBool=YES;
    if ((_c1Price==nil)&(_c2Price==nil)) {
        priceBool=NO;
    }
    BOOL cardBool=[self validateIdentityCard:_id_card];



    if (!shengHe&priceBool&cardBool) {
        
        
        
        NSURL *url = [NSURL URLWithString:TiJiAO_SHENGHE_URL];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod=@"POST";
        //        NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
        //    NSString*password=[MD5 stringToMD5Str:@"123456"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString*userid =[userDefaults objectForKey:USER_ID];
        NSString*token=[userDefaults objectForKey:TOKEN];
        NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/updateCoach%@%@",userid,token]];
        NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@&test=1&cname=%@&idcard=%@&teach_exp=%@&schname=%@&driving_coaching_grid=%@&c1_offer=%@&c2_offer=%@&card_url=%@&card_back_url=%@&photo_zip_url=%@&coach_card_url=%@",userid,sign,_name,_id_card,_jiaoLing,_JiaXiao,_changDi,_c1Price,_c2Price,_cordZhengUrl,_codeFuUrl,_headUrl,_jiaoLianUrl];
        NSLog(@"=========%@",postString);

        postString=[UTF8Two stringToUTF8Str:postString];
        
        NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
        request.HTTPBody=postData;
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSString*SSS=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"=========%@",SSS);
        }];
        //任务创建后，不会立即执行，调用resume立即执行;
        [dataTask resume];
    }else{
//        NSLog(@"=========请将信息填写完整");
        

    }
    
    
}
//判断身份证号
-(BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//获得申核信息
-(void)getShengHeXinXi{
    //名字
    PersonalInfoTableViewCell*cell0=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //身份证号
    PersonalInfoTableViewCell*cell1=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    //教龄
    PersonalInfoTableViewCell*cell2=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    //驾校
    PersonalInfoTableViewCell*cell3=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    //场地
    PersonalInfoTableViewCell*cell4=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    // c1价格
    CostCellTableViewCell*cell10=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //c2价格
    CostCellTableViewCell*cell11=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//    NSLog(@"=========%@",cell0.infoField.text);
//    NSLog(@"=========%@",cell1.infoField.text);
//    NSLog(@"=========%@",cell2.infoField.text);
//    NSLog(@"=========%@",cell3.infoField.text);
//    NSLog(@"=========%@",cell4.infoField.text);
//    
//    NSLog(@"=========%@",cell10.moneyField.text);
//    NSLog(@"=========%@",cell11.moneyField.text);
   
    cell10.moneyField.text=@"fsdfsdf";

    NSURL *url = [NSURL URLWithString:GET_SHENGHE_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
//            NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
//        NSString*password=[MD5 stringToMD5Str:@"123456"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*userid =[userDefaults objectForKey:USER_ID];
    NSString*token=[userDefaults objectForKey:TOKEN];
    NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/findOwnerInfo%@%@",userid,token]];
    NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@",userid,sign];
    postString=[UTF8Two stringToUTF8Str:postString];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data!=nil) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//            NSLog(@"=========%@",weatherDic);

            NSArray*beansArray=[weatherDic objectForKey:@"beans"];

            for (NSDictionary*dic in beansArray) {


                [dic objectForKey:@"verify"];//申核详情
               
                
              _cordZhengUrl=  [dic objectForKey:@"card_url"];//身份证正面
                _codeFuUrl=[dic objectForKey:@"card_back_url"];//身份证背面
              _jiaoLianUrl=[dic objectForKey:@"coach_card_url"];//教练证
               _headUrl=[dic objectForKey:@"photo_zip_url"];//本人照片
                
               NSInteger shiBaiYuanYIn=[[dic objectForKey:@"verify"] integerValue];
                
                for (int i=1; i<5; i++) {
                    PictureView *new = [self.view viewWithTag:4+i];
                    NSString*urlStr;
                    if (i==1)urlStr=_cordZhengUrl;
                    else if (i==2)   urlStr=_codeFuUrl;
                    else if (i==3)   urlStr=_jiaoLianUrl;
                    else if (i==4)   urlStr=_headUrl;

                    NSURL *url = [NSURL URLWithString:urlStr];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    UIImageView*newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, new.frame.size.width, new.frame.size.height)];
                    newImageView.image = image;
                    [new addSubview:newImageView];
                    
                    UIImageView*errorImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                    errorImageView.image=[UIImage imageNamed:@"error.gif"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        cell0.infoField.text=[dic objectForKey:@"cname"];//名字
                        cell1.infoField.text=[dic objectForKey:@"idcard"];//身份证号
                        cell2.infoField.text=[dic objectForKey:@"teach_exp"];//教龄
                        cell3.infoField.text=[dic objectForKey:@"schname"];//驾校
                        cell4.infoField.text=[dic objectForKey:@"driving_coaching_grid"];//场地
                        
                        cell10.moneyField.text=[dic objectForKey:@"c1_offer"];//c1价格
                        cell11.moneyField.text=[dic objectForKey:@"c2_offer"];//c2价格
                        [new addSubview:newImageView];
                        
                        if (i==shiBaiYuanYIn) {
                            [new addSubview:errorImageView];
                        }
                    });
                }
                
                
            }
        }
        
//        NSString*SSS=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"=========%@",SSS);
    }];
    //任务创建后，不会立即执行，调用resume立即执行;
    [dataTask resume];
}
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kUIColorFromRGB(0xF5F5F5);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*shengHeState=[userDefaults objectForKey:SHENGHE_SATAE];
    if ([shengHeState isEqualToString:@"3"]) {
        [self getShengHeXinXi];//获得申核信息
//        NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);

    }
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else return 2;
}
- (void)textChanged:(NSString *)text
{
    //名字
    PersonalInfoTableViewCell*cell0=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //身份证号
    PersonalInfoTableViewCell*cell1=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    //教龄
    PersonalInfoTableViewCell*cell2=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    //驾校
    PersonalInfoTableViewCell*cell3=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    //场地
    PersonalInfoTableViewCell*cell4=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    // c1价格
    CostCellTableViewCell*cell10=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //c2价格
    CostCellTableViewCell*cell11=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//    NSLog(@"11=========%@",cell0.infoField.text);
//    NSLog(@"22=========%@",cell1.infoField.text);
//    NSLog(@"33=========%@",cell2.infoField.text);
//    NSLog(@"44=========%@",cell3.infoField.text);
//    NSLog(@"55=========%@",cell4.infoField.text);
//    
//    NSLog(@"66=========%@",cell10.moneyField.text);
//    NSLog(@"77=========%@",cell11.moneyField.text);
    if (cell0.infoField.text!=nil) {
        _name=cell0.infoField.text;
    }
    if (cell1!=nil) {
        _id_card=cell1.infoField.text;

    }
    if (cell2!=nil) {
        _jiaoLing=cell2.infoField.text;

    }
    if (cell3!=nil) {
        _JiaXiao=cell3.infoField.text;
    }
    if (cell4!=nil) {
        _changDi=cell4.infoField.text;

    }
    if (cell10!=nil) {
        _c1Price=cell10.moneyField.text;

    }
    if (cell11!=nil) {
        _c2Price=cell11.moneyField.text;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *name = @"Name";
            PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
            if (!cell) {
                cell = [[PersonalInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
            }
            cell.pic.image = [UIImage imageNamed:@"person@3x.png"];
            cell.infoField.placeholder = @"请输入姓名";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:cell.infoField];
            return cell;
        }else if (indexPath.row == 1){
            static NSString *idCardNum = @"idCardNum";
            PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCardNum];
            if (!cell) {
                cell = [[PersonalInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCardNum];
            }
            cell.pic.image = [UIImage imageNamed:@"ID@3x.png"];
            cell.infoField.placeholder = @"请输入身份证号";
            cell.infoField.keyboardType=UIKeyboardTypeNumberPad;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:cell.infoField];
            return cell;
        }else if (indexPath.row == 2){
            static NSString *age = @"age";
            PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:age];
            if (!cell) {
                cell = [[PersonalInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:age];
            }
            cell.pic.image = [UIImage imageNamed:@"iconfont-icon32227@3x.png"];
            cell.infoField.placeholder = @"请输入教龄";
            cell.infoField.keyboardType=UIKeyboardTypeNumberPad;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:cell.infoField];
            return cell;
        }else if (indexPath.row == 3){
            static NSString *school = @"school";
            PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:school];
            if (!cell) {
                cell = [[PersonalInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:school];
            }
            cell.pic.image = [UIImage imageNamed:@"school@3x.png"];
            cell.infoField.placeholder = @"请输入所属驾校";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:cell.infoField];
            return cell;
        }else {
            static NSString *area = @"area";
            PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:area];
            if (!cell) {
                cell = [[PersonalInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:area];
            }
            cell.pic.image = [UIImage imageNamed:@"29@3x.png"];
            cell.infoField.placeholder = @"请输入训练场地 ";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:cell.infoField];
            return cell;
            
        }
    }
    else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            static NSString *c1 = @"c1";
//            CostCellTableViewCell *cell = [[CostCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:c1];
//            if (!cell) {
//                cell = [[CostCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:c1];
//            }
//            cell.cPic.image = [UIImage imageNamed:@"C1Gray@3x.png"];
//            cell.priceLable.textColor = kUIColorFromRGB(0xC0C0C0);
//            [cell.chooseButton setImage:[UIImage imageNamed:@"guan@3x.png"] forState:UIControlStateNormal];
//            cell.chooseButton.tag = 1;
//            cell.moneyField.keyboardType=  UIKeyboardTypeNumberPad;
//
//
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.delegate = self;
//            return cell;
//        }else if(indexPath.row == 1){
//            static NSString *c2 = @"c2";
//            CostCellTableViewCell *cell = [[CostCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:c2];
//            if (!cell) {
//                cell = [[CostCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:c2];
//            }
//            cell.cPic.image = [UIImage imageNamed:@"C2Gray@3x.png"];
//            cell.priceLable.textColor = kUIColorFromRGB(0xC0C0C0);
//            [cell.chooseButton setImage:[UIImage imageNamed:@"guan@3x.png"] forState:UIControlStateNormal];
//            cell.delegate = self;
//            cell.chooseButton.tag = 2;
//            cell.moneyField.keyboardType=  UIKeyboardTypeNumberPad;
//
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
//        }
        if (indexPath.row == 0) {
            static NSString *c1 = @"c1";
            CostCellTableViewCell *cell = [[CostCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:c1];
            if (!cell) {
                cell = [[CostCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:c1];
            }
            cell.cPic.image = [UIImage imageNamed:@"C1Gray@3x.png"];
            cell.priceLable.textColor = kUIColorFromRGB(0xC0C0C0);
            [cell.chooseSwitch addTarget:self action:@selector(Caction:) forControlEvents:UIControlEventValueChanged];
            cell.chooseSwitch.tag = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:cell.moneyField];
            return cell;
        }else if(indexPath.row == 1){
            static NSString *c2 = @"c2";
            CostCellTableViewCell *cell = [[CostCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:c2];
            if (!cell) {
                cell = [[CostCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:c2];
            }
            cell.cPic.image = [UIImage imageNamed:@"C2Gray@3x.png"];
            cell.priceLable.textColor = kUIColorFromRGB(0xC0C0C0);
            [cell.chooseSwitch addTarget:self action:@selector(Caction:) forControlEvents:UIControlEventValueChanged];
            cell.chooseSwitch.tag = 2;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:cell.moneyField];
            return cell;
        }
    }
    return nil;
}
- (void)Caction:(id)sender
{
    UISwitch *chooseSwitch = (UISwitch *)sender;
    BOOL chooseIsOn = [chooseSwitch isOn];
    if (chooseIsOn) {
        if (chooseSwitch.tag == 1) {
            CostCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            chooseSwitch.onTintColor = kUIColorFromRGB(0x6fc4b2);
            cell.cPic.image = [UIImage imageNamed:@"C1@3x.png"];
            cell.priceLable.textColor = kUIColorFromRGB(0x333333);
        }else{
            CostCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            chooseSwitch.onTintColor=kUIColorFromRGB(0x6fc4b2);
            cell.cPic.image = [UIImage imageNamed:@"C2@3x.png"];
            cell.priceLable.textColor = kUIColorFromRGB(0x333333);
        }
    }else{
        if (chooseSwitch.tag == 1) {
            CostCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cell.cPic.image = [UIImage imageNamed:@"C1Gray@3x.png"];
            cell.priceLable.textColor = kUIColorFromRGB(0xC0C0C0);
        }else{
            CostCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            cell.cPic.image = [UIImage imageNamed:@"C2Gray@3x.png"];
            cell.priceLable.textColor = kUIColorFromRGB(0xC0C0C0);
        }
    }
}
//- (void)changeCellAction:(id)sender
//{
//    UIButton *button = (UIButton *)sender;
//    if (button.tag == 1) {
//        CostCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//        cell.cPic.image = [UIImage imageNamed:@"C1@3x.png"];
//        cell.priceLable.textColor = kUIColorFromRGB(0x333333);
//        [cell.chooseButton setImage:[UIImage imageNamed:@"kai@3x.png"] forState:UIControlStateNormal];
//    }
//    else {
//        CostCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//        cell.cPic.image = [UIImage imageNamed:@"C2@3x.png"];
//        cell.priceLable.textColor = kUIColorFromRGB(0x333333);
//        [cell.chooseButton setImage:[UIImage imageNamed:@"kai@3x.png"] forState:UIControlStateNormal];
//    }
//        
//    
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else
        return 80;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }else
        return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"为了更好的展示,请完整的填写您的资料,以便学员进行查看。";
    }else if (section == 1){
        return @"提示: 输入价格包含所有费用, 请谨慎填写。";
        
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 370;
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        footerView.backgroundColor  = [UIColor whiteColor];
        NSArray *arr = @[@"身份证正面",@"身份证反面",@"教练证",@"本人真实照片"];
        for (int i = 0; i < 4; i++) {
            PictureView *picView = [[PictureView alloc] initWithFrame:CGRectMake(i % 2 * ((self.view.frame.size.width - 30) / 2 + 10) + 10, i / 2 * (350 / 2 - 5) + 10, self.view.frame.size.width / 2 - 15, 350 / 2 - 15)];
            [footerView addSubview:picView];
            picView.userInteractionEnabled = YES;
            picView.tag = i + 5;
            picView.backgroundColor = kUIColorFromRGB(0Xf5f5f5);
            picView.picLable.text = [arr objectAtIndex:i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [picView addGestureRecognizer:tap];
        }
        self.tableView.tableFooterView = footerView;
        return footerView;
    }
    return nil;
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    self.n = tap.view.tag;
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"iii" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.picController = [[UIImagePickerController alloc] init];
            self.picController.delegate = self;
        self.picController.allowsEditing = YES;
            self.picController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picController animated:YES completion:^{
                
            }];
    }];
    
    
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picController = [[UIImagePickerController alloc] init];
        self.picController.delegate = self;
        self.picController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picController animated:YES completion:^{
            
        }];
    }];
    [alert addAction:photoLibrary];
    [alert addAction:camera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *newPic = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    PictureView *new = [self.view viewWithTag:self.n];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, new.frame.size.width, new.frame.size.height)];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = @"sxposs";
    
    //设置上传的名字
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*userId=[userDefaults objectForKey:USER_ID];
    
    //从字典中获得图片类型
    NSString*str=[NSString stringWithFormat:@"%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
//    NSLog(@"=========%@",str);

    NSArray *array = [str componentsSeparatedByString:@"="];

    NSString*str2=array[array.count-1];
    put.objectKey = [NSString stringWithFormat:@"coachupload/%@/%ld.%@",userId,(long)self.n-4,str2];
//    NSLog(@"上传=======%@==%ld",put.objectKey,(long)self.n-4);
    switch (self.n-4) {
        case 1:
            _cordZhengUrl=put.objectKey;
            break;
        case 2:
            _codeFuUrl=put.objectKey;
            break;
        case 3:
            _jiaoLianUrl=put.objectKey;
            break;
        case 4:
            _headUrl=put.objectKey;
            break;
        default:
            break;
    }
    
    CGFloat zipCount=0.1;
    if (self.n==8) {
        zipCount=0.01;
    }
    //此处图片过大上传时候会很慢所以设置成为0.1
    NSData* data = UIImageJPEGRepresentation(newPic, zipCount);
    
    
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [_client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
//            NSLog(@"upload object success!");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                
                image.image = newPic;
                [new addSubview:image];
                [self.picController dismissViewControllerAnimated:YES completion:nil];
            });
           
        } else {
//            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];

}

//上传图片

/*
-(void)chuanTuEvent:(UIImage*)myimage{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = @"sxposs";
    put.objectKey = @"coachupload/1118/1.jpg";
    //    UIImage*myImage=[UIImage imageNamed:@"IMG_0351.jpg"];
    ///Users/sunshaowei/Desktop/dddd/dddd/IMG_0351.jpg
    
    
    NSData* data = UIImageJPEGRepresentation(myimage, 1.0);
    
    
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [_client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
*/

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
