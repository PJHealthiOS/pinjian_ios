//
//  GHScrollViewCell.h
//  GuaHao
//
//  Created by PJYL on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickReturnBlock)(NSInteger type);
typedef void(^ClickCellActionBlock)(NSInteger index);

@interface GHScrollViewCell : UITableViewCell
@property (nonatomic,copy)ClickReturnBlock myBlock;
@property (nonatomic,copy)ClickCellActionBlock cellBlock;

-(void)clickCellReturn:(ClickCellActionBlock)block;

-(void)clickButtonReturn:(ClickReturnBlock)block;

-(void)layoutSubviews:(NSArray *)array title:(NSString *)title  type:(int)typ;

@end
