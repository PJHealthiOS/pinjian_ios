//
//  NewAccompanyFlowerViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/7.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "NewAccompanyFlowerViewController.h"
#import "AccompanyFlowVO.h"
@interface NewAccompanyFlowerViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bananaImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *serviceDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (strong, nonatomic) AccompanyFlowVO *flowVO;
@end

@implementation NewAccompanyFlowerViewController
-(void)layoutSubviews{
    [self.bananaImageView sd_setImageWithURL:[NSURL URLWithString:self.flowVO.bannerUrl] placeholderImage:nil];
    self.imageHeight.constant = SCREEN_WIDTH *320.0 / 750.0;
    self.typeName.text = @"全程无忧";
    self.serviceDateLabel.text = self.flowVO.serviceTime;
    self.priceLabel.text = [NSString stringWithFormat:@"%@",self.flowVO.price];
    self.firstPriceLabel.text =[NSString stringWithFormat:@"  %@     ",self.flowVO.priceTag];
    NSURL *url = [[NSURL alloc]initWithString:self.flowVO.serviceNoticeUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.accompanyType == wholeAccompany) {
        self.title = @"全程陪诊";
    }else if (self.accompanyType == reportAccompany){
        self.title = @"代取报告";
    }else if (self.accompanyType == medicineAccompany){
       self.title = @"代取药品";
        
    }
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.userInteractionEnabled = YES;
    [self getData];
    
    // Do any additional setup after loading the view.
}
-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]getAccompanyFlowVCData:self.accompanyType andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data != [NSNull class] && data != nil) {
            NSNumber *code = data[@"code"];
            NSString *message = data[@"msg"];
            if (code.intValue == 0) {
                NSDictionary *dic = data[@"object"];
                weakSelf.flowVO = [AccompanyFlowVO mj_objectWithKeyValues:dic];
                [weakSelf layoutSubviews];
            }else{
                [weakSelf inputToast:message];
            }
        }
    }];
}

- (IBAction)createOrderAction:(id)sender {
    if (self.accompanyType == wholeAccompany) {
        NSLog(@"全程陪诊");
        AccompanyOrderViewController *normal = [GHViewControllerLoader AccompanyOrderViewController];
        [self.navigationController pushViewController:normal animated:YES];
    }else if (self.accompanyType == reportAccompany){
        [self.navigationController pushViewController:[GHViewControllerLoader AccompanyReportViewController] animated:YES];
        NSLog(@"报告陪诊");
    }else if (self.accompanyType == medicineAccompany){
        NSLog(@"取药陪诊");
        [self.navigationController pushViewController:[GHViewControllerLoader AccompanyMedicineViewController] animated:YES];
    }
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    _webViewHeight.constant = height +300;
    _backViewHeight.constant = _imageHeight.constant + 80 + _webViewHeight.constant ;
}

- (IBAction)callAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001150958"];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
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
