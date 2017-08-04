//
//  OrderPayCell.h
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^OrderPayInfoBlock)(BOOL end);
@interface OrderPayCell : UITableViewCell
@property (nonatomic, copy)OrderPayInfoBlock myBlock;
-(void)openPayInfo:(OrderPayInfoBlock)block;
+ (instancetype)renderCell:(OrderPayCell *)cell source:(NSArray *)source;
@end
