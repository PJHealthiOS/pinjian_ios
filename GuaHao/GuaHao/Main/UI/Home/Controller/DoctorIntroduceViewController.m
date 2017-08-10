 //
//  DoctorIntroduceViewController.m
//  GuaHao
//
//  Created by qiye on 16/4/18.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DoctorIntroduceViewController.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "ExpertVO.h"
#import "DayCell.h"
#import "GHViewControllerLoader.h"
#import "CreateOrderExpertViewController.h"
#import "HtmlAllViewController.h"
#import "UIViewBorders.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "LoginViewController.h"

@interface DoctorIntroduceViewController ()<DayCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labDepartment;
@property (weak, nonatomic) IBOutlet UILabel *labHospital;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labIntroduce;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bellowVIew;
@property (weak, nonatomic) IBOutlet UIScrollView *tableScroll;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *labDoc1;
@property (weak, nonatomic) IBOutlet UILabel *labDoc2;
@property (weak, nonatomic) IBOutlet UIButton *btnExpert;
@property (weak, nonatomic) IBOutlet UIButton *btnSpeical;
@property (weak, nonatomic) IBOutlet UIButton *btnExpertMore;
@property (weak, nonatomic) IBOutlet UIView *viewExpert;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
@property (weak, nonatomic) IBOutlet UIButton *btnIntroduceMore;
@property (weak, nonatomic) IBOutlet UIView *viewIntroduce;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;

@end

@implementation DoctorIntroduceViewController{
    ExpertVO * expertVO;
    BOOL   isAll;
    NSMutableArray * cells;
    UIButton * selectBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    isAll = YES;
    [_iconImg roundBorder:[UIColor whiteColor] width:3];
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getExpDoctor:_doctorID andCallback:^(id data) {
        
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    expertVO = [ExpertVO mj_objectWithKeyValues:data[@"object"]];
                    _btnCollection.selected = expertVO.followed;
                    [self initView];
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void) initView
{
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:expertVO.avatar]];
    _labName.text = expertVO.name;
    _labDepartment.text = expertVO.departmentName;
    _labHospital.text = expertVO.hospitalName;
    _labNum.text = [NSString stringWithFormat:@"预约量%@",expertVO.outpatientCount];
    _labIntroduce.text = [NSString stringWithFormat:@"%@-%@",expertVO.departmentName,expertVO.hospitalName];
    _labDoc1.text = expertVO.expert;
    _labDoc2.text = expertVO.resume;
    _btnExpert.selected = YES;
    NSArray * arr = [expertVO getAllDays];
    cells = [NSMutableArray new];
    for (int i = 0; i<arr.count; i++) {
        DayCell * cell = [[DayCell alloc] initWithFrame:CGRectMake(i*65, 0, 65, 146)];
        cell.dayVO = arr[i];
        cell.delegate = self;
        [cell setCell];
        [_tableScroll addSubview:cell];
        [cells addObject:cell];
    }
    _tableScroll.contentSize = CGSizeMake(65*arr.count+5, 148);
    _btnExpert.selected = NO;
    _btnSpeical.selected = NO;
}

#pragma mark - DayCellDelegate
-(void) delegateSelectDayCell:(DayVO*) vo
{
//    ExpertNewViewController * view = [[ExpertNewViewController alloc] init];
//    view.dayVO = vo;
//    view.expertVO = expertVO;
//    if (_quickType == 2) {
//        view.quickType = 2;
//        view.patientVO = _patientVO;
//    }
    if ([DataManager getInstance].loginState != 1) {
        LoginViewController * vc = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }
    CreateOrderExpertViewController *createVC = [GHViewControllerLoader CreateOrderExpertViewController];
    createVC.dayVO = vo;
    createVC.expertVO = expertVO;
    if (_quickType == 2) {
        createVC.quickType = 2;
        createVC.patientVO = _patientVO;
    }
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _bellowVIew.y = _viewIntroduce.y + _viewIntroduce.height;
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bellowVIew.frame)+15);
}

