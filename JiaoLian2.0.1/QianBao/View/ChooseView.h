//
//  ChooseView.h
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/19.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseViewDelegate;
@interface ChooseView : UIView
@property(nonatomic,assign)id delegate;
@end

@protocol ChooseViewDelegate <NSObject>

- (void)pushBack:(UITapGestureRecognizer *)tap;

@end