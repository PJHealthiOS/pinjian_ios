//
//  GHOrderTypeChooseController.m
//  GuaHao
//
//  Created by qiye on 16/9/9.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHOrderTypeChooseController.h"
#import "Utils.h"
#import "VisitTypeModel.h"
@interface GHOrderTypeChooseController (){
    VisitTypeModel *top_vo;
    VisitTypeModel *bottom_vo;
}
@property (weak, nonatomic) IBOutlet UILabel *top_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *top_desclabel;
@property (weak, nonatomic) IBOutlet UIButton *top_ruleButton;


@property (weak, nonatomic) IBOutlet UILabel *bottom_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottom_descLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottom_ruleButton;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *labTopDesc;
@property (weak, nonatomic) IBOutlet UILabel *labBottomDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnTop;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@end

@implementation GHOrderTypeChooseController{
    BOOL oneMore;
    BOOL twoMore;
    NSString * str1;
    NSString * str2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.title = @"挂号方式";
    oneMore = twoMore = NO;
    str1 = @"预约号规则：\n1.面向所有患者，品简预约不收取任何费用。预约可使用社保卡，自费就诊卡，用户到达医院后直接到挂号窗口凭有效证件（身份证、护照或军官证）挂号。\n2.取消预约：因故无法就诊，患者必须至少提前1天，通过电话400-115-0958取消预约。预约时请预留有效的电话号码，专家停诊时将以电话或短信的方式通知您。事先未取消预约又未按时就诊的患者视为爽约。年内累计三次爽约的患者将被列入违约名单，180天内不能在品简挂号APP内预约挂号。";
    str2 = @"挂号规则：\n挂号仅可使用自费就诊卡，就诊当天请在指定时间内到医院，凭就诊人的有效身份证件原件和相关就诊卡直接联系品简专员。";
    
    if (self.openStatus.intValue == 0) {
        self.topImageView.image = [UIImage imageNamed:@"order_choose_top.png"];
        self.bottomImageView.image = [UIImage imageNamed:@"order_choose_bottom.png"];
    }else{
        if (self.openStatus.intValue == 3) {
            self.topImageView.image = [UIImage imageNamed:@"order_choose_top.png"];
        }
        if (self.openStatus.intValue == 2) {
            self.bottomImageView.image = [UIImage imageNamed:@"order_choose_bottom.png"];
        }
    }
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap1:)];
    [_bottomView setUserInteractionEnabled:YES];
    [_bottomView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap2:)];
    [_topView setUserInteractionEnabled:YES];
    [_topView addGestureRecognizer:tap2];
}
-(void)getData{
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getVisitTypePageDataCallback:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                NSArray *arr = data[@"object"];
                top_vo = [VisitTypeModel mj_objectWithKeyValues:[arr objectAtIndex:0]];
                bottom_vo = [VisitTypeModel mj_objectWithKeyValues:[arr objectAtIndex:1]];
                [self lay];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}
-(void)lay{
    
    _top_titleLabel.text = top_vo.name;
    _top_desclabel.text = top_vo.desc;
    [_btnTop setTitle:top_vo.docName forState:UIControlStateNormal];
    str2 = top_vo.content;
    
    _bottom_titleLabel.text = bottom_vo.name;
    _bottom_descLabel.text = bottom_vo.desc;
    [_btnBottom setTitle:bottom_vo.docName forState:UIControlStateNormal];
    str1 = bottom_vo.content;
    
    
    
    
}
- (void)onTap1:(UITapGestureRecognizer*)tap{
    if (self.openStatus.intValue == 0 || self.openStatus.intValue == 2) {
        [self inputToast:@"该科室预约暂未开放"];
        return;
    }
    if(_myBlock){
        _myBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTap2:(UITapGestureRecognizer*)tap{
    if (self.openStatus.intValue == 0 || self.openStatus.intValue == 3) {
        [self inputToast:@"该科室挂号暂未开放"];
        return;
    }
    if(_myBlock){
        _myBlock(NO);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self caculate];
}


- (IBAction)onMore:(id)sender {
    oneMore = !oneMore;
    [self caculate];
}

- (IBAction)onMore2:(id)sender {
    twoMore = !twoMore;
    [self caculate];
}

-(void)caculate
{
    if(oneMore){
        _labTopDesc.numberOfLines = 0;
        _labTopDesc.text = str2;
        UIFont * tfont = [UIFont systemFontOfSize:13];
        CGSize textSize = [str2 boundingRectWithSize:CGSizeMake(_topView.width - 48, 600) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil] context:nil].size;

        _heightTopView.constant = 142 + ceil(textSize.height) + 5;
        _heightLabelTop.constant = ceil(textSize.height);

    }else{
        _labTopDesc.text = @"";

        _heightTopView.constant = 142;
        _heightLabelTop.constant = 20;
    }
    _bottomView.y = _topView.y + _topView.height + 16;
    
    if(twoMore){
        _labBottomDesc.numberOfLines = 0;
        _labBottomDesc.text = str1;
        UIFont * tfont = [UIFont systemFontOfSize:13];
        CGSize textSize = [str1 boundingRectWithSize:CGSizeMake(_bottomView.width - 48, 600) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil] context:nil].size;
        
        _heightBottomView.constant = 142 + ceil(textSize.height) + 5;
        _heightBottomLabel.constant = ceil(textSize.height);

    }else{
        _labBottomDesc.text = @"";
        _heightBottomView.constant = 142;
        _heightBottomLabel.constant = 20;
    }
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomView.frame)+47);
}

@end
