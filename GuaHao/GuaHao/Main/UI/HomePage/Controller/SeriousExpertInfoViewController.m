//
//  SeriousExpertInfoViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/3.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousExpertInfoViewController.h"

@interface SeriousExpertInfoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLbael;
@property (weak, nonatomic) IBOutlet UILabel *pospositionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;

@property (weak, nonatomic) IBOutlet UIView *goodView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *goodDescLabel;

@property (weak, nonatomic) IBOutlet UIView *experienceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *experienceViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (strong, nonatomic) ExpertVO *expertVO;
@property (nonatomic, strong)UIButton *rightItemButton;
@end

@implementation SeriousExpertInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家详情";
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]getExpDoctor:self.doctorVO.id andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data != [NSNull class] && data!= nil) {
            NSNumber *code = [data objectForKey:@"code"];
            NSString *msg = [data objectForKey:@"msg"];
            if (code.intValue == 0) {
                if ([data objectForKey:@"object"]) {
                     ExpertVO *expertVO = [ExpertVO mj_objectWithKeyValues:[data objectForKey:@"object"]];
                    [weakSelf loadSubViewsWith:expertVO];
                    weakSelf.expertVO = expertVO;
                    weakSelf.rightItemButton.selected = expertVO.followed;
                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
}
-(void)loadSubViewsWith:(ExpertVO *)expert{
    
    self.doctorNameLbael.text = expert.name;
    self.pospositionLabel.text = expert.title;
    self.amountLabel.text = [NSString stringWithFormat:@"预约量%@",expert.outpatientCount];
    self.departmentLabel.text = expert.departmentName;
    self.hospitalLabel.text = expert.hospitalName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:expert.avatar] placeholderImage:[UIImage imageNamed:@"order_expert_desc_icon_bgImage.png"]];
    
    self.goodDescLabel.text = expert.expert;
    
    
    self.experienceLabel.text = expert.resume;
    
}

- (IBAction)goodButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.goodViewHeight.constant = 112;
    }else{
        self.goodViewHeight.constant = 92 + [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 0) str:self.expertVO.expert fount:14].height;
    }
}

- (IBAction)experianceButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.experienceViewHeight.constant = 112;
    }else{
        self.experienceViewHeight.constant = 82 + [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 0) str:self.expertVO.resume fount:14].height;
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
- (IBAction)sureAction:(id)sender {
    self.myAction(self.doctorVO);
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)sureExpert:(SureExpertAction)action{
    self.myAction = action;
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
