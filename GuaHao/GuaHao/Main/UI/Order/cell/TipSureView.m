//
//  OrderSureView.m
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "TipSureView.h"
#import "Validator.h"
#import <Toast/UIView+Toast.h>
#import "UIViewBorders.h"
#import "ServerManger.h"
#import "EditorInformationVC.h"
#import "Utils.h"

@interface TipSureView ()<EditorInformationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *labCode;
@property (weak, nonatomic) IBOutlet UILabel *labName;

@end

@implementation TipSureView{
    __strong NSTimer *timer;
    int secondes;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"TipSureView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

- (IBAction)onSure:(id)sender {
    EditorInformationVC * view = [[EditorInformationVC alloc]init];
    view.delegate = self;
    view.patientVO = _patient;
    UIViewController* root = [Utils topViewController:nil];
    [root.navigationController pushViewController:view animated:YES];
}

-(void)editorInformationDelegate
{
    if (_delegate) {
        [_delegate tipSureDelegate:NO];
    }
    [self removeFromSuperview];
}

-(void)setNames:(NSString*)name
{
    _labName.text = [NSString stringWithFormat:@"%@,您好",name];
}

- (IBAction)onClose:(id)sender {
    if (_delegate) {
        [_delegate tipSureDelegate:NO];
    }
    [self removeFromSuperview];
}

@end
