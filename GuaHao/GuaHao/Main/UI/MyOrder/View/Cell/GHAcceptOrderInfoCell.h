//
//  GHAcceptOrderInfoCell.h
//  GuaHao
//
//  Created by PJYL on 16/8/31.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptOrderVO.h"
typedef  void(^OrderPatientInfoBlock)(BOOL end);


@interface GHAcceptOrderInfoCell : UITableViewCell
@property (nonatomic, copy)OrderPatientInfoBlock myBlock;
-(void)openPatientInfo:(OrderPatientInfoBlock)block;
+ (instancetype)renderCell:(GHAcceptOrderInfoCell *)cell order:(AcceptOrderVO *)order;
@end
