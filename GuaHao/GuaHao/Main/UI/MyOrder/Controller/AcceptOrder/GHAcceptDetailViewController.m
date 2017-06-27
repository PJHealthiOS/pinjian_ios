//
//  GHAcceptDetailViewController.m
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHAcceptDetailViewController.h"
#import "GHAcceptOrderStatusCell.h"
#import "GHAcceptOrderManagerCell.h"
#import "GHAcceptOrderInfoCell.h"
#import "GHAcceptPatientRemarkCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "AcceptOrderVO.h"
#import "GHUploadCertificateViewController.h"
#import "CreateQRPayView.h"
//查看图片

@interface GHAcceptDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    AcceptOrderVO *_orderVO;
    
}

@property (strong, nonatomic) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CGFloat patientInfoHeight;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *certificateButton;
@property (weak, nonatomic) IBOutlet UIImageView *QRScanImageView;
@property (weak, nonatomic) IBOutlet UIButton *stopOrder;
@property (weak, nonatomic) IBOutlet UIButton *changeAMExpertOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *changePMExpertOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *changeAMNormalOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *changeGuaHaoButton;
@property (weak, nonatomic) IBOutlet UIButton *changeYuYueButton;
@property (weak, nonatomic) IBOutlet UIButton *fullOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *openOnlineServiceButton;

@end

@implementation GHAcceptDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceArr = [NSMutableArray arrayWithObjects:@{@"height":@"75",@"type":@"0",@"source":@[]},@{@"height":@"330",@"type":@"1",@"source":@[]}, nil];
    
    if(_acceptVO){
        _orderVO = _acceptVO;
        [self loadFootView];
        [self.tableView reloadData];
        [self initSweepView];
    }else{
        [self getInfoDesc];
    }


}

