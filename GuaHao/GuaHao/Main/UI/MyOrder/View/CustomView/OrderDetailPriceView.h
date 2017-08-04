//
//  OrderDetailPriceView.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/10.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailPriceView : UIView
@property (strong, nonatomic) NSArray *sourceArr;
-(instancetype)initWithFrame:(CGRect)frame ;
-(void)reloadTableViewWithSourceArr:(NSArray *)sourceArr;
@end
