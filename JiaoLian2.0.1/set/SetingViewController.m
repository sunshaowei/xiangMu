//
//  SetingViewController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "SetingViewController.h"
#import "AboutusCell1.h"
#import "SetTuiCell.h"
#import "ChangPassWordController.h"
#import "BackPassController.h"
#import "ChangPhoneController.h"
#import "AboutUsViewController.h"
#import "AdviceViewController.h"
#import "TuiChuController.h"
#import "APService.h"


@interface SetingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tabView.delegate=self;
    _tabView.dataSource=self;
  

    self.title=@"设置";
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
        return 3;
    }else if (section==1)
        return 2;
    else
        return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section==0) {
        AboutusCell1   * cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutusCell1"  owner:self options:nil] lastObject];
        
        switch (indexPath.row) {
            case 0:
                cell.leftLabel.text=@"修改密码";
                break;
            case 1:
                cell.leftLabel.text=@"找回密码";
                break;
            default:
                cell.leftLabel.text=@"修改绑定手机号";
                break;
        }
        return cell;
    }else if (indexPath.section==1){
    AboutusCell1   * cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutusCell1"  owner:self options:nil] lastObject];
        if (indexPath.row==0) {
            cell.leftLabel.text=@"关于我们";
        }else{
            cell.leftLabel.text=@"意见反馈";
        }
        return cell;
    }else{
     SetTuiCell   * cell = [[[NSBundle mainBundle] loadNibNamed:@"SetTuiCell"  owner:self options:nil] lastObject];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else
        return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            ChangPassWordController*changPassVc=[[ChangPassWordController alloc] init];
            [self.navigationController pushViewController:changPassVc animated:YES];
        }
        else if (indexPath.row==1){
            BackPassController*backPassVc=[[BackPassController alloc] init];
            [self.navigationController pushViewController:backPassVc animated:YES];
        }else{
            ChangPhoneController*changPhoneVc=[[ChangPhoneController alloc] init];
            [self.navigationController pushViewController:changPhoneVc animated:YES];
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            AboutUsViewController*aboutUsVc=[[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVc animated:YES];
        }else{
            AdviceViewController*adciceVc=[[AdviceViewController alloc] init];
            [self.navigationController pushViewController:adciceVc animated:YES];
        }
    }else{
        //退出登陆
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:LOING_SATAE];
        //登陆成功后把用户别名给激光服务器
        [APService setAlias:@"-1" callbackSelector:nil object:nil];
        //推出一个导航栏的模态
        TuiChuController*tuiChuVc=[[TuiChuController alloc] init];
        UINavigationController*tuiChuNc=[[UINavigationController alloc] initWithRootViewController:tuiChuVc];
        [self.navigationController presentViewController:tuiChuNc animated:YES completion:nil];
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
