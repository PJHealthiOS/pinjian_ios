//
//  ChooseHospitalcell.h
//  GuaHao
//
//  Created by PJYL on 2017/9/22.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalVO.h"
typedef void(^LocationClickAction)(HospitalVO *hosVO);


@interface ChooseHospitalcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cityImg;
@property (weak, nonatomic) IBOutlet UILabel *hospitName;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UIImageView *img3ga;
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;
@property (copy) LocationClickAction action;
-(void) setCell:(HospitalVO*) vo;
-(void)clickLocationAction:(LocationClickAction)action;

@end

