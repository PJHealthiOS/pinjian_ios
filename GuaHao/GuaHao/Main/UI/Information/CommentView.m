//
//  CommentView.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/13.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "CommentView.h"

@interface CommentView ()<UITextViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholdLabel;
@end
@implementation CommentView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"CommentView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        CGRect fr = frame;
        fr.origin.y = 0;
        fr.size.width = SCREEN_WIDTH;
        [self setFrame:fr];
        self.textView.delegate = self;
        [self.textView becomeFirstResponder];
    }return self;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length >0) {
        self.placeholdLabel.hidden = YES;
    }else{
        self.placeholdLabel.hidden = NO;
    }
}


- (IBAction)cancelAction:(id)sender {
    [self.textView resignFirstResponder];
    [self removeFromSuperview];
}

- (IBAction)sendAction:(id)sender {
    self.myBlock(self.textView.text);
    [self.textView resignFirstResponder];
    [self removeFromSuperview];
}
-(void)sendCommentMessage:(SendCommentBlock)block{
    self.myBlock = block;
}











/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
