//
//  OrderSureView.m
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "HosAuthenticationView.h"

@interface HosAuthenticationView ()

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HosAuthenticationView{
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"HosAuthenticationView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [_bgView setUserInteractionEnabled:YES];
        [_bgView addGestureRecognizer:tapGuesture1];
        
    }
    return self;
}

- (IBAction)onSure:(id)sender {
    if(_blockAuthentication){
        _blockAuthentication(1);
    }
    [self removeFromSuperview];
}

- (IBAction)onLook:(id)sender {
    if(_blockAuthentication){
        _blockAuthentication(0);
    }
    [self removeFromSuperview];
}

-(void)setTitle
{
    _labName.text = [NSString stringWithFormat:@"您好，%@ !%@需要上传您的身份证照片!",_patient.name,_hosName];
}

-(void) func1:(UITapGestureRecognizer *) tap{
    
}

@end
