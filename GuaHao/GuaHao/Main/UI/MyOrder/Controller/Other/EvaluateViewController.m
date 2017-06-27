//
//  EvaluateViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/20.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "EvaluateViewController.h"
#import "EvaluateSelectView.h"
@interface EvaluateViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *totalEvaluateView;
@property (weak, nonatomic) IBOutlet UIView *attitudeView;
@property (weak, nonatomic) IBOutlet UIView *qualityView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeHoldLabel;
@property (strong, nonatomic) NSArray *statusArr;
@property (copy, nonatomic) NSString *total;
@property (copy, nonatomic) NSString *quality;
@property (copy, nonatomic) NSString *attitude;
@property (copy, nonatomic) NSString *time;


@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.total = 0;self.quality = 0;self.attitude = 0;self.time = 0;
    self.statusArr = @[@"差",@"一般",@"好",@"很好",@"非常好"];
    __weak typeof(self) weakSelf = self;
    ///总体评分
    EvaluateSelectView *totalView = [[EvaluateSelectView alloc]initWithFrame:CGRectMake(0, 0, 185, 40) isSmile:NO];
    totalView.canClick = YES;
    [totalView butonClickAction:^(NSInteger index) {
        weakSelf.totalLabel.text = [weakSelf.statusArr objectAtIndex:index-1];;
        weakSelf.total = [NSString stringWithFormat:@"%ld",(long)index];
    }];
    [self.totalEvaluateView addSubview:totalView];
    
     ///态度评分
    EvaluateSelectView *attitudeView = [[EvaluateSelectView alloc]initWithFrame:CGRectMake(0, 0, 185, 40) isSmile:YES];
    attitudeView.canClick = YES;
    [attitudeView butonClickAction:^(NSInteger index) {
        weakSelf.attitudeLabel.text = [weakSelf.statusArr objectAtIndex:index-1];;
        weakSelf.attitude = [NSString stringWithFormat:@"%ld",(long)index];;
    }];
    [self.attitudeView addSubview:attitudeView];
     ///质量评分
    EvaluateSelectView *qualityView = [[EvaluateSelectView alloc]initWithFrame:CGRectMake(0, 0, 185, 40) isSmile:YES];
    qualityView.canClick = YES;
    [qualityView butonClickAction:^(NSInteger index) {
        weakSelf.qualityLabel.text = [weakSelf.statusArr objectAtIndex:index-1];;
        weakSelf.quality = [NSString stringWithFormat:@"%ld",(long)index];;
    }];
    [self.qualityView addSubview:qualityView];
     //时效评分
    EvaluateSelectView *timeView = [[EvaluateSelectView alloc]initWithFrame:CGRectMake(0, 0, 185, 40) isSmile:YES];
    timeView.canClick = YES;
    [timeView butonClickAction:^(NSInteger index) {
        weakSelf.timeLabel.text = [weakSelf.statusArr objectAtIndex:index -1];;
        weakSelf.time = [NSString stringWithFormat:@"%ld",(long)index];;
    }];
    [self.timeView addSubview:timeView];
    
    
    
    
    // Do any additional setup after loading the view.
}



-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        self.placeHoldLabel.hidden = NO;
    }
    NSLog(@"textView.text----%@",textView.text);
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeHoldLabel.hidden = YES;
}

- (IBAction)ruleAction:(id)sender {
    [self.view endEditing:YES];
    
    
}
- (IBAction)commitAction:(id)sender {
    [self.view endEditing:YES];
    if (self.total.intValue == 0) {
        [self inputToast:@"请选择总体评分"];
        return;
    }
    if (self.attitude.intValue == 0) {
        [self inputToast:@"请选择态度评分"];
        return;
    }
    if (self.quality.intValue == 0) {
        [self inputToast:@"请选择质量评分"];
        return;
    }
    if (self.time.intValue == 0) {
        [self inputToast:@"请选择时效评分"];
        return;
    }
    if (self.textView.text.length  < 1) {
        [self inputToast:@"请填写评价"];
        return;
    }
    
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] createEvaluate:@{@"totalEvaluation":self.total,@"orderType":self.orderType,@"timeEvaluation":self.time,@"qualityEvaluation":self.quality,@"timeEvaluation":self.time,@"mannerEvaluation":self.attitude,@"comment":self.textView.text.length > 0 ? self.textView.text:@"无"}  orderID:self._id andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
                evaluateOKVC._id = weakSelf._id;
                evaluateOKVC.orderType = weakSelf.orderType;
                evaluateOKVC.fromeEvaluateVC = YES;
                [weakSelf.navigationController pushViewController:evaluateOKVC animated:YES];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
    
    
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
