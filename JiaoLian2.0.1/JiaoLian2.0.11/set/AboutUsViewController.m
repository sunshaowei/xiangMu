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

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate=self;
    _tableView.dataSource=self;
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
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
         AboutusCell1   * cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutusCell1"  owner:self options:nil] lastObject];
        if (indexPath.row==0) {
            cell.leftLabel.text=@"了解我们";

        }else
            cell.leftLabel.text=@"免责申明";
        return cell;
    }else if (indexPath.section==1){
        AboutUsKeCell  * cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutUsKeCell"  owner:self options:nil] lastObject];
        NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);

        cell.leftLabel.text=@"客服中心";
        return cell;
    }else{
        AboutusCell1   * cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutusCell1"  owner:self options:nil] lastObject];
        cell.leftLabel.text=@"检查更新";
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0)
        return 5;
    else
        return 20;
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
