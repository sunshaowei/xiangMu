//
//  CostCellTableViewCell.h
//  PersonalCenter
//
//  Created by 戴文博 on 15/11/20.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CostCellTableViweCellDelegate;

@interface CostCellTableViewCell : UITableViewCell
@property(nonatomic,retain) UIImageView *cPic; //C1或C2的图片
@property(nonatomic,retain) UILabel *priceLable; //价格标志lable
@property(nonatomic,retain) UITextField *moneyField; //输入价格的field
@property(nonatomic,retain) UISwitch *chooseSwitch; //选择或选择的button
@property(nonatomic,assign) id delegate;
@end

@protocol CostCellTableViweCellDelegate <NSObject>

- (void)changeCellAction:(id)sender;

@end