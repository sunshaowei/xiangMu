//
//  AboutUsViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutusCell1.h"
#import "AboutUsKeCell.h"
#import "WebViewController.h"

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.title=@"关于我们";
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if (section==1)
        return 1;
    else
        return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
         AboutusCell1   * cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutusCell1"  owner:self options:nil] lastObject];
        if (indexPath.row==0) {
            cell.leftLabel.text=@"了解我们";

        }else
            cell.leftLabel.text=@"免责申明";
        
        return cell;
    }else {
        AboutUsKeCell  * cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutUsKeCell"  owner:self options:nil] lastObject];
//        NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);

        cell.leftLabel.text=@"客服中心";
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0)
        return 5;
    else
        return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&indexPath.row==0) {
        WebViewController*liaoJieVc=[[WebViewController alloc] init];
        liaoJieVc.urlStr=@"/Users/sunshaowei/Desktop/JiaoLian2.0.1/liaoJie.html";
        [self.navigationController pushViewController:liaoJieVc animated:YES];
    }else if (indexPath.section==0&indexPath.row==1){
        //免责声明
        WebViewController*mianZaVc=[[WebViewController alloc] init];
        mianZaVc.urlStr=@"/Users/sunshaowei/Desktop/JiaoLian2.0.1/mianZeShengMing.html";
        [self.navigationController pushViewController:mianZaVc animated:YES];
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
