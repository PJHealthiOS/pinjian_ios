//
//  PlasticDoctrsView.h
//  GuaHao
//
//  Created by PJYL on 2018/6/12.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectDoctorAction)(NSNumber *idStr);

@interface PlasticDoctrsView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) SelectDoctorAction action;




-(instancetype)initWithFrame:(CGRect)frame idStr:(NSInteger)idStr;
-(void)loadWithID:(NSInteger)idStr;
-(void)selectDoctor:(SelectDoctorAction)action;
@end
