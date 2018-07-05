//
//  PlasticHospitalView.h
//  GuaHao
//
//  Created by PJYL on 2018/6/12.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlasticHospitalView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;


-(void)loadWithID:(NSInteger)idStr;
-(instancetype)initWithFrame:(CGRect)frame idStr:(NSInteger)idStr;
@end
