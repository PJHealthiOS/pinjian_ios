//
//  FeedbackViewController.m
//  GuaHao
//
//  Created by PJYL on 2018/3/6.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *againTrueButton;
@property (weak, nonatomic) IBOutlet UIButton *againFalseButton;


@property (weak, nonatomic) IBOutlet UIButton *needOperationTrueBUtton;
@property (weak, nonatomic) IBOutlet UIButton *needOperationFalseButton;

@property (weak, nonatomic) IBOutlet UIButton *wayFriendButon;
@property (weak, nonatomic) IBOutlet UIButton *wayAdvertisementButton;
@property (weak, nonatomic) IBOutlet UIButton *wayAccidentBUtton;
@property (weak, nonatomic) IBOutlet UIButton *wayOtherButton;


@property (weak, nonatomic) IBOutlet UIButton *suggestNoneButton;
@property (weak, nonatomic) IBOutlet UIButton *suggestExpensiveButton;
@property (weak, nonatomic) IBOutlet UIButton *suggestProductBadButton;
@property (weak, nonatomic) IBOutlet UIButton *suggestTimeBadButton;
@property (weak, nonatomic) IBOutlet UIButton *suggestOtherBUuton;

@property (weak, nonatomic) IBOutlet UITextField *suggestTextField;






@property (copy, nonatomic) NSString *againStr;
@property (copy, nonatomic) NSString *operationStr;
@property (copy, nonatomic) NSString *wayStr;
@property (copy, nonatomic) NSString *suggestStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;



@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息反馈";
    self.bottomViewHeight.constant = 280;

    // Do any additional setup after loading the view.
}

- (IBAction)againTrueAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.againFalseButton.selected = NO;
    self.againStr = sender.selected ? @"是" : @"";
    
}

- (IBAction)againFalseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.againTrueButton.selected = NO;
    self.againStr = sender.selected ? @"否":@"";
}


- (IBAction)needOperationTrueAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.needOperationFalseButton.selected = NO;
    self.operationStr = sender.selected ? @"是" : @"";
}

- (IBAction)needOperationFalseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.needOperationTrueBUtton.selected = NO;
    self.operationStr = sender.selected ? @"否":@"";
}


- (IBAction)wayAction:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected) {
        self.wayStr = sender.currentTitle;
    }else{
        self.wayStr = @"";
    }
    self.wayFriendButon.selected = ([sender isEqual:self.wayFriendButon] && sender.selected)  ;
    self.wayAdvertisementButton.selected = ([sender isEqual:self.wayAdvertisementButton] && sender.selected)  ;
    self.wayAccidentBUtton.selected = ([sender isEqual:self.wayAccidentBUtton] && sender.selected)  ;
    self.wayOtherButton.selected = ([sender isEqual:self.wayOtherButton] && sender.selected)  ;
    
    
}

- (IBAction)suggestAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.suggestStr = sender.currentTitle;
    }else{
        self.suggestStr = @"";
    }
    
    self.suggestNoneButton.selected = ([sender isEqual:self.suggestNoneButton] && sender.selected)  ;
    self.suggestExpensiveButton.selected = ([sender isEqual:self.suggestExpensiveButton] && sender.selected)  ;
    self.suggestProductBadButton.selected = ([sender isEqual:self.suggestProductBadButton] && sender.selected)  ;
    self.suggestTimeBadButton.selected = ([sender isEqual:self.suggestTimeBadButton] && sender.selected)  ;
    self.suggestOtherBUuton.selected = ([sender isEqual:self.suggestOtherBUuton] && sender.selected)  ;


    self.suggestTextField.hidden = YES;
    self.bottomViewHeight.constant = 280;
    if ([sender isEqual:self.suggestOtherBUuton]) {
        self.suggestTextField.hidden = !sender.selected;
        self.bottomViewHeight.constant = sender.selected ? 350 :280;
    }
    
}









- (IBAction)submitAction:(id)sender {
    [self.suggestTextField resignFirstResponder];
    if (self.againStr.length < 1) {
         [self inputToast:@"请选择是否再次复诊"];return;
    }
    if (self.operationStr.length < 1) {
        [self inputToast:@"请选择是否需要手术"];return;
    }
    if (self.wayStr.length < 1) {
        [self inputToast:@"请选择获取途径"];return;
    }
    if (self.suggestStr.length < 1) {
        [self inputToast:@"请选择或输入建议"];return;
    }
    if (self.suggestTextField.text.length > 0) {
        self.suggestStr = self.suggestTextField.text;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[self.againStr isEqualToString:@"是"]?@"1":@"0" forKey:@"needFurtherConsultation"];
    [dic setObject:[self.operationStr isEqualToString:@"是"]?@"1":@"0" forKey:@"needSurgery"];
    [dic setObject:self.wayStr forKey:@"channel"];
    [dic setObject:self.suggestStr forKey:@"comments"];
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] expertEndFeedBack:dic orderID:self.orderID andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                if (self.myAction) {
                    self.myAction(YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
            }
        }
    }];
    
    
}

-(void)feedBackSuccess:(FeedBackAction)action{
    self.myAction = action;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.suggestTextField resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.suggestTextField resignFirstResponder];
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
