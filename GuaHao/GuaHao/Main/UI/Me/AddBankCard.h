//
//  AddBankCard.h
//  GuaHao
//
//  Created by 123456 on 16/2/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BankListVODelegate <NSObject>
-(void) BankListVODelegate;
@end

@interface AddBankCard : UIViewController
@property(assign) id<BankListVODelegate> delegate;

@end