-(void)getInfoDesc
{
    [self.view makeToastActivity:CSToastPositionCenter];
    if (_order) {
        self.isNormal = _order.type.intValue == 1 ? YES : NO;
        self.serialNo = _order.serialNo;
    }
    NSLog(@"什么号--%@",self.isNormal ? @"----普通号----":@"-----专家号-----");
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getOrderDetailStatus:self.serialNo andNormalType:self.isNormal longitude:@"" latitude:@"" andCallback:^(id data) {
         [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                _orderVO = [AcceptOrderVO mj_objectWithKeyValues:data[@"object"]];
                [weakSelf setAttentionlabelConten];
                [weakSelf loadFootView];
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[[self.sourceArr objectAtIndex:indexPath.row] objectForKey:@"height" ] intValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self returnCellType:[[[self.sourceArr objectAtIndex:indexPath.row]objectForKey:@"type" ]  intValue]  indexPath:indexPath];
}
-(UITableViewCell *)returnCellType:(NSInteger)cellType  indexPath:(NSIndexPath *)indexPath{
    switch (cellType) {
        case 0:
        {
            static NSString *cellIdentifier = @"GHAcceptOrderStatusCell";

            GHAcceptOrderStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (nil == cell) {
                cell = [[GHAcceptOrderStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier type:self.order.type.intValue];
            }
            if (_orderVO.statusLogs.count > 0) {
                [cell layoutSubviewsWithLogs:_orderVO.statusLogs];
            }
            return cell;
        }
            break;
        case 1:
        {
            GHAcceptOrderInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHAcceptOrderInfoCell"];
            [GHAcceptOrderInfoCell renderCell:cell order:_orderVO];
            [cell openPatientInfo:^(BOOL end) {
                if (end) {
                    self.patientInfoHeight = [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 0) str: _orderVO.patientComments.length == 0 ? @"无" : _orderVO.patientComments fount:14].height;
                    NSDictionary *dic = @{@"height":[NSString stringWithFormat:@"%f", self.patientInfoHeight + 40],@"type":@"2",@"source":@[]};
                    [self.sourceArr insertObject:dic atIndex:2];
                    [self.tableView reloadData];
                }else{
   
                    [self.sourceArr removeObjectAtIndex:2];
                    [self.tableView reloadData];
                }
                
            }];
            
            return cell;
        }
            break;
        case 2:
        {
            GHAcceptPatientRemarkCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHAcceptPatientRemarkCell"];
            cell.InfoLabel.text = _orderVO.patientComments.length == 0 ? @"无" : _orderVO.patientComments;
            
            return cell;
        }
            break;
        case 3:
        {
            GHAcceptOrderManagerCell*cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHAcceptOrderManagerCell"];
            [cell renderCell:cell order:_orderVO];
            [cell uploadcertificate:^(int type) {
                if (type == 1) {
                    
                }else{
                    
                }
            }];
            
            return cell;
        }
            break;
        default:{
            return nil;
        }
            
            break;
    }
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

-(void)loadFootView{
    [self.QRScanImageView sd_setImageWithURL:[NSURL URLWithString:_orderVO.acceptQRCode] placeholderImage:nil];
    ///如果待审核或者已经审核了就不能点击


    
    if (_orderVO.operation != 0) {///
        //不可以点击
        [self setStatusWithButton:self.changeAMExpertOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.changePMExpertOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.changeAMNormalOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.fullOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.changeYuYueButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.changeGuaHaoButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        
        self.stopOrder.hidden = YES;
    }
    if (_isNormal) {
        self.stopOrder.hidden = YES;
        if (_orderVO.visitType.intValue == 0) {//挂号
            [self setStatusWithButton:self.changeGuaHaoButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
//            [self setStatusWithButton:self.changeGuaHaoButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        }else{//预约
//            [self setStatusWithButton:self.changeYuYueButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [self setStatusWithButton:self.changeYuYueButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            
        }

        self.changeAMExpertOrderButton.hidden = NO;
        self.changePMExpertOrderButton.hidden = NO;
        self.changeAMNormalOrderButton.hidden = NO;
        self.changeGuaHaoButton.hidden = NO;
        self.changeYuYueButton.hidden = NO;
        self.fullOrderButton.hidden = NO;

    }else{
         self.changeAMExpertOrderButton.hidden = YES;
         self.changePMExpertOrderButton.hidden = YES;
         self.changeAMNormalOrderButton.hidden = YES;
         self.changeGuaHaoButton.hidden = YES;
         self.changeYuYueButton.hidden = YES;
         self.fullOrderButton.hidden = YES;
         self.stopOrder.hidden = NO;
         self.openOnlineServiceButton.hidden = NO;

    }
    if (_orderVO.status.intValue != 2) {///如果不是待审核都不能点击
        [self setStatusWithButton:self.changeAMExpertOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.changePMExpertOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.changeAMNormalOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.fullOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.changeYuYueButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.changeGuaHaoButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.stopOrder color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
        [self setStatusWithButton:self.openOnlineServiceButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];

    }
    NSString *str;
    switch (_orderVO.operation.intValue) {
        case 1:
        {
            str = @"转上午普通专家号";
        }
            break;
        case 2:
        {
            str = @"转下午普通专家号";
        }
            break;
        case 3:
        {
            str = @"转上午普通号";
        }
            break;
        case 4:
        {
            str = @"今日号满";
        }
            break;
            
        default:
            break;
    }
    self.descriptionLabel.text = [NSString stringWithFormat:@"接单详情：%@",str];
    if (_orderVO.ticketImgUrl.length > 2) {
        [self.certificateButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_orderVO.ticketImgUrl] forState:UIControlStateNormal];
    }
    if (_orderVO.status.intValue == 2 || _orderVO.status.intValue == 3) {
        self.certificateButton.userInteractionEnabled = YES;
    }else{
        self.certificateButton.userInteractionEnabled = NO;
    }
    if (self.certificateButton.currentBackgroundImage) {
         [self.certificateButton setTitle:@"" forState:UIControlStateNormal];
    }
}
-(void)setStatusWithButton:(UIButton *)button color:(UIColor *)color userInteractionEnabled:(BOOL)userInteractionEnabled{
    button.layer.borderColor = color.CGColor;
    [button setTitleColor:color forState:UIControlStateNormal];
    button.userInteractionEnabled = userInteractionEnabled;
    
}
///上传凭证
- (IBAction)certificateUploadAction:(UIButton *)sender {

    if (_orderVO.visitType.intValue == 0) {///挂号
        __weak typeof(self) weakSelf = self;
        NormalUploadViewController *upload = [GHViewControllerLoader NormalUploadViewController];
        upload.postOrderVO = _orderVO;
        upload.isNormal = self.isNormal;
        [upload uploadSuccessAction:^(UIImage *image) {
            [weakSelf.certificateButton setBackgroundImage:image forState:UIControlStateNormal];
            //按钮都不能点击
            [weakSelf inputToast:@"成功"];
            [weakSelf setStatusWithButton:weakSelf.changeGuaHaoButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.changeYuYueButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.changeAMExpertOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.changePMExpertOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.changeAMNormalOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.fullOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            weakSelf.stopOrder.hidden = YES;
            weakSelf.openOnlineServiceButton.hidden = YES;
        }];
        [self.navigationController pushViewController:upload animated:YES];
    }else{///预约
        GHUploadCertificateViewController *upload = [GHViewControllerLoader GHUploadCertificateViewController];
        upload.postOrderVO = _orderVO;
        upload.isNormal = _isNormal;
        __weak typeof(self) weakSelf = self;
        [upload uploadSuccessAction:^(UIImage *image) {
            [weakSelf.certificateButton setBackgroundImage:image forState:UIControlStateNormal];
            //按钮都不能点击
            [weakSelf inputToast:@"成功"];
            [weakSelf setStatusWithButton:weakSelf.changeGuaHaoButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.changeYuYueButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.changeAMExpertOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.changePMExpertOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.changeAMNormalOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            [weakSelf setStatusWithButton:weakSelf.fullOrderButton color:UIColorFromRGB(0x888888) userInteractionEnabled:NO];
            weakSelf.stopOrder.hidden = YES;
            weakSelf.openOnlineServiceButton.hidden = YES;
        }];
        [self.navigationController pushViewController:upload animated:YES];
    }
    
    
    
    
    
    
    
    
}
///停诊
- (IBAction)stopOrderAction:(id)sender {
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] launchChangeExpertOrder:_orderVO.id operation:[NSNumber numberWithInt:1] andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                [self getInfoDesc];
            }
        }
    }];

}
///开通在线候诊功能
- (IBAction)openOnlineAction:(UIButton *)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] openOnlineServiceAction:_orderVO.id andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                [self getInfoDesc];
            }
        }
    }];
}

