//
//  SpecialDoctorInfoViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/11/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SpecialDoctorInfoViewController.h"
#import "ExpertDayCell.h"
#import "CreateOrderExpertViewController.h"
#import "HtmlAllViewController.h"
@interface SpecialDoctorInfoViewController (){
    ExpertVO *expertVO;
    
    
    
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *remarkButon;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLbael;
@property (weak, nonatomic) IBOutlet UILabel *pospositionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;

@property (weak, nonatomic) IBOutlet UIView *goodView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *goodDescLabel;

@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *listView;

@property (weak, nonatomic) IBOutlet UIView *experienceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *experienceViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;

@end



@implementation SpecialDoctorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"医生信息";
    [self getData];
    
    // Do any additional setup after loading the view.
}



- (IBAction)remarlAction:(UIButton *)sender {
    if(expertVO.followed){
        __weak typeof(self) weakSelf = self;
        [[ServerManger getInstance] unfollow:self.doctorId andCallback:^(id data) {
            
            [weakSelf.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        expertVO.followed = NO;
                        weakSelf.remarkButon.selected = expertVO.followed;
                        [weakSelf inputToast:@"取消关注成功！"];
                    }
                }else{
                    [weakSelf inputToast:msg];
                }
            }
        }];
    }else{
         __weak typeof(self) weakSelf = self;
        [[ServerManger getInstance] follow:self.doctorId andCallback:^(id data) {
           
            [weakSelf.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        expertVO.followed = YES;
                        weakSelf.remarkButon.selected = expertVO.followed;
                        [weakSelf inputToast:@"关注成功！"];
                    }
                }else{
                    [weakSelf inputToast:msg];
                }
            }
        }];
    }
}

-(void)getData{
     __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]getExpDoctor:self.doctorId andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data != [NSNull class] && data!= nil) {
            NSNumber *code = [data objectForKey:@"code"];
            NSString *msg = [data objectForKey:@"msg"];
            if (code.intValue == 0) {
                if ([data objectForKey:@"object"]) {
                    expertVO = [ExpertVO mj_objectWithKeyValues:[data objectForKey:@"object"]];
                    [weakSelf reloadPage];
                    [weakSelf reloadListView];
                    weakSelf.remarkButon.selected = expertVO.followed;
                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
}

-(void)reloadPage{
    
    self.doctorNameLbael.text = expertVO.name;
    self.amountLabel.text = [NSString stringWithFormat:@"预约量%@",expertVO.outpatientCount];
    self.pospositionLabel.text = [NSString stringWithFormat:@"%@   %@" ,expertVO.departmentName,expertVO.title];
    self.hospitalLabel.text = expertVO.hospitalName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:expertVO.avatar] placeholderImage:[UIImage imageNamed:@"order_expert_desc_icon_bgImage.png"]];
    
    self.goodDescLabel.text = expertVO.expert;
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@-%@",expertVO.departmentName,expertVO.hospitalName];
    
    self.experienceLabel.text = expertVO.resume;
    
}


-(void)reloadListView{
     [self.listView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *arr = [expertVO getAllDays];
    CGFloat originX = 0;
    for (int i = 0; i< arr.count; i++) {
        
        ExpertDayCell *cell = [[[UINib nibWithNibName:@"ExpertDayCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(originX, 0, 50, 150);
        cell.dayVO = [arr objectAtIndex:i];
        [cell loadCell];
        [self.listView addSubview:cell];
        __weak typeof(self) weakSelf = self;
        [cell clickAction:^(DayVO *vo) {
            [weakSelf pushToCreateOrderPage:vo];
        }];
        
        originX = originX + 50;
        
    }
    self.listView.contentSize = CGSizeMake(50 * arr.count + 5, 150);
    
}

-(void)pushToCreateOrderPage:(DayVO *)vo{
    
    if ([DataManager getInstance].loginState != 1) {
        LoginViewController * vc = [GHViewControllerLoader LoginViewController];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    
    CreateOrderExpertViewController * createVC = [GHViewControllerLoader CreateOrderExpertViewController];
    createVC.dayVO = vo;
    createVC.expertVO = expertVO;
    
    
    [self.navigationController pushViewController:createVC animated:YES];
}


- (IBAction)expertRuleAction:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"预约规则";
    view.mUrl   = [NSString stringWithFormat:@"%@htmldoc/specialBookingRules.html",[ServerManger getInstance].serverURL];
    [self.navigationController pushViewController:view animated:YES];
}



- (IBAction)goodButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.goodViewHeight.constant = 112;
    }else{
        self.goodViewHeight.constant = 92 + [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 0) str:expertVO.expert fount:14].height;
    }
}

- (IBAction)experianceButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.experienceViewHeight.constant = 110;
    }else{
        self.experienceViewHeight.constant = 85 + [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 0) str:expertVO.resume fount:14].height;
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
