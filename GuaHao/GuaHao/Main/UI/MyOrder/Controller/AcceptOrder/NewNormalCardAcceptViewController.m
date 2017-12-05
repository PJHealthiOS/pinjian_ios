//
//  NewNormalCardAcceptViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/11/7.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "NewNormalCardAcceptViewController.h"
#import "UploadDatePickerView.h"
@interface NewNormalCardAcceptViewController (){
    AcceptOrderVO *_orderVO;
}
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *serialNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hopitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneNoButton;
@property (weak, nonatomic) IBOutlet UIButton *rowButton;
@property (weak, nonatomic) IBOutlet UIButton *endRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *endAccompanyButton;
@property (weak, nonatomic) IBOutlet UIButton *fullButton;
@property (weak, nonatomic) IBOutlet UIButton *closedButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;
@end

@implementation NewNormalCardAcceptViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"接单详情";
    self.infoViewHeight.constant =  300;
    
    [self getInfoDesc];
    
    // Do any additional setup after loading the view.
}
-(void)getInfoDesc
{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getNormalOrderDetail:self.serialNo longitude:@"" latitude:@""
                                         andCallback:^(id data) {
                                             [weakSelf.view hideToastActivity];
                                             if (data!=[NSNull class]&&data!=nil) {
                                                 NSNumber * code = data[@"code"];
                                                 NSString * msg = data[@"msg"];
                                                 if (code.intValue == 0) {
                                                     _orderVO = [AcceptOrderVO mj_objectWithKeyValues:data[@"object"]];
                                                     [weakSelf initView];
                                                 }else{
                                                     [weakSelf inputToast:msg];
                                                 }
                                             }
                                         }];
}
-(void)initView{
    [self addStatus];
    self.typeLabel.text = _orderVO.outpatientType;
    self.serialNoLabel.text = _orderVO.serialNo;
    self.hopitalLabel.text = _orderVO.hospName;
    self.departmentLabel.text = _orderVO.deptName;
    self.dateLabel.text = _orderVO.visitDate;
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",_orderVO.patientName,_orderVO.patientSex];
    self.cardLabel.text = _orderVO.patientIdcard;
    self.remarkLabel.text = _orderVO.patientComments.length == 0 ? @"无" : _orderVO.patientComments;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ 元",_orderVO.totalFee];;
    self.certificateLabel.text = _orderVO.patientStatus.intValue > 0 ? @"已认证" : @"未认证";
    
    ///对下面的按钮进行控制
   
    if (_orderVO.qrPaidStatus.intValue == 0) {///无需显示
        
        
        
    }else if (_orderVO.qrPaidStatus.intValue == 1){////待扫码支付
        
        
        
    }else if (_orderVO.qrPaidStatus.intValue == 2){///已经支付过了
        
        
    }
    
    
    
}

-(void)addStatus{
    [self.statusView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = _orderVO.statusLogs.count;
    CGFloat originX = (SCREEN_WIDTH - 0) /(count * 2.0);
    CGFloat space = (SCREEN_WIDTH - 0) /count;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(originX, 40, space * (count - 1), 2)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.statusView addSubview:lineView];
    for (int i = 0; i < count; i++) {
        StatusLogVO *vo = [_orderVO.statusLogs objectAtIndex:i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.center = CGPointMake(originX + space * i, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = vo.name;
        label.textColor = vo.isChecked ? UIColorFromRGB(0x45c768) :UIColorFromRGB(0xacacac);
        label.font = [UIFont systemFontOfSize:12];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 41, 10, 10)];
        view.backgroundColor = vo.isChecked ? UIColorFromRGB(0x45c768) :UIColorFromRGB(0xacacac);
        view.center = CGPointMake(originX + space * i, 41);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self.statusView addSubview:label];
        [self.statusView addSubview:view];
    }
    
}




- (IBAction)callPatientAction:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://+86%@",_orderVO.patientMobile]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)lookRemarkAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.remarkLabel.hidden = !sender.selected ;
    if (sender.selected) {
        self.infoViewHeight.constant = [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 0) str: _orderVO.patientComments.length == 0 ? @"无" : _orderVO.patientComments fount:13].height + 328;
    }else{
        self.infoViewHeight.constant =  300;
    }
    
}
////order/{id}/completeReg
- (IBAction)clickEndRegisterAction:(id)sender {
    
    UploadDatePickerView *pickerView = [[UploadDatePickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    [self.view addSubview:pickerView];

    [pickerView selectDateAction:^(NSString *selectStr) {
        NSLog(@"selectStr--%@",selectStr);
            [self.view makeToastActivity:CSToastPositionCenter];
        __weak typeof(self) weakSelf = self;

        [[ServerManger getInstance] normalOrderCompleteRegAction:_orderVO.id dateStr:selectStr andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                if (code.intValue == 0) {
                    if (code.intValue == 0) {
                        _orderVO = [AcceptOrderVO mj_objectWithKeyValues:data[@"object"]];
                        [weakSelf initView];
                    }else{
                        [weakSelf inputToast:msg];
                    }
                }
            }
        }];
    }];
    
    
    
    
   
}
////order/{id}/completePz
- (IBAction)clickEndAccompanyAction:(id)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] normalOrderOperationAction:_orderVO.id Operation:@"completePz" andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                _orderVO = [AcceptOrderVO mj_objectWithKeyValues:data[@"object"]];
                [weakSelf initView];
            }
        }
    }];
}
////order/{id}/noMore
- (IBAction)clickFullAction:(id)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] normalOrderOperationAction:_orderVO.id Operation:@"noMore" andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                _orderVO = [AcceptOrderVO mj_objectWithKeyValues:data[@"object"]];
                [weakSelf initView];
            }
        }
    }];
}
////order/{id}/notOpen
- (IBAction)notOpenAction:(id)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] normalOrderOperationAction:_orderVO.id Operation:@"notOpen" andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                _orderVO = [AcceptOrderVO mj_objectWithKeyValues:data[@"object"]];
                [weakSelf initView];
            }
        }
    }];
}


















- (CGSize)boundingRectWithSize:(CGSize)size str:(NSString *)str fount:(CGFloat)fount
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fount]};
    
    CGSize retSize = [str boundingRectWithSize:size
                                       options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    // Dispose of any resources that can be recreated.
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