- (IBAction)onCollection:(id)sender {
    if(expertVO.followed){
        [[ServerManger getInstance] unfollow:_doctorID andCallback:^(id data) {
            
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        expertVO.followed = NO;
                        _btnCollection.selected = expertVO.followed;
                        [self inputToast:@"取消关注成功！"];
                    }
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }else{
        [[ServerManger getInstance] follow:_doctorID andCallback:^(id data) {
            
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        expertVO.followed = YES;
                        _btnCollection.selected = expertVO.followed;
                        [self inputToast:@"关注成功！"];
                    }
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChange:(id)sender {
    UIButton * btn = (UIButton*) sender;
    if(selectBtn == btn){
        return;
    }

    isAll = btn.tag == 101;
    selectBtn = btn;
    _btnExpert.selected = NO;
    _btnSpeical.selected = NO;
    btn.selected = YES;
    NSArray * arr = [expertVO getDays:isAll];
    for (int i = 0; i<arr.count; i++) {
        DayCell * cell = cells[i];
        cell.dayVO = arr[i];
        [cell setCell];

    }
    
}

- (IBAction)onExpertMore:(id)sender {
    _btnExpertMore.selected = !_btnExpertMore.selected;
    if(_btnExpertMore.selected){
        _labDoc1.numberOfLines =0;
        _labDoc1.lineBreakMode = NSLineBreakByWordWrapping;
        CGRect tmpRect2 = [_labDoc1.text boundingRectWithSize:CGSizeMake(_labDoc1.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_labDoc1.font,NSFontAttributeName, nil] context:nil];
        CGFloat contentH2 = ceil(tmpRect2.size.height);
        _labDoc1.frame = CGRectMake(_labDoc1.frame.origin.x, _labDoc1.frame.origin.y, _labDoc1.frame.size.width,contentH2);
        _viewExpert.height = contentH2 + 70;
    }else{
        _labDoc1.numberOfLines =1;
        _viewExpert.height = 92;
        _labDoc1.frame = CGRectMake(_labDoc1.frame.origin.x, _labDoc1.frame.origin.y, _labDoc1.frame.size.width,15);
    }
    _btnExpertMore.center = CGPointMake(_btnExpertMore.center.x,_viewExpert.height - _btnExpertMore.height);
    
    _viewDate.y = _viewExpert.y + _viewExpert.height;
    _viewIntroduce.y = _viewDate.y + _viewDate.height;
    _bellowVIew.y = _viewIntroduce.y + _viewIntroduce.height;
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bellowVIew.frame)+15);
}

- (IBAction)onIntroduceMore:(id)sender {
    _btnIntroduceMore.selected = !_btnIntroduceMore.selected;
    if(_btnIntroduceMore.selected){
        _labDoc2.numberOfLines =0;
        _labDoc2.lineBreakMode = NSLineBreakByWordWrapping;
        CGRect tmpRect2 = [_labDoc2.text boundingRectWithSize:CGSizeMake(_labDoc2.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_labDoc2.font,NSFontAttributeName, nil] context:nil];
        CGFloat contentH2 = ceil(tmpRect2.size.height);
        _labDoc2.frame = CGRectMake(_labDoc2.frame.origin.x, _labDoc2.frame.origin.y, _labDoc2.frame.size.width,contentH2);
        _viewIntroduce.height = contentH2 + 70;
    }else{
        _labDoc2.numberOfLines =1;
        _viewIntroduce.height = 92;
        _labDoc2.frame = CGRectMake(_labDoc2.frame.origin.x, _labDoc2.frame.origin.y, _labDoc2.frame.size.width,15);
    }
    _btnIntroduceMore.center = CGPointMake(_btnIntroduceMore.center.x,_viewIntroduce.height - _btnIntroduceMore.height);
    
    _bellowVIew.y = _viewIntroduce.y + _viewIntroduce.height;
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bellowVIew.frame)+15);
}

- (IBAction)onRule:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"预约规则";
    view.mUrl   = [NSString stringWithFormat:@"%@htmldoc/specialBookingRules.html",[ServerManger getInstance].serverURL];
    [self.navigationController pushViewController:view animated:YES];
}
@end
