//
//  OrderSureView.m
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "OrderCancelView.h"

@interface OrderCancelView ()

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation OrderCancelView{
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"OrderCancelView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
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
        NSString * name = _btnCancel.titleLabel.text;
        [_delegate orderCancelDelegate:[name isEqualToString:@"直接取消"]?0:1];
    }
    [self removeFromSuperview];
}

- (IBAction)onLook:(id)sender {
    [self removeFromSuperview];
}

-(void) func1:(UITapGestureRecognizer *) tap{
    [self removeFromSuperview];
}

-(void)setTitles:(NSString*) title button:(NSString*) content
{
    _labName.text = title;
    [_btnCancel setTitle:content forState:UIControlStateNormal];
}

@end
