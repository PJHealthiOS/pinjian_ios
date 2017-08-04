//
//  EvaluateOKViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/21.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "EvaluateOKViewController.h"
#import "EvaluateSelectView.h"
#import "EvaluateModel.h"
#import "EvaluateAlterView.h"
#import "HtmlAllViewController.h"
@interface EvaluateOKViewController (){
}
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UIView *attitudeView;
@property (weak, nonatomic) IBOutlet UIView *qualityView;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeight;
@property (strong, nonatomic) NSArray *statusArr;
@property (strong, nonatomic) EvaluateSelectView *totalEvaluateView;
@property (strong, nonatomic) EvaluateSelectView *attitudeEvaluateView;
@property (strong, nonatomic) EvaluateSelectView *qualityEvaluateView;
@property (strong, nonatomic) EvaluateSelectView *timeEvaluateView;
@property (strong, nonatomic) EvaluateModel *orderVO;
@end

@implementation EvaluateOKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    [self getData];
    self.statusArr = @[@"差",@"一般",@"好",@"很好",@"非常好"];
    ///总体评分
    self.totalEvaluateView = [[EvaluateSelectView alloc]initWithFrame:CGRectMake(0, 0, 185, 40) isSmile:NO];
    [self.totalView addSubview:self.totalEvaluateView];
    
    
    ///态度评分
    self.attitudeEvaluateView = [[EvaluateSelectView alloc]initWithFrame:CGRectMake(0, 0, 185, 40) isSmile:YES];
    [self.attitudeView addSubview:self.attitudeEvaluateView];
   
    
    ///质量评分
    self.qualityEvaluateView = [[EvaluateSelectView alloc]initWithFrame:CGRectMake(0, 0, 185, 40) isSmile:YES];
    [self.qualityView addSubview:self.qualityEvaluateView];
    
    
    //时效评分
    self.timeEvaluateView = [[EvaluateSelectView alloc]initWithFrame:CGRectMake(0, 0, 185, 40) isSmile:YES];
    [self.timeView addSubview:self.timeEvaluateView];
    
    // Do any additional setup after loading the view.
}
-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getEvaluate:@{@"orderType":self.orderType}  orderID:self._id andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                _orderVO = [EvaluateModel mj_objectWithKeyValues:data[@"object"]];
                [weakSelf laySubview];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}
-(void)laySubview{
    if (self.fromeEvaluateVC) {
        EvaluateAlterView *alter = [[EvaluateAlterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
        __weak typeof(self) weakSelf = self;
        [alter clickShopAction:^(BOOL result) {
            [alter removeFromSuperview];
            HtmlAllViewController *htmlVC = [[HtmlAllViewController alloc]init];
            htmlVC.mTitle = @"挂号豆商城";
            htmlVC.mUrl   = @"http://www.pjhealth.com.cn/wx/ExchangeMall/ExchangeMall.html";
            [weakSelf.navigationController pushViewController:htmlVC animated:YES];
        }];
        [self.view addSubview:alter];
    }
    self.remarkLabel.text = _orderVO.comment;
    self.remarkHeight.constant = ([self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 0) str: _orderVO.comment.length == 0 ? @"无" : _orderVO.comment fount:15].height)+20;

    self.totalLabel.text = [self.statusArr objectAtIndex:_orderVO.totalEvaluation.intValue-1];
    self.qualityLabel.text = [self.statusArr objectAtIndex:_orderVO.qualityEvaluation.intValue-1];
    self.attitudeLabel.text = [self.statusArr objectAtIndex:_orderVO.mannerEvaluation.intValue-1];
    self.timeLabel.text = [self.statusArr objectAtIndex:_orderVO.timeEvaluation.intValue -1];

    [self.totalEvaluateView updateCell:_orderVO.totalEvaluation.intValue canClick:NO];
    [self.attitudeEvaluateView updateCell:_orderVO.mannerEvaluation.intValue canClick:NO];
    [self.qualityEvaluateView updateCell:_orderVO.qualityEvaluation.intValue canClick:NO];
    [self.timeEvaluateView updateCell:_orderVO.timeEvaluation.intValue canClick:NO];
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
-(BOOL) navigationShouldPopOnBackButton ///在这个方法里写返回按钮的事件处理
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (self.fromeEvaluateVC) {
        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count - 3] animated:YES];

    }else{
        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count - 2] animated:YES];
    }

    return YES;//返回NO 不会执行
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
