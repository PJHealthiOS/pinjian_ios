//
//  GHOrderAccompanyCellCell.m
//  GuaHao
//
//  Created by PJYL on 2016/10/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHOrderAccompanyCellCell.h"

@interface GHOrderAccompanyCellCell(){
    
}
@property (weak, nonatomic) IBOutlet UILabel *accompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
@implementation GHOrderAccompanyCellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews:(NSString *)accStr take:(NSString *)take address:(NSString *)add{
    self.accompanyLabel.text = accStr;
    self.takeLabel.text = add;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
