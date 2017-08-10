//
//  OrderSureView.m
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "AuthenticationView.h"

@interface AuthenticationView ()

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation AuthenticationView{
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"AuthenticationView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
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
    if (_delegate) {
        [_delegate authenticationDelegate:0];
    }
}

- (IBAction)onLook:(id)sender {
    if (_delegate) {
        [_delegate authenticationDelegate:1];
    }
}

-(void) func1:(UITapGestureRecognizer *) tap{
    
}

@end
