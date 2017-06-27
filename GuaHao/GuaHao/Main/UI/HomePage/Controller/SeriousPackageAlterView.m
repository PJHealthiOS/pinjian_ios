//
//  SeriousPackageAlterView.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/3.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousPackageAlterView.h"
@interface SeriousPackageAlterView (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
@implementation SeriousPackageAlterView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"SeriousPackageAlterView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    }
    return self;
}
-(void)layoutSubviewWithVO:(PackageVO *)vo{
    self.titleLabel.text = [NSString stringWithFormat:@"%@内容", vo.title];
//    NSString * str = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", vo.content];
    NSString *newBacnStr = [vo.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_webView loadHTMLString:newBacnStr baseURL:nil];
    
}
-(void)selectImmediately:(SelctAction)action{
    self.MyAction = action;
}
- (IBAction)cancelAction:(UIButton *)sender {
    [self removeFromSuperview];
}
- (IBAction)selectAction:(id)sender {
    self.MyAction(YES);
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
