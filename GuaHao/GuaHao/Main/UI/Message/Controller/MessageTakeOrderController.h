//
//  MessageTakeOrderController.h
//  GuaHao
//
//  Created by qiye on 16/2/24.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderVO.h"
@class NewOrderVO;
@protocol MessageTakeOrderDelegate <NSObject>
-(void) takeOrderComplete:(NewOrderVO*) vo;
@end

@interface MessageTakeOrderController : UIViewController
@property (nonatomic) NSNumber * serialNo;
@property (nonatomic) NSString * mtitle;
@property(assign) id<MessageTakeOrderDelegate> delegate;
@end
