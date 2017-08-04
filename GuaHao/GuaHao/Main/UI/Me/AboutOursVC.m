
//
//  AboutOursVC.m
//  GuaHao
//
//  Created by 123456 on 16/3/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//


#import "Utils.h"
#import "AboutOursVC.h"
#import <QuartzCore/QuartzCore.h>
#import "HtmlAllViewController.h"
#import "ServerManger.h"
@interface AboutOursVC ()
@property (weak, nonatomic) IBOutlet UITextView   * textView;
@property (weak, nonatomic) IBOutlet UIScrollView * contView;
@property (weak, nonatomic) IBOutlet UILabel      * VersionNumberLab;
@property (weak, nonatomic) IBOutlet UILabel      * lastLable;
@end

@implementation AboutOursVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    _textView.layer.borderColor = [UIColor colorWithRed:190.0f/255.0f green:190.0f /255.0f blue:190.0f/255.0f alpha:1.0f].CGColor;
    _textView.layer.borderWidth = 1;
    
    if (IS_IPHONE_6P) {
        _textView.frame = CGRectMake(67, _textView.frame.origin.y+12, 240, 310);
    }
    if (IS_IPHONE_5) {
        _textView.frame = CGRectMake(29, _textView.frame.origin.y-5, 320, 333);
    }
    if (IS_IPHONE_4_OR_LESS) {
        _textView.frame = CGRectMake(20, _textView.frame.origin.y-10, 340, 310);
    }
    self.VersionNumberLab.text = [NSString stringWithFormat:@"版本号 %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _contView.contentSize = CGSizeMake(0, CGRectGetMaxY(_lastLable.frame)+50);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)onPhone:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001150958"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRule:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"“品简挂号”用户协议";
    view.mUrl   = [NSString stringWithFormat:@"%@htmldoc/userAgreement.html",[ServerManger getInstance].serverURL];
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
