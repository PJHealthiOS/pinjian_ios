//
//  SpecialHTMLViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/7.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SpecialHTMLViewController.h"

@interface SpecialHTMLViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SpecialHTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self._title;
    NSString *mUrl   = [NSString stringWithFormat:@"%@?token=%@",self._url,[DataManager getInstance].user.token] ;
    NSURL *url = [NSURL URLWithString:mUrl];
    self.priceLabel.attributedText = self.content;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view from its nib.
}
-(void)setURL:(NSString*)_url title:(NSString*)_title content:(NSAttributedString *)content
{
    
}
- (IBAction)sureAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
