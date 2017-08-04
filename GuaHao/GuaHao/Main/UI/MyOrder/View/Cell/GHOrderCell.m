//
//  GHOrderCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/3.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHOrderCell.h"

@interface GHOrderCell (){
    NSIndexPath *_indexPath;
    OrderListVO *_order;
}
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;


@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *CreateOrderAgain;
@property (assign,nonatomic) int payRemainingTime;
@property (assign,nonatomic) BOOL isRegister;
@property (assign,nonatomic) BOOL isHistory;

@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;
@property (weak, nonatomic) IBOutlet UIImageView *yuyueImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *againButtonRight;

@end
@implementation GHOrderCell
//删除订单
- (IBAction)deleteAction:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(_indexPath);
    }
}

- (IBAction)createOrderAgain:(id)sender {
    if (self.againBlock) {
        self.againBlock(_indexPath);
    }
}
-(void)deleteRow:(DeleteBlock)block{
    self.deleteBlock = block;
}

///去支付订单
- (IBAction)rightBUttonAction:(UIButton *)sender {
    if (self.payBlock != nil) {
        if (!_isHistory) {
            self.payBlock(YES,_indexPath);
        }
    }
}

-(void)setCellWithOrder:(OrderListVO *)order indexPath:(NSIndexPath *)indexPath isHistory:(BOOL)isHistory{
    _indexPath = indexPath;
    _order = order;
    
    [self.evaluateButton setTitle:order.evaluated.intValue == 1 ? @"查看评价":@"评价换流量" forState:UIControlStateNormal];
    self.statusLabel.text = order.statusCn;
    self.orderNumberLabel.text = [NSString stringWithFormat:@"- 订单编号 %@",order.serialNo];
    self.hospitalLabel.text = order.hospitalName;
    self.personNameLabel.text = [NSString stringWithFormat:@"%@(%@)",order.patientName,order.patientSex];
    self.orderDateLabel.text = order.visitDate;
    self.warningLabel.text = order.statusDesc;
     ///订单挂号状态 1.待支付 2待接单 3待挂号 4待就诊   9已完成  10已取消
    self.evaluateButton.hidden = order.status.intValue != 9 ;
    self.againButtonRight.constant = order.status.intValue == 9 ? 138:20;
    if (order.orderType.intValue == 0) {//普通号
        ///如果完成或者取消的订单可以删除   ///如果未支付显示支付倒计时，如果取消或者完成后显示 再次挂号。其他时间显示后台传的字段
        
        if (order.visitType.intValue == 0) {//0挂号 1预约
             self.yuyueImageView.hidden = YES;
            BOOL specail = YES;
            
            ///9已完成  10已取消
            if (order.status.intValue == 9 || order.status.intValue == 10) {
                self.deleteButton.hidden = NO;
                self.payButton.hidden = YES;
                self.CreateOrderAgain.hidden = NO;
                self.warningLabel.hidden = YES;
                specail = NO;
            }
                        //倒计时时间 1.待支付
            if (order.status.intValue == 1) {
                
                    [self registerNotificcation];
                
                
                self.payButton.hidden = NO;
                self.CreateOrderAgain.hidden = YES;
                self.warningLabel.hidden = YES;
                self.deleteButton.hidden = YES;

            }
            ///2待接单
            if (order.status.intValue == 2) {
                self.payButton.hidden = YES;
                self.CreateOrderAgain.hidden = YES;
                self.warningLabel.hidden = NO;
                self.deleteButton.hidden = YES;

            }
            ///3待挂号
            if (order.status.intValue == 3) {
                self.payButton.hidden = YES;
                self.CreateOrderAgain.hidden = YES;
                self.warningLabel.hidden = NO;
                self.deleteButton.hidden = YES;

            }
            ///待就诊
            if (order.status.intValue == 4) {
                self.payButton.hidden = YES;
                self.CreateOrderAgain.hidden = YES;
                self.warningLabel.hidden = NO;
                self.deleteButton.hidden = YES;
            }

            
            self.payRemainingTime = order.payRemainingTime.intValue;
        }else{//预约
            self.yuyueImageView.hidden = NO;
            if (order.status.intValue == 1) {//1待客服确认
                self.warningLabel.hidden = NO;
                self.CreateOrderAgain.hidden = YES;
                self.payButton.hidden = YES;
                self.deleteButton.hidden = YES;
            }
            if (order.status.intValue == 2) {//2确认待支付
                self.payButton.hidden = YES;
                self.CreateOrderAgain.hidden = YES;
                self.warningLabel.hidden = NO;
                self.deleteButton.hidden = YES;
            }
            if (order.status.intValue == 3) {//3待就诊
                self.payButton.hidden = YES;
                self.CreateOrderAgain.hidden = YES;
                self.warningLabel.hidden = NO;
                self.deleteButton.hidden = YES;
            }
            if (order.status.intValue == 9 || order.status.intValue == 10) {//9已完成  10已取消
                self.deleteButton.hidden = NO;
                self.payButton.hidden = YES;
                self.CreateOrderAgain.hidden = NO;
                self.warningLabel.hidden = YES;
            }
            self.payRemainingTime = order.payRemainingTime.intValue;
            
        }

    }else{//专家号
        self.yuyueImageView.hidden = YES;
        self.CreateOrderAgain.hidden = YES;
        self.payButton.hidden = YES;
        self.deleteButton.hidden = YES;

        if (order.status.intValue == 1) {//1待客服确认
            self.warningLabel.hidden = NO;
            self.CreateOrderAgain.hidden = YES;
            self.payButton.hidden = YES;
            self.deleteButton.hidden = YES;
        }
        if (order.status.intValue == 2) {//2确认待支付
            self.payButton.hidden = NO;
            self.CreateOrderAgain.hidden = YES;
            self.warningLabel.hidden = YES;
            self.deleteButton.hidden = YES;
        }
        if (order.status.intValue == 3) {//3待就诊
            self.payButton.hidden = YES;
            self.CreateOrderAgain.hidden = YES;
            self.warningLabel.hidden = YES;
            self.deleteButton.hidden = YES;
        }
        if (order.status.intValue == 4) {//已支付待预约
            self.payButton.hidden = YES;
            self.CreateOrderAgain.hidden = YES;
            self.warningLabel.hidden = NO;
            self.deleteButton.hidden = YES;
        }
        if (order.status.intValue == 9 || order.status.intValue == 10) {//9已完成  10已取消
            self.deleteButton.hidden = NO;
            self.payButton.hidden = YES;
            self.CreateOrderAgain.hidden = NO;
            self.warningLabel.hidden = YES;
        }
        
        [self returnCountStr:self.payRemainingTime];
        self.payRemainingTime = order.payRemainingTime.intValue;
        if (order.status.intValue == 2) {
            //        if (!self.isRegister) {
            [self registerNotificcation];
            //        }
        }
        
        
        
        
    }
    
    
}
///注册通知
-(void)registerNotificcation{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationEvent:) name:@"payCountdown" object:nil];
    self.isRegister = YES;
}
-(void)notificationEvent:(id)sender{
    
    if (self.payRemainingTime <= 0 && !_isHistory) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
//        self.payButton.hidden = YES;
//        self.warningLabel.hidden = NO;
        
        if (self.endBlock != nil) {
            
            self.endBlock(YES,_indexPath);
            
        }
    }else{
        self.payRemainingTime --;
        [self returnCountStr:self.payRemainingTime];
    }
}

