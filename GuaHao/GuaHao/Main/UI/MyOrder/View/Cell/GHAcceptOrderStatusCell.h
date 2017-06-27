//
//  GHAcceptOrderStatusCell.h
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GHAcceptOrderStatusCell : UITableViewCell
-(void)layoutSubviewsWithLogs:(NSArray *)source;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  type:(int)type ;
@end
