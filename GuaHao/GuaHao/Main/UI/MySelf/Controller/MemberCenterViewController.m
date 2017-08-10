//
//  MemberCenterViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/7/20.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "UIView+Shadow.h"
#import "MemberCenterModel.h"
#import "MemberLevelModel.h"
#import "HtmlAllViewController.h"
@interface MemberCenterViewController ()<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *memberLevelLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *equityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equityHeight;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) NSMutableArray *memberItems;
@property (strong, nonatomic) MemberCenterModel *model;
@property (strong, nonatomic) MemberLevelModel *selectModel;
@property (assign, nonatomic) int selectIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *usableTimesLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomOpenButton;

@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    [self loadData];
   // [self loadSubView];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([DataManager getInstance].user.memberLevel.intValue > 0) {
        [self.memberLevelLabel setTitle:@"" forState:UIControlStateNormal];
        [self.memberLevelLabel setImage:[UIImage imageNamed:[NSString stringWithFormat:@"member_level_%@.png",[DataManager getInstance].user.memberLevel]] forState:UIControlStateNormal];
        
    }else {
        [self.memberLevelLabel setTitle:@"您还不是VIP会员" forState:UIControlStateNormal];
        [self.memberLevelLabel setImage:nil forState:UIControlStateNormal];
        
    }
    [self btnlxzxm];
}
///修改昵称和性别
-(void)btnlxzxm{
    if ([DataManager getInstance].user) {
        NSMutableDictionary* dic = [NSMutableDictionary new];
        dic[@"sex"]   = [DataManager getInstance].user.sex;
        [[ServerManger getInstance] editUserr:dic andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                
                if (code.intValue == 0) {
                    [DataManager getInstance].user = [UserVO mj_objectWithKeyValues:data[@"object"]];
                    [[DataManager getInstance] setLogin:[DataManager getInstance].user];
                    [self loadSubView];
                }
            }
            
        }];
    }
    
    
}
-(void)loadData{
    [[ServerManger getInstance] getMemberCenterInfo:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                self.model = [MemberCenterModel mj_objectWithKeyValues:data[@"object"]];
                [self loadSubView];

            }else{
                [self inputToast:msg];
            }
        }
    }];
    
}


-(void)loadSubView{
    
    self.memberItems = [NSMutableArray array];
    for (int i = 0; i < self.model.memberItems.count; i++) {
        MemberLevelModel *model = [MemberLevelModel mj_objectWithKeyValues:self.model.memberItems[i]];
        [self.memberItems addObject:model];
    }
    self.scrollViewHeight.constant = (SCREEN_WIDTH - 112) * 281.0 /488.0;
    self.selectModel = [self.memberItems firstObject];
    self.selectIndex = 0;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.memberItems.count; i++) {
        MemberLevelModel *model = [self.memberItems objectAtIndex:i];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake( self.scrollView.width * i, 0 , self.scrollView.width, (SCREEN_WIDTH - 112) * 281.0 /488.0)];
        imageView.backgroundColor = [UIColor whiteColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.backgroundImg] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"member_level_%d.png",i + 1]]];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.memberItems.count, (SCREEN_WIDTH - 112) * 281.0 /488.0);
    
    self.conditionLabel.attributedText = [[NSAttributedString alloc] initWithData:[self.selectModel.memberCondition dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.equityLabel.attributedText = [[NSAttributedString alloc] initWithData:[self.selectModel.memberRights dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];


    
    [self.topView addShadowWithRadius:5];
    
    if ([DataManager getInstance].user.avatar.length >3) {
        [self.iconImageView sd_setImageWithURL: [NSURL URLWithString:[DataManager getInstance].user.avatar]];
    }
    
    if ([DataManager getInstance].user.nickName.length > 0) {
        self.nameLabel.text = [DataManager getInstance].user.nickName;
    }else{
        self.nameLabel.text = [DataManager getInstance].user.loginName;
        
    }
    [self reloadHeaderView];
    
}
-(void)reloadHeaderView{
    if ([DataManager getInstance].user.memberLevel.intValue > 0) {
        [self.bottomOpenButton setTitle:@"立刻升级会员" forState:UIControlStateNormal];
        self.usableTimesLabel.hidden = NO;
        self.usableTimesLabel.text = [NSString stringWithFormat:@"会员折扣剩余%@次",self.model.curAvailableTimes];
        
    }else{
        self.usableTimesLabel.hidden = YES;
        [self.bottomOpenButton setTitle:@"立刻开通会员" forState:UIControlStateNormal];

    }
    if ([DataManager getInstance].user.memberLevel.intValue > 0) {
        [self.memberLevelLabel setTitle:@"" forState:UIControlStateNormal];
        [self.memberLevelLabel setImage:[UIImage imageNamed:[NSString stringWithFormat:@"member_level_%@.png",[DataManager getInstance].user.memberLevel]] forState:UIControlStateNormal];
        
    }else {
        [self.memberLevelLabel setTitle:@"您还不是VIP会员" forState:UIControlStateNormal];
        [self.memberLevelLabel setImage:nil forState:UIControlStateNormal];
        
    }

}

// 滚动停止时，触发该函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / self.scrollView.width;
    if (index < self.selectIndex) {
        self.selectIndex --;
    }
    if (index > self.selectIndex) {
        self.selectIndex ++;
    }
    self.selectIndex = scrollView.contentOffset.x / self.scrollView.width;
    
    
    [self reloadLevelInfo];
}



///充值
- (IBAction)rechargeAction:(UIButton *)sender {
    GHRechargeViewController *view = [GHViewControllerLoader GHRechargeViewController];
    [view updateLevelAction:^(BOOL result) {
        if (result) {
            [self loadData];
        }
    }];
    [self.navigationController pushViewController:view animated:YES];
}

///向左
- (IBAction)leftAction:(UIButton *)sender {
    [self.rightButton setImage:[UIImage imageNamed:@"member_center_right.png"] forState:UIControlStateNormal];
    
    if (self.selectIndex > 0) {
        self.selectIndex --;
        [self reloadLevelInfo];

    }
    
}

///向右
- (IBAction)rightAction:(UIButton *)sender {
    [self.leftButton setImage:[UIImage imageNamed:@"member_center_left_yes.png"] forState:UIControlStateNormal];

    if (self.selectIndex < self.memberItems.count - 1) {
        self.selectIndex ++;
        [self reloadLevelInfo];
    }
}

-(void)reloadLevelInfo{
    
    [self.rightButton setImage:[UIImage imageNamed:self.selectIndex < self.memberItems.count - 1 ? @"member_center_right.png" : @"member_center_right_no.png"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:self.selectIndex > 0 ? @"member_center_left_yes.png":@"member_center_left.png"] forState:UIControlStateNormal];

    [self.scrollView setContentOffset:CGPointMake(self.selectIndex * self.scrollView.width, 0)];
    self.selectModel = [self.memberItems objectAtIndex:self.selectIndex];
    self.conditionLabel.attributedText = [[NSAttributedString alloc] initWithData:[self.selectModel.memberCondition dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.equityLabel.attributedText = [[NSAttributedString alloc] initWithData:[self.selectModel.memberRights dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    
}



///等级说明
- (IBAction)ruleAction:(id)sender {
    HtmlAllViewController *controller = [[HtmlAllViewController alloc] init];
    controller.isTest = YES;
    controller.mUrl = [NSString stringWithFormat:@"%@?token=%@",self.model.docUrl,[DataManager getInstance].user.token];
    controller.mTitle = @"会员说明";
    [self.navigationController pushViewController:controller animated:YES];
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
