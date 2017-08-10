//
//  AccOrderInfoCell.h
//  GuaHao
//
//  Created by PJYL on 2016/10/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccDetialVO.h"

typedef void(^DetialPriceBlock)(BOOL open);

@interface AccOrderInfoCell : UITableViewCell
@property (nonatomic,copy)DetialPriceBlock myBlock;


-(void)layoutSubviews:(AccDetialVO *)vo;
-(void)openPriceDetial:(DetialPriceBlock)block;
@end
