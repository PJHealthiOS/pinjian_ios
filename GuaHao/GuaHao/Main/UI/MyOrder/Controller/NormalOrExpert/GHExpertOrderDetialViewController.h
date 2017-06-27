//
//  GHExpertOrderDetialViewController.h
//  GuaHao
//
//  Created by PJYL on 2017/6/1.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHExpertOrderDetialViewController : UIViewController
@property(nonatomic,strong) NSString * orderNO;
@property(nonatomic,strong) OrderListVO *postOrder;
@property (nonatomic) PopBackType popBack;
@property(nonatomic,assign)int orderType;
@end
