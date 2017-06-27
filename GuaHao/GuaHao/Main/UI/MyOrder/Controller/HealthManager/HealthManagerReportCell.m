//
//  HealthManagerReportCell.m
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthManagerReportCell.h"

@interface HealthManagerReportCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
@implementation HealthManagerReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviewsWith:(HealthManagerReportModel *)model{
    self.dateLabel.text =[NSString stringWithFormat:@"报告生成日期：%@", model.createDate];
}
- (IBAction)detialAction:(id)sender {
    self.myAction(YES);
}
-(void)clickAction:(DetailClickAction)action{
    self.myAction = action;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
