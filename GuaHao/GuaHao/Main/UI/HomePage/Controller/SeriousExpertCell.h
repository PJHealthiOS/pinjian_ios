//
//  SeriousExpertCell.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorVO.h"

typedef void(^SelectExpertBlock)(NSArray *selectArr ,BOOL full);
@interface SeriousExpertCell : UITableViewCell
@property (nonatomic, copy) SelectExpertBlock myBlock;
-(void) setCell:(DoctorVO*) vo selectedArr:(NSArray*)selectedArr indexPath:(NSIndexPath *)indexPath;
-(void)selectExpertAction:(SelectExpertBlock)block;
@end