-(void)returnCountStr:(int)time{
//    NSLog(@"----------去支付--------%ld------%d",(long)_indexPath.row,time);
    if (time > 0) {
        int minute = time /60 ;
        int second = time %60 ;
        NSString * str = [NSString stringWithFormat:@"去支付(还剩%02d分%02d秒)",minute,second];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttribute:NSForegroundColorAttributeName value:RGB(69, 199, 104) range:NSMakeRange(0, str.length)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3, str.length - 3 )];
        [self.payButton setAttributedTitle:attStr forState:UIControlStateNormal];
    }else{
       
        NSString * str = [NSString stringWithFormat:@"去支付"];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttribute:NSForegroundColorAttributeName value:RGB(69, 199, 104) range:NSMakeRange(0, str.length)];
        [self.payButton setAttributedTitle:attStr forState:UIControlStateNormal];
    }
    
}

-(void)countdownEnd:(EndCountdownBlock)block{
    self.endBlock = block;
}
-(void)pay:(PayBlock)block{
    self.payBlock = block;
}

-(void)createOrderAgainBlock:(CreateOrderAgainBlock)block{
    self.againBlock = block;
}
-(void)evaluateOrderAction:(EvaluateBlock)block{
    self.evaluateBlock = block;
}
- (IBAction)evaluateAction:(UIButton *)sender {
    self.evaluateBlock(_indexPath);
}

- (void)dealloc
{
//    NSLog(@"dealloc-------");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.isRegister = NO;
}
@end
