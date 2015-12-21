//
//  AddBankCardStepTwoViewController.h
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankCardStepTwoViewController : UIViewController
@property(nonatomic,retain) NSString *cardNum; //卡号
@property(nonatomic,retain) NSString *cardHolder;//持卡人姓名

- (void)sendBankName:(NSString *)bankName cardStype:(NSString *)stype logourl:(NSString *)logo cardNum:(NSString *)cardNum cardHolder:(NSString *)holder;
@property(nonatomic,retain) NSString *cardtype;
@property(nonatomic,retain) NSString *cardlength;
@property(nonatomic,retain) NSString *bankname;
@property(nonatomic,retain) NSString *logourl;
@end
