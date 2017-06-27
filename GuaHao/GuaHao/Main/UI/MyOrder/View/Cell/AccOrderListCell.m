//
//  AccOrderListCell.m
//  GuaHao
//
//  Created by PJYL on 2016/10/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccOrderListCell.h"

@interface AccOrderListCell (){
    NSIndexPath *_indexPath;
}
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNuberLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *waringLabel;
@property (assign,nonatomic) int payRemainingTime;
@property (assign,nonatomic) BOOL isRegister;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *againButtonRight;


@end
@implementation AccOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)deleteRow:(DeleteBlock)block{
    self.deleteBlock = block;
}
-(void)pay:(PayBlock)block{
    self.payBlock = block;
}
- (IBAction)payAction:(UIButton *)sender {
    if (self.payBlock != nil) {
        
            self.payBlock(YES,_indexPath);
        
    }

}
- (IBAction)deleteAction:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(_indexPath);
    }
}
-(void)layoutSubviews:(OrderListVO *)vo andIndexPath:(NSIndexPath *)indexPath{
         ///订单挂号状态 1.待支付 2待接单 3待挂号 4待就诊   9已完成  10已取消
    [self.evaluateButton setTitle:vo.evaluated.intValue == 1 ? @"查看评价":@"评价换流量" forState:UIControlStateNormal];
    _indexPath = indexPath;
    self.orderStatusLabel.text = vo.statusCn;
    self.orderNuberLabel.text = [NSString stringWithFormat:@"-陪诊编号 %@",vo.serialNo];
    self.orderTypeLabel.text = vo.serviceTypeCn;
    self.dateLabel.text = vo.visitDate;
    self.nameLabel.text = vo.patientName;
    self.hospitalLabel.text = vo.hospitalName;
    self.waringLabel.text = vo.statusDesc;
    self.evaluateButton.hidden = vo.status.intValue != 9 ;
    self.againButtonRight.constant = vo.status.intValue == 9 ? 138:20;
    ///如果待支付
    if (vo.status.intValue == 1) {
        [self registerNotificcation];
         self.payRemainingTime = vo.payRemainingTime.intValue;
        self.payButton.hidden = NO;
        self.deleteButton.hidden = YES;
        self.waringLabel.hidden = YES;
    }else if (vo.status.intValue == 9 || vo.status.intValue == 10) {
        self.deleteButton.hidden = YES;
        self.payButton.hidden = YES;
        self.waringLabel.hidden = NO;
    }else {
        self.payButton.hidden = YES;
        self.deleteButton.hidden = YES;
        self.waringLabel.hidden = NO;
        
    }
    
    
}
///注册通知
-(void)registerNotificcation{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationEvent:) name:@"AccpayCountdown" object:nil];
    self.isRegister = YES;
}
-(void)notificationEvent:(id)sender{
    
    if (self.payRemainingTime <= 0 ) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
        self.payButton.hidden = YES;
        self.waringLabel.hidden = NO;
        
        
    }else{
        self.payRemainingTime --;
        [self returnCountStr:self.payRemainingTime];
    }
}
-(void)returnCountStr:(int)time{
//        NSLog(@"------------------------%d",time);
    int minute = time /60 ;
    int second = time %60 ;
    NSString * str = [NSString stringWithFormat:@"去支付(还剩%02d分%02d秒)",minute,second];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:RGB(69, 199, 104) range:NSMakeRange(0, str.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3, str.length - 3 )];
    [self.payButton setAttributedTitle:attStr forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)evaluateAction:(UIButton *)sender {
    self.evaluateBlock(_indexPath);

}
-(void)evaluateOrderAction:(EvaluateBlock)block{
    self.evaluateBlock = block;
}
- (void)dealloc
{
    NSLog(@"dealloc-------");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.isRegister = NO;
}
@end
