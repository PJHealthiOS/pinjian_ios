//
//  PopAddNumberView.m
//  GuaHao
//
//  Created by 123456 on 16/6/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PopAddNumberView.h"

@interface PopAddNumberView ()
@property (weak, nonatomic) IBOutlet UIButton * cancelBtn;
@property (weak, nonatomic) IBOutlet UIView   * bagView;

@end

@implementation PopAddNumberView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"PopAddNumberView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _addNumberF.text = @"";
        [_addNumberF becomeFirstResponder];
        containerView.frame = newFrame;
        [self addSubview:containerView];
        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [_cancelBtn setUserInteractionEnabled:YES];
        [_cancelBtn addGestureRecognizer:tapGuesture1];
        UITapGestureRecognizer * tapGuesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func2:)];
        [_bagView setUserInteractionEnabled:YES];
        [_bagView addGestureRecognizer:tapGuesture2];
    }
    return self;
}
- (IBAction)onSure:(id)sender {
    if (_delegate) {
        [_delegate setPopAddNumberViewDelegate:0];
    }
}
-(void) func1:(UITapGestureRecognizer *) tap{
    _addNumberF.text = @"";
    [self removeFromSuperview];
}
-(void) func2:(UITapGestureRecognizer *) tap{
    [self endEditing:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


@end
