//
//  GHShareViewController.m
//  GuaHao
//
//  Created by PJYL on 16/10/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHShareViewController.h"
#import "GHShareModel.h"
#import "QRCodeGenerator.h"
#import "HtmlAllViewController.h"
#import "SelfCodeViewController.h"
@interface GHShareViewController (){
        GHShareModel * shareVO;
}
@property (weak, nonatomic) IBOutlet UILabel *InvitationcodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;
@property (weak, nonatomic) IBOutlet UIButton *footButton;

@end

@implementation GHShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"应用分享";
    [self getShare];
    
    [self setNavigationRightItem];
    // Do any additional setup after loading the view.
}

-(void) getShare{
    [[ServerManger getInstance] share:6 page:1 andCallback:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    shareVO  = [GHShareModel mj_objectWithKeyValues:data[@"object"]];
                    self.InvitationcodeLabel.text = shareVO.invitationCode;
                     NSString * url = [NSString stringWithFormat:@"%@?type=1;data=%@",[ServerManger getInstance].appDownloadURL,shareVO.invitationCode];
                     self.QRImageView.image = [QRCodeGenerator qrImageForString:url imageSize:200];
                    [self.footButton setTitle:shareVO.resultDesc forState:UIControlStateNormal];
                }
                
            }else{
                [self inputToast:msg];
            }
        }
    }];
}
- (IBAction)shareRuleAction:(id)sender {
    HtmlAllViewController *controller = [[HtmlAllViewController alloc] init];
    controller.mUrl = shareVO.docLink;
    controller.mTitle = @"活动规则";
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)shareToAction:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 1301) {
         NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKEnableUseClientShare];
        NSArray* imageArray = @[[UIImage imageNamed:@"commo_applyShare_2Bar.png"]];
        [shareParams SSDKSetupShareParamsByText:@"扫我赚钱，冲刺品简挂号达人榜！" images:imageArray url:[NSURL URLWithString:shareVO.appShareLink4Other] title:@"你是几级“分享控”？" type:(SSDKContentTypeAuto)];
        [ShareSDK share:SSDKPlatformTypeWechat parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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
    if (sender.view.tag == 1302) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKEnableUseClientShare];
        NSArray* imageArray = @[[UIImage imageNamed:@"commo_applyShare_2Bar.png"]];
        [shareParams SSDKSetupShareParamsByText:@"扫我赚钱，冲刺品简挂号达人榜！" images:imageArray url:[NSURL URLWithString:shareVO.appShareLink4Other] title:@"你是几级“分享控”？" type:(SSDKContentTypeAuto)];
        [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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
    if (sender.view.tag == 1303) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKEnableUseClientShare];
        NSArray* imageArray = @[[UIImage imageNamed:@"commo_applyShare_2Bar.png"]];
        [shareParams SSDKSetupShareParamsByText:@"扫我赚钱，冲刺品简挂号达人榜！" images:imageArray url:[NSURL URLWithString:shareVO.appShareLink4Other] title:@"你是几级“分享控”？" type:(SSDKContentTypeAuto)];
        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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
}
- (IBAction)discountcouponAction:(id)sender {
    HtmlAllViewController *controller = [[HtmlAllViewController alloc] init];
    controller.mUrl = shareVO.descLink;
    controller.mTitle = @"分享收入";
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)setNavigationRightItem{
    UIButton *inputCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inputCodeButton.frame = CGRectMake(0, 0, 60, 30);
    [inputCodeButton setBackgroundColor:GHDefaultColor];
    inputCodeButton.layer.cornerRadius = 5;
    inputCodeButton.layer.masksToBounds = YES;
    inputCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [inputCodeButton setTitle:@"邀请码" forState:UIControlStateNormal];
    [inputCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inputCodeButton addTarget:self action:@selector(inputWelcomeCode) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:inputCodeButton]];
    //    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}
-(void)inputWelcomeCode{
    SelfCodeViewController * view = [[SelfCodeViewController alloc] init];
    view.title = @"填写邀请码";
    [self.navigationController pushViewController:view animated:YES];
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
