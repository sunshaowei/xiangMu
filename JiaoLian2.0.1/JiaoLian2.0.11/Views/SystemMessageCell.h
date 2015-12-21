//
//  SystemMessageCell.h
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;//消息内容

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间

@end
