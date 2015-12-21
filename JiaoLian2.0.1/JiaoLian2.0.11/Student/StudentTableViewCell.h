//
//  StudentTableViewCell.h
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/16.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentTableViewCell : UITableViewCell
@property(nonatomic,retain) UIImageView *userImage; //学员头像
@property(nonatomic,retain) UILabel *nameLable; //学员名字
@property(nonatomic,retain) UILabel *scheduleLable; //学员进度
@property(nonatomic,retain) UILabel *carStyle; //学车类型
@property(nonatomic,retain) UILabel *priceLable; //价格
@end
