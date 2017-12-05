//
//  SeriousFlowViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/27.
//  Copyright © 2017年 pinjian. All rights reserved.
//
//*
#import "SeriousFlowViewController.h"
#import <WebKit/WebKit.h>
#define NAVIGATION_HEIGHT (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame))
@interface SeriousFlowViewController ()<UIWebViewDelegate>
@property (strong, nonatomic)  WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) BOOL canBack;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation SeriousFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重疾就医";
    
    [self setNavigationlefttItem];///重写返回按钮
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    
    
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.pjhealth.com.cn/wx/diseaseModel/diseaseIndex.html"]]];
    
    
    // Do any additional setup after loading the view.
}
-(void)setNavigationlefttItem{
    UIButton *inputCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inputCodeButton.frame = CGRectMake(0, 0, 30, 30);
    [inputCodeButton setBackgroundImage:[UIImage imageNamed:@"point_back.png"] forState:UIControlStateNormal];
    [inputCodeButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:inputCodeButton]];
    //    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}
-(void)backToHome{
    if (self.canBack) {
        [self loadWebView];
        self.canBack = NO;
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void)loadWebView{
    // 设置访问的URL
    NSURL *url = [NSURL URLWithString:@"http://www.pjhealth.com.cn/wx/diseaseModel/diseaseIndex.html"];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [self.web loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[[request URL] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([requestString containsString:@"disease_apply"] || [requestString containsString:@"disease_example"]) {
            self.canBack = YES;
        }
    
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.25f delay:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
        weakSelf.progressView.progress = 0.8;
    } completion:^(BOOL finished) {
//        weakSelf.progressView.hidden = YES;
        
    }];
}
///加载完成
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
        weakSelf.progressView.progress = 1;
    } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
        
    }];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.progressView.hidden = YES;
    [self inputToast:@"加载失败"];
}



-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (IBAction)createSeriousOrder:(id)sender {
    [self.navigationController pushViewController:[GHViewControllerLoader CreateSeriousOrderController] animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//*/

/*

 #import "SeriousFlowViewController.h"
 #import <WebKit/WebKit.h>
 #define NAVIGATION_HEIGHT (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame))
 @interface SeriousFlowViewController ()<WKNavigationDelegate,WKUIDelegate>
 @property (strong, nonatomic)  WKWebView *webView;
 @property (nonatomic, strong) UIProgressView *progressView;
 @property (nonatomic, assign) BOOL canBack;
 
 @property (weak, nonatomic) IBOutlet UIButton *bottomButton;

 @end
 
 @implementation SeriousFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重疾就医";
    
    [self setNavigationlefttItem];///重写返回按钮
    
    
    
    // 创建WKWebView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height - 55)];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    // 设置访问的URL
    NSURL *url = [NSURL URLWithString:@"http://www.pjhealth.com.cn/wx/diseaseModel/diseaseIndex.html"];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [self.webView loadRequest:request];
    // 将WKWebView添加到视图
    [self.view addSubview:self.webView];
    
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view bringSubviewToFront:self.bottomButton];
    
    // Do any additional setup after loading the view.
}

-(void)setNavigationlefttItem{
    UIButton *inputCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inputCodeButton.frame = CGRectMake(0, 0, 30, 30);
    [inputCodeButton setBackgroundImage:[UIImage imageNamed:@"point_back.png"] forState:UIControlStateNormal];
    [inputCodeButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:inputCodeButton]];
    //    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

-(void)backToHome{
    if (self.canBack) {
        [self loadWebView];
        self.canBack = NO;
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
 
-(void)loadWebView{
    // 设置访问的URL
    NSURL *url = [NSURL URLWithString:@"http://www.pjhealth.com.cn/wx/diseaseModel/diseaseIndex.html"];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [self.webView loadRequest:request];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[[request URL] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([requestString containsString:@"disease_apply"] || [requestString containsString:@"disease_example"]) {
        self.canBack = YES;
    }
    
    return YES;
}

 
 
 -(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
     if ([keyPath isEqualToString:@"estimatedProgress"]) {
         self.progressView.progress = self.webView.estimatedProgress;
         if (self.progressView.progress == 1) {
 
//              *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
//              *动画时长0.25s，延时0.3s后开始动画
//              *动画结束后将progressView隐藏
 
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];

        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }




}
// 类似 UIWebView的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if ([strRequest containsString:@"disease_apply"] || [strRequest containsString:@"disease_example"]) {
        self.canBack = YES;
    }
    decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
    NSLog(@"开始加载网页");
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    //self.progressView.hidden = YES;
}






-(void)dealloc{
    //    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}






- (IBAction)createSeriousOrder:(id)sender {
    [self.navigationController pushViewController:[GHViewControllerLoader CreateSeriousOrderController] animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/

@end
