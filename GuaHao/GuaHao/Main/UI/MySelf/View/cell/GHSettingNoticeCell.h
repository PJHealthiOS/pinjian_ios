//
//  GHSettingNoticeCell.h
//  GuaHao
//
//  Created by PJYL on 16/9/2.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PushStatusDelegate)(BOOL open);
@interface GHSettingNoticeCell : UITableViewCell
@property (copy, nonatomic) PushStatusDelegate myBlock;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;
-(void)pushStatus:(PushStatusDelegate)block;
@end