///转上午专家号
- (IBAction)changeAMExpertOrder:(UIButton *)sender {
    [self changeOrder:[NSNumber numberWithInt:1]];
}
///转下午专家号
- (IBAction)changePMExpertOrderAction:(UIButton *)sender {
    [self changeOrder:[NSNumber numberWithInt:2]];
}
///转下午普通号
- (IBAction)changeAMNormalOrderAction:(UIButton *)sender {
    [self changeOrder:[NSNumber numberWithInt:3]];
}
///今日号满
- (IBAction)fullOrderAction:(UIButton *)sender {
    [self changeOrder:[NSNumber numberWithInt:4]];
}
///转预约
- (IBAction)changeYuYueAction:(UIButton *)sender {
    [self changeOrder:[NSNumber numberWithInt:5]];
}
//转挂号
- (IBAction)changeGuaHaoAction:(UIButton *)sender {
    [self changeOrder:[NSNumber numberWithInt:6]];
}

-(void)changeOrder:(NSNumber *)type{
    
    [self.view makeToastActivity:CSToastPositionCenter];
    if (_orderVO.outpatientType.intValue == 0) {
        [[ServerManger getInstance] launchChangeNormalOrder:_orderVO.id operation:type andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                if (code.intValue == 0) {
                     [self getInfoDesc];
                }else{
                    
                }
            }
        }];
    }else{
        
    }
    
}

-(void)initSweepView
{
    if(!_isSweep){
        return;
    }
    if (_isSweep) {
        self.stopOrder.hidden = YES;
        self.openOnlineServiceButton.hidden = YES;
    }
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 48, SCREEN_WIDTH, 48)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, 5, SCREEN_WIDTH*0.6, 40)];
    [view addSubview:btn];
    btn.backgroundColor = RGB(124, 197, 110);
    [btn setTitle:@"确认领单" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) buttonAction: (UIButton *) button{
    if(_orderVO.status.intValue == 3 || _orderVO.status.intValue == 9){
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] completeGetTicket:_orderVO.id andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {  
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                
                if (code.intValue == 0) {
                    [self inputToast:@"订单已确认成功！"];
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }
}

///
-(void)setAttentionlabelConten{
    if (_orderVO.qrPaidStatus.intValue == 0) {///无需显示
        self.attentionLabel.hidden = YES;
        self.QRScanImageView.hidden = YES;
        self.remarkLabel.hidden = YES;
        
    }else if (_orderVO.qrPaidStatus.intValue == 1){////待扫码支付
        self.attentionLabel.text = @"用户如需扫码支付请点击此处";
        self.attentionLabel.userInteractionEnabled = YES;
        self.remarkLabel.text = @"待扫码支付";
        self.attentionLabel.hidden = NO;
        self.remarkLabel.hidden = NO;
    }else if (_orderVO.qrPaidStatus.intValue == 2){///已经支付过了
        self.attentionLabel.text = @"支付成功";
        self.remarkLabel.text = @"已支付";
        self.attentionLabel.hidden = NO;
        self.remarkLabel.hidden = NO;
    }
}
///点击切换状态
- (IBAction)attentionLabelAction:(id)sender {
    if (_orderVO.qrPaidStatus.intValue == 1) {///点击获取支付二维码
        CGRect frame = self.view.frame;
        
        CreateQRPayView*  qrView = [[CreateQRPayView alloc]initWithFrame:frame];
        qrView.orderID = _orderVO.id;
        qrView.isNormal = _isNormal;
         [qrView getPayInfoWithType:@"wx_pub_qr"];
        [qrView createTimer];

        qrView.frame = [UIScreen mainScreen].bounds;
        qrView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        __weak typeof(self) weakSelf = self;
        [qrView returnPayStatus:^(BOOL payStatus) {
            if (payStatus) {
                NSLog(@"支付成功了啊啊啊啊啊");
                [weakSelf getInfoDesc];
            }
        }];
        

        
        
        [self.view addSubview:qrView];

        
    }
}

@end
