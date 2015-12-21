//
//  StudentsViewController.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/16.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "StudentsViewController.h"
#import "StudentTableViewCell.h"
#import "StudentListModel.h"

#import "Color.h"

@interface StudentsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain)NSMutableArray*studentArray;//学员数组
@end

@implementation StudentsViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = kUIColorFromRGB(0x6fc4b2);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"学员";
    _studentArray=[NSMutableArray arrayWithCapacity:8];
    [self studentListData];//学员列表数据
    [self createTableView];
}
-(void)studentListData{
    NSURL *url = [NSURL URLWithString:STUDENT_LIST_URL];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    //    NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
    //    NSString*password=[MD5 stringToMD5Str:@"123456"];
    
    NSString * postString =[NSString stringWithFormat:@"id=1118&test=1"];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    request.HTTPBody=postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data!=nil) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSArray*beansArray=[weatherDic objectForKey:@"beans"];
            for (NSDictionary*dic in beansArray) {
                StudentListModel*oneStudentModel=[[StudentListModel alloc] init];
                [oneStudentModel setValuesForKeysWithDictionary:dic];
                [_studentArray addObject:oneStudentModel];
            }
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }];
    //任务创建后，不会立即执行，调用resume 立即执行;
    [dataTask resume];
}
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _studentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"studentsReuse";
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StudentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    StudentListModel*oneStudentModel=_studentArray[indexPath.row];
    cell.nameLable.text=oneStudentModel.sname;
    
    //下面是学车进度
    if ([oneStudentModel.schedule isEqualToString:@"1"]) {
        cell.scheduleLable.text=@"科目一学习中";
    }else if ([oneStudentModel.schedule isEqualToString:@"2"])        cell.scheduleLable.text=@"科目二学习中";
    else if ([oneStudentModel.schedule isEqualToString:@"3"])       cell.scheduleLable.text=@"科目三学习中";
    else
        cell.scheduleLable.text=@"科目四学习中";
    //下面是学生的类型是c1还是c2
    if ([oneStudentModel.driving isEqualToString:@"1"]) {
        cell.carStyle.text=@"C1";
    }else{
        cell.carStyle.text=@"C2";
    }
    cell.priceLable.text=oneStudentModel.price;
    
    NSURL *url = [NSURL URLWithString:oneStudentModel.head_url];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    cell.userImage.image=image;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
