//
//  PacketInfoViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/5/5.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "PacketInfoViewController.h"
@interface PacketInfoViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *alterView;

@end

@implementation PacketInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享赚红包";
    self.webView.delegate = self;
    NSString *mUrl   = @"https://www.pjhealth.com.cn/wx/banner/orderCpltCoupons/page4App.html" ;
    NSURL *url = [NSURL URLWithString:mUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.alterView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, SCREEN_HEIGHT);
    self.alterView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:self.alterView];
    // Do any additional setup after loading the view.
}
- (IBAction)leftButonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)shareAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.alterView.frame = CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)wxAction:(id)sender {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    NSArray* imageArray = @[[UIImage imageNamed:@"commo_applyShare_2Bar.png"]];
    [shareParams SSDKSetupShareParamsByText:@"去医院看病也能减免现金？快来品简挂号一起围观品简挂号！" images:imageArray url:[NSURL URLWithString:@"https://www.pjhealth.com.cn/wx/banner/orderCpltCoupons/page4Wx.html"] title:@"200000万就医现金狂撒啦！人人有份" type:(SSDKContentTypeAuto)];
    [ShareSDK share:SSDKPlatformTypeWechat parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alterView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH , SCREEN_HEIGHT);
        }];
        switch (state) {
               
            case SSDKResponseStateSuccess:
            {
                [self inputToast:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                [self inputToast:@"分享失败"];
                break;
            }
            default:
                break;
        }
        
    }];

}
- (IBAction)friendAction:(id)sender {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    NSArray* imageArray = @[[UIImage imageNamed:@"commo_applyShare_2Bar.png"]];
    [shareParams SSDKSetupShareParamsByText:@"去医院看病也能减免现金？快来品简挂号一起围观品简挂号!" images:imageArray url:[NSURL URLWithString:@"https://www.pjhealth.com.cn/wx/banner/orderCpltCoupons/page4Wx.html"] title:@"200000万就医现金狂撒啦！人人有份！" type:(SSDKContentTypeAuto)];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alterView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH , SCREEN_HEIGHT);
        }];
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [self inputToast:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                [self inputToast:@"分享失败"];
                break;
            }
            default:
                break;
        }
        
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.5 animations:^{
        self.alterView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH , SCREEN_HEIGHT);
    }];
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
