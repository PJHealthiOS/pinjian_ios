//
//  
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "WriteIDcardView.h"
#import "Validator.h"
#import "UIViewController+Toast.h"

@interface WriteIDcardView ()
@property (weak, nonatomic) IBOutlet UITextField *tfIdcard;
@end

@implementation WriteIDcardView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"WriteIDcardView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

- (IBAction)onSure:(id)sender {
    if (_tfIdcard.text.length==0&&_delegate) {
        [_delegate writeIDcardDelegate:@""];
        return;
    }
    if (![Validator isValidIdentityCard:_tfIdcard.text]) {
        [self makeToast:@"身份证格式不正确！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    [_delegate writeIDcardDelegate:_tfIdcard.text];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
@end
