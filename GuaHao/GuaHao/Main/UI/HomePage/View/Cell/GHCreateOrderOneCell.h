//
//  GHCreateOrderOneCell.h
//  GuaHao
//
//  Created by PJYL on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickReturnBlock)(NSInteger tag);
@interface GHCreateOrderOneCell : UITableViewCell
@property (nonatomic,copy)ClickReturnBlock myBlock;
-(void)clickButtonReturn:(ClickReturnBlock)block;
@end
