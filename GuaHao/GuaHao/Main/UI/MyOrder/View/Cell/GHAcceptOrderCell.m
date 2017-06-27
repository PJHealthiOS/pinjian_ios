//
//  GHAcceptOrderCell.m
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHAcceptOrderCell.h"

@interface GHAcceptOrderCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealwithOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *certificateTestButton;
@property (weak, nonatomic) IBOutlet UILabel *allReadyLabel;

@property (assign,nonatomic) int payRemainingTime;
@property (assign,nonatomic) BOOL isRegister;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
@implementation GHAcceptOrderCell{
    AcceptVO * acceptVO;
}
-(void)countdownEnd:(EndCountdownBlock)block{
    self.endBlock = block;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)dealWithOrderAction:(UIButton *)sender {
    if(_onBlockAccept){
        
        _onBlockAccept(acceptVO.type.intValue,acceptVO.id);
    }
}
- (IBAction)certificateAction:(id)sender {
    if (self.certificateBlock) {
        self.certificateBlock(acceptVO);
    }
}
-(void)certificateBlock:(CertificateBlock)block{
    self.certificateBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setWJCell:(AcceptVO *) vo indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    acceptVO = vo;
    _typeLabel.text = vo.typeCN;
    _dateLabel.text = vo.visitDate;
    _numberLabel.text =[NSString stringWithFormat:@"%@",vo.serialNo];
    _statusLabel.text = @"";
    _departmentLabel.text = vo.departmentName;
    _hospitalLabel.text = vo.hospitalName;
    _nameLabel.text = [NSString stringWithFormat:@"%@", vo.patientName];
    _descriptionLabel.text = @"";
    if (vo.acceptStatus.intValue == 1) {
        [_dealwithOrderButton setTitle:@"确认派单" forState:UIControlStateNormal];
        _dealwithOrderButton.hidden = NO;
        _allReadyLabel.hidden = YES;
    }else{
        _dealwithOrderButton.hidden = YES;
        _allReadyLabel.hidden = NO;

    }
    if (vo.patientStatus.intValue > 0 ) {
        _certificateTestButton.userInteractionEnabled = YES;
        [_certificateTestButton setTitleColor:GHDefaultColor forState:UIControlStateNormal];
        [_certificateTestButton setTitle:@"已认证" forState:UIControlStateNormal];
    }else{
        [_certificateTestButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        _certificateTestButton.userInteractionEnabled = NO;
        [_certificateTestButton setTitle:@"未认证" forState:UIControlStateNormal];
    }
}
-(void)setCell:(AcceptVO *) vo type:(int) type indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    acceptVO = vo;
    _typeLabel.text = vo.typeCN;
    _dateLabel.text = vo.visitDate;
    _numberLabel.text =[NSString stringWithFormat:@"%@",vo.serialNo];
    _statusLabel.text = @"";
    _departmentLabel.text = vo.departmentName;
    _hospitalLabel.text = vo.hospitalName;
    _nameLabel.text = [NSString stringWithFormat:@"@%@ (%@)", vo.patientName,vo.patientSex];
    _descriptionLabel.text = @"";
    if (vo.type.intValue==1) {
        //普通号
        _dealwithOrderButton.hidden = NO;
    }else{
        ///专家号
        if (vo.hasSubmit) {
            _dealwithOrderButton.hidden = YES;
        }
        
    }
    [_dealwithOrderButton setTitle:vo.type.intValue==1?@"接单":@"确认派单" forState:UIControlStateNormal];
  
            NSString* curTime = [Utils getCurrentSecond];
            int pass = [ServerManger getInstance].acceptTime.intValue;
//            NSNumber * time = [NSNumber numberWithInt:_orderVO.payRemainingTime.intValue - pass];
//            [_labDownTime startTime:@"去支付" second:time type:[NSNumber numberWithInt:1]];
    
    self.payRemainingTime = vo.remainingTime.intValue - pass;
    
    
    if (vo.patientStatus.intValue > 0 ) {
        _certificateTestButton.userInteractionEnabled = YES;
        [_certificateTestButton setTitleColor:GHDefaultColor forState:UIControlStateNormal];
        [_certificateTestButton setTitle:@"已认证" forState:UIControlStateNormal];
    }else{
        [_certificateTestButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        _certificateTestButton.userInteractionEnabled = NO;
        [_certificateTestButton setTitle:@"未认证" forState:UIControlStateNormal];
    }
    
    switch (type) {
        case 1://待接单
        {

            _dealwithOrderButton.hidden = NO;
            
             if (vo.status.intValue == 1 && vo.visitType.intValue == 0)[self registerNotificcation];
            
            
            break;
        }
        case 2://.普通号
        {

            _certificateTestButton.hidden = NO;
            _dealwithOrderButton.hidden = YES;
            if (vo.status.intValue == 1 && vo.visitType.intValue == 0)[self registerNotificcation];
        }
        case 3://专家号
        {

            if (vo.status.intValue == 1 && vo.visitType.intValue == 0)[self registerNotificcation];
            break;
        }
        case 4://已完成
        {
            _certificateTestButton.hidden = YES;
            _dealwithOrderButton.hidden = YES;
            _statusLabel.text = vo.statusCn;
            break;
        }
            
        default:
            break;
    }
    
}
///注册通知
-(void)registerNotificcation{
    [self returnCountStr:self.payRemainingTime];
//    if (self.isRegister) {
//        return;
//    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationEvent:) name:@"AcceptOrderpayCountdown" object:nil];
    self.isRegister = YES;
}
-(void)notificationEvent:(id)sender{
    
    if (self.payRemainingTime <= 0 ) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        if (self.endBlock != nil) {
            self.endBlock(YES,_indexPath);
        }
    }else{
        self.payRemainingTime --;
        [self returnCountStr:self.payRemainingTime];
    }
}
-(void)returnCountStr:(int)time{
//        NSLog(@"------------------------%d",time);

    int second = time %60 ;
    int minute = time%3600/60  ;
    int hour = time%(3600*24)/3600;
    int day = time/(3600 *24);
    NSString * str = [NSString stringWithFormat:@"倒计时 %02d天%02d小时%02d分%02d秒",day,hour,minute,second];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:RGB(69, 199, 104) range:NSMakeRange(0, str.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4, str.length - 4 )];
    self.descriptionLabel.attributedText = attStr ;
}
- (void)dealloc
{
    NSLog(@"dealloc-------");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.isRegister = NO;
}
@end
