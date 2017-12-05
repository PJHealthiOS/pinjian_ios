//
//  SeriousOrderDetailViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousOrderDetailViewController.h"
#import "SeriousOrderDetailModel.h"
#import "ExpertView.h"
#import "SeriousDetailModel.h"
#import "ImageViewController.h"
#import "UIButton+EMWebCache.h"
@interface SeriousOrderDetailViewController ()
@property (nonatomic, strong)SeriousOrderDetailModel *orderVO;
@property (weak, nonatomic) IBOutlet UIView *statusBackView;
@property (strong, nonatomic) NSNumber *id;
@property (weak, nonatomic) IBOutlet UILabel *serialNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *expertScrollView;
@property (weak, nonatomic) IBOutlet UILabel *otherExpertTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@end

@implementation SeriousOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重疾订单详情";
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]getSeriosOrderDetail:self.serialNo andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                _orderVO = [SeriousOrderDetailModel mj_objectWithKeyValues:data[@"object"]];
                NSLog(@"重疾详情----%@",_orderVO);
                [weakSelf setCell];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
}

-(void)setCell{
    [self addStatus];
    [self addDoctor];
    [self loadSelectImages];
    self.serialNoLabel.text = self.orderVO.serialNo;
    self.packageLabel.text = self.orderVO.packageName;
    self.nameLabel.text = self.orderVO.patient;
    self.IDCardLabel.text = self.orderVO.cardID;
    self.phoneNumLabel.text = self.orderVO.mobile;
    self.otherExpertTextView.text = self.orderVO.remarkedDoctor;
    self.dateLabel.text = self.orderVO.operationWishDate;
    self.descriptionLabel.text = self.orderVO.illnessDesc;
    if (self.orderVO.orderStatus.intValue != 0 ) {
        self.cancelButton.hidden = YES;
    }
    
}
-(void)loadSelectImages{
    [self.imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat originX = 0;
    for (int i = 0; i < self.orderVO.illnessImgs.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX , 5, 60, 60);
        [button sd_setBackgroundImageWithURL:[[self.orderVO.illnessImgs objectAtIndex:i] objectForKey:@"imgUrl"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageScrollView addSubview:button];
        originX = originX + 5 + 60;
    }
    self.imageScrollView.contentSize = CGSizeMake(originX + 80, CGRectGetHeight(self.imageScrollView.frame));
    
}
-(void)lookAction:(UIButton *)sender{
    ImageViewController * view = [[ImageViewController alloc]init];
    view.image = sender.currentBackgroundImage;
    [self.navigationController pushViewController:view animated:YES];
}
-(void)addDoctor{
    [self.expertScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat originX = 0;
    int num = SCREEN_WIDTH/105;
    CGFloat width = SCREEN_WIDTH /num;
    for (int i = 0 ; i < self.orderVO.doctors.count;i++) {
        SeriousDetailModel *doctorModel = [self.orderVO.doctors objectAtIndex:i];
        ExpertView *cell = [[[UINib nibWithNibName:@"ExpertView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.close = YES;
        cell.frame = CGRectMake(originX, 0, width, 158);
        DoctorVO * doctorVO = [DoctorVO mj_objectWithKeyValues:@{@"id":doctorModel.id,@"name":doctorModel.doctorName,@"img":doctorModel.avatar,@"grade":doctorModel.grade,@"hospitalName":doctorModel.hospitalName,@"departmentName":doctorModel.departmentName}];
        [cell setCell:doctorVO];
        originX = originX + SCREEN_WIDTH/3.0;
        [self.expertScrollView addSubview:cell];
        
    }
    self.expertScrollView.contentSize = CGSizeMake(originX , CGRectGetHeight(self.expertScrollView.frame));
    self.expertScrollView.showsHorizontalScrollIndicator = YES;
}
-(void)addStatus{
    [self.statusBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = self.orderVO.statusLogs.count;
    CGFloat originX = SCREEN_WIDTH /(count * 2.0);
    CGFloat space = SCREEN_WIDTH /count;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(originX, 40, space * (count - 1), 2)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.statusBackView addSubview:lineView];
    for (int i = 0; i < count; i++) {
        StatusLogVO *vo = [self.orderVO.statusLogs objectAtIndex:i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.center = CGPointMake(originX + space * i, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = vo.name;
        label.textColor = vo.isChecked ? UIColorFromRGB(0x45c768) :UIColorFromRGB(0x888888);
        label.font = [UIFont systemFontOfSize:12];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 41, 10, 10)];
        view.backgroundColor = vo.isChecked ? UIColorFromRGB(0x45c768) :UIColorFromRGB(0x888888);
        view.center = CGPointMake(originX + space * i, 41);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        
        [self.statusBackView addSubview:label];
        [self.statusBackView addSubview:view];
    }

}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]cancelSeriousOrder:_orderVO.id andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                sender.selected = YES;
                sender.userInteractionEnabled = NO;
                [weakSelf getData];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}
-(BOOL) navigationShouldPopOnBackButton ///在这个方法里写返回按钮的事件处理
{
    //这里写要处理的代码
    NSArray *viewControllers = self.navigationController.viewControllers;
    if(!_popBack||_popBack==0){
        _popBack = PopBackDefalt;
    }
    NSUInteger num = viewControllers.count - _popBack;
    if(_popBack == PopBackRoot){
        num = 0;
    }
    [self.navigationController popToViewController:[viewControllers objectAtIndex:num] animated:YES];
    return YES;//返回NO 不会执行
    
}
#pragma mark - 评价
- (IBAction)evaluateAction:(id)sender {
    if (self.orderVO.orderStatus.intValue != 2) {
        return;
    }
    if (_orderVO.evaluated.intValue == 0) {
        EvaluateViewController *evaluateVC = [GHViewControllerLoader EvaluateViewController];
        evaluateVC._id = _orderVO.id;
        evaluateVC.orderType = [NSNumber numberWithInt:3];
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }else{
        EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
        evaluateOKVC._id = _orderVO.id;
        evaluateOKVC.orderType = [NSNumber numberWithInt:3];
        [self.navigationController pushViewController:evaluateOKVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
