//
//  GHOrderDetailViewController.h
//  GuaHao
//
//  Created by 123456 on 16/8/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListVO.h"
@interface GHOrderDetailViewController : UIViewController
@property(nonatomic,strong) NSString * orderNO;
@property(nonatomic,strong) OrderListVO *postOrder;
@property (nonatomic) PopBackType popBack;
@property(nonatomic,assign)int orderType;
@end
