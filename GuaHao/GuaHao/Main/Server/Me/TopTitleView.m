//
//  TopTitleView.m
//  GuaHao
//
//  Created by 123456 on 16/6/27.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "TopTitleView.h"

@interface TopTitleView (){
    
    __weak IBOutlet UIButton * cancelBtn;
}

@end

@implementation TopTitleView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"TopTitleView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [cancelBtn setUserInteractionEnabled:YES];
        [cancelBtn addGestureRecognizer:tapGuesture1];
    }

    return self;
}
- (IBAction)onSure:(id)sender {
    if (_delegate) {
        [_delegate setTopTitleViewDelegate:0];
    }
}
-(void) func1:(UITapGestureRecognizer *) tap{
    [self removeFromSuperview];
}


@end
