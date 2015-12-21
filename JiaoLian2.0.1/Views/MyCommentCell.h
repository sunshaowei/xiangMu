//
//  MyCommentCell.h
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;//评价内容

@end
