//
//  AddPersonFootCell.h
//  GuaHao
//
//  Created by PJYL on 2017/6/13.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitAction)(BOOL result);
@interface AddPersonFootCell : UITableViewCell
@property (nonatomic, copy) SubmitAction myAction;
-(void)buttonSelectAction:(SubmitAction)action;
@end
