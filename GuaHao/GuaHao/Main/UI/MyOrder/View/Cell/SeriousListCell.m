//
//  SeriousListCell.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousListCell.h"

@interface SeriousListCell (){
    NSIndexPath *_indexPath;

}
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;

@end
@implementation SeriousListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteOrderAction:(id)sender {
}
-(void)setCellWithModel:(SeriousListModel *)model{
    ///UNCONFIRM("待确认", 0), CANCELLED("已取消", 1),VISITED("已就诊", 2), PROCESSING("处理中", 3);
    self.statusLabel.text = model.processStatus;
    self.serialNoLabel.text = [NSString stringWithFormat:@"-陪诊编号 %@", model.serialNo];
    self.packageLabel.text = model.packageName;
    self.phoneLabel.text = model.mobile;
    self.descLabel.text = model.processStatus;
    self.personLabel.text = model.patient;
    self.evaluateButton.hidden = model.orderStatus.intValue != 2 ;
    [self.evaluateButton setTitle:model.evaluated.intValue == 1 ? @"查看评价":@"评价换流量" forState:UIControlStateNormal];


}
- (IBAction)evaluateAction:(UIButton *)sender {
    self.evaluateBlock(_indexPath);
}
-(void)evaluateOrderAction:(EvaluateBlock)block{
    self.evaluateBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
