//
//  ExpertAccSwitchCell.h
//  GuaHao
//
//  Created by PJYL on 2016/10/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SwitchActionBlock) (BOOL select);
typedef void(^PZInfoAction) (BOOL select);

@interface ExpertAccSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *leftValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightValueLabel;

@property (copy, nonatomic) SwitchActionBlock myBlock;
@property (copy, nonatomic) PZInfoAction myAction;

-(void)switchAction:(SwitchActionBlock)block;
-(void)pzAction:(PZInfoAction)action;

-(void)layoutSubviewsWithTitle:(NSString *)title leftValue:(NSString *)leftStr rightValue:(NSString *)rightStr;
@end
