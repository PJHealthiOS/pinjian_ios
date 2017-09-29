//
//  ExpertInfomationViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/11/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertInfomationViewController.h"
#import "ExpertDayCell.h"
#import "CreateOrderExpertViewController.h"
#import "HtmlAllViewController.h"
#import "ExpertOrderDiscountAlterView.h"
@interface ExpertInfomationViewController (){
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

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *first_discount_label;
@property (weak, nonatomic) IBOutlet UILabel *second_discount_label;


@end

@implementation ExpertInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"医生信息";
    [self getData];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]getExpDoctor:self.doctorId andCallback:^(id data) {
        [self.view hideToastActivity];
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
- (IBAction)remarkAction:(UIButton *)sender {
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
        [[ServerManger getInstance] follow:self.doctorId andCallback:^(id data) {
            __weak typeof(self) weakSelf = self;
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


-(void)reloadPage{
    
    self.doctorNameLbael.text = expertVO.name;
    self.pospositionLabel.text = [NSString stringWithFormat:@"%@   %@" ,expertVO.departmentName,expertVO.title];
    self.amountLabel.text = [NSString stringWithFormat:@"预约量%@",expertVO.outpatientCount];
    self.hospitalLabel.text = expertVO.hospitalName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:expertVO.avatar] placeholderImage:[UIImage imageNamed:@"order_expert_desc_icon_bgImage.png"]];
    
    self.goodDescLabel.text = expertVO.expert;
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@-%@",expertVO.departmentName,expertVO.hospitalName];

    self.experienceLabel.text = expertVO.resume;
    
    self.firstLabel.text = [[expertVO.discountRules objectAtIndex:0]objectForKey:@"desc"];
    self.secondLabel.text = [[expertVO.discountRules objectAtIndex:1]objectForKey:@"desc"];

    NSNumber *firstDiscountStr = [[expertVO.discountRules objectAtIndex:0]objectForKey:@"value"];
    NSNumber *secondDiscountStr = [[expertVO.discountRules objectAtIndex:1]objectForKey:@"value"];
    self.first_discount_label.text =[NSString stringWithFormat:@"陪诊费%.1f折",firstDiscountStr.floatValue * 10];
    self.second_discount_label.text = [NSString stringWithFormat:@"陪诊费%.1f折",secondDiscountStr.floatValue * 10];

    [self changeLabel:self.first_discount_label withTextColor:UIColorFromRGB(0x45c768)];
    [self changeLabel:self.second_discount_label withTextColor:UIColorFromRGB(0x45c768)];

}

- (void)changeLabel:(UILabel *)label withTextColor:(UIColor *)color {
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"."];
    NSString *content = label.text;
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(i, 1)];
        }
        
    }
    //完成查找数字，最后将带有字体下划线的字符串显示在UILabel上
    label.attributedText = attributeString;
    
    
}
-(void)reloadListView{
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
        LoginViewController * vc = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    
    
    
    NSInteger result = [self getDifferenceByDate:vo.scheduleDate];
    if (result < 14) {
        ///弹框
        ExpertOrderDiscountAlterView * alter = [[ExpertOrderDiscountAlterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [alter clickAction:^(BOOL result) {
            if (result) {
                CreateOrderExpertViewController * createVC = [GHViewControllerLoader CreateOrderExpertViewController];
                createVC.dayVO = vo;
                createVC.expertVO = expertVO;
                [self.navigationController pushViewController:createVC animated:YES];

            }else{
                //不作处理
            }
        }];
        [self.view addSubview:alter];
        
        
    }else{
        CreateOrderExpertViewController * createVC = [GHViewControllerLoader CreateOrderExpertViewController];
        createVC.dayVO = vo;
        createVC.expertVO = expertVO;
        [self.navigationController pushViewController:createVC animated:YES];
    }
}
- (NSInteger)getDifferenceByDate:(NSString *)date {
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate = [dateFormatter dateFromString:date];
    
    //获得当前时间
    NSDate *now = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:now  toDate:newDate  options:0];
    NSInteger result = [comps day] + 0;
    return result;
}



- (IBAction)discountRuleAction:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"折扣说明";
    view.mUrl   = expertVO.discountRuleDoc;
    [self.navigationController pushViewController:view animated:YES];
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
