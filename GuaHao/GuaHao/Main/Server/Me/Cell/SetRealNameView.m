//
//  SetRealNameView.m
//  GuaHao
//
//  Created by 123456 on 16/6/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SetRealNameView.h"

@interface SetRealNameView ()
@property (weak, nonatomic) IBOutlet UIButton * bgView;
@property (weak, nonatomic) IBOutlet UIButton * sureBtn;

@end

@implementation SetRealNameView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"SetRealNameView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (IBAction)onLook:(id)sender {
    if (_delegate) {
        [_delegate setRealNameViewDelegate:1];
    }
}

- (IBAction)onSure:(id)sender {
    if (_delegate) {
        [_delegate setRealNameViewDelegate:0];
    }
}

@end
