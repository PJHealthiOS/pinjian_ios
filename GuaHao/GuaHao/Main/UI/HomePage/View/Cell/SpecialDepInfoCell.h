//
//  SpecialDepInfoCell.h
//  GuaHao
//
//  Created by PJYL on 2016/11/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OpenInfoBlock)(BOOL open);

@interface SpecialDepInfoCell : UITableViewCell
@property (nonatomic, copy)OpenInfoBlock myBlock;
-(void)layoutSubviewsInfo:(NSString *)str imageStr:(NSString *)imageStr;
-(void)openDepInfoAction:(OpenInfoBlock)block;
@end
