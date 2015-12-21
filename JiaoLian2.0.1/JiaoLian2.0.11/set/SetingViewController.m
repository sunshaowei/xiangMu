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
