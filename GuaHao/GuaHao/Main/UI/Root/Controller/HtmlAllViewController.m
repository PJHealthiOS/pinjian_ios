//
//  HtmlAllViewController.m
//  Pinjian
//
//  Created by qiye on 15/11/24.
//  Copyright © 2015年 fangxiang. All rights reserved.
//

#import "HtmlAllViewController.h"
#import "HealthTestListViewController.h"
#import "GHViewControllerLoader.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface HtmlAllViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation HtmlAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _mTitle;
    NSString *mUrl = @"";
    if (self.withoutToken) {
        mUrl   = self.mUrl;

    }else{
        mUrl   = [NSString stringWithFormat:@"%@?token=%@",self.mUrl,[DataManager getInstance].user.token] ;
    }

    self.webView.delegate = self;
    NSURL *url = [[NSURL alloc]initWithString:mUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    if (self.isTest) {
        UIBarButtonItem *left = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"information_share.png"] highImage:[UIImage imageNamed:@"information_share.png"] target:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = left;
    }
    
}
-(void)shareClick{
    NSLog(@"share click");
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"commo_applyShare_2Bar.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://list.image.baidu.com/t/yingshi.jpg"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"想了解更多信息，请下载品简挂号！"
                                         images:imageArray
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",self.mUrl,[DataManager getInstance].user.token]]
                                          title:_mTitle
                                           type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"详情点击：%@",[NSString stringWithFormat:@"%@?token=%@",self.mUrl,[DataManager getInstance].user.token]] title:_mTitle image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",self.mUrl,[DataManager getInstance].user.token]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
        
        //        [shareParams SSDKSetupQQParamsByText:@"想了解更多信息，请下载品简挂号！" title:_dataSource.title url:[NSURL URLWithString:_dataSource.linkUrl] thumbImage:imageArray image:imageArray type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
        //
        //        [shareParams SSDKSetupQQParamsByText:@"想了解更多信息，请下载品简挂号！" title:_dataSource.title url:[NSURL URLWithString:_dataSource.linkUrl] thumbImage:imageArray image:imageArray type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[[request URL] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"requestString : %@",requestString);
    if ([requestString hasSuffix:@"healthTestListPage"]) {///更多测试
        [self healthTestListPage];
        return NO;
    }
    if ([requestString hasSuffix:@"normalOrder"]) {///普通号
        self.myAction(@"normalOrder");
        return NO;
    }
    if ([requestString hasSuffix:@"expertOrder"]) {//专家号
        self.myAction(@"expertOrder");
        return NO;
    }
    if ([requestString hasSuffix:@"seriousOrder"]) {///重疾
        self.myAction(@"seriousOrder");
        return NO;
    }
    if ([requestString hasSuffix:@"accompanyOrder"]) {///陪诊
        self.myAction(@"accompanyOrder");
        return NO;
    }
    if ([requestString hasSuffix:@"healthOrder"]) {///健康管理
        self.myAction(@"healthOrder");
        return NO;
    }
    if ([requestString hasSuffix:@"specialOrder"]) {///特色科室
        self.myAction(@"specialOrder");
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setURL:(NSString*)_url title:(NSString*)_title
{
    _titleLab.text = _mTitle;
    NSURL *url = [[NSURL alloc]initWithString:_url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)onBack:(id)sender {
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)clickToPage:( ClickToSomePageAction )action{
    self.myAction = action;
}
-(void)healthTestListPage{
    
    [self.navigationController pushViewController:[GHViewControllerLoader HealthTestListViewController] animated:YES];
}
@end
