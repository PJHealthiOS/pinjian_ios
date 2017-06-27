//
//  AccompanyCell.h
//  GuaHao
//
//  Created by PJYL on 16/10/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccompanyCell : UITableViewCell
-(void)layoutSubviews:(NSString *)type value:(NSString *)value discounPrice:(int)price isFirst:(BOOL)first indexPath:(NSIndexPath *)indexPath;
@end
