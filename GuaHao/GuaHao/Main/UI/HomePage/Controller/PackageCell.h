//
//  PackageCell.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageVO.h" 

typedef void(^SelectActionBlock)(PackageVO * backVO);
@interface PackageCell : UITableViewCell
@property (nonatomic , copy)SelectActionBlock myBlock;
-(void)packageSelectAction:(SelectActionBlock)block;
-(void)layoutSubviewWithVO:(PackageVO *)vo;
@end
