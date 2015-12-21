//
//  SystemMessgedetailsController.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "SystemMessgedetailsController.h"

@interface SystemMessgedetailsController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UITextView *messageLabel;//消息内容
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UIButton *diButton;

@end

@implementation SystemMessgedetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _nameLabel.text=_oneMessageModel.cname;
    _messageLabel.text=_oneMessageModel.msg_content;
    _timeLabel.text=_oneMessageModel.crt_time;
    NSLog(@"=========%@",_oneMessageModel.msg_type);

    if ([_oneMessageModel.msg_type isEqualToString:@"1"]) {
        [_diButton setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        [_diButton setTitle:@"查处详情" forState:UIControlStateNormal];
        NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);
    }
}
//确定或者查看详情
- (IBAction)diButton:(id)sender {
    if ([_oneMessageModel.msg_type isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"=========账户消息");
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
