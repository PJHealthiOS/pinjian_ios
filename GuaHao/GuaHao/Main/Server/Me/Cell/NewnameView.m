//
//  NewnameView.m
//  GuaHao
//
//  Created by 123456 on 16/5/28.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "NewnameView.h"
#import "UIViewController+Toast.h"
#import "Validator.h"
#import "ServerManger.h"
#import "DataManager.h"
#define MAX_STARWORDS_LENGTH 20
@interface NewnameView ()
@property (weak, nonatomic) IBOutlet UIView   * bgView;
@property (weak, nonatomic) IBOutlet UIButton * btnSure;
@property (weak, nonatomic) IBOutlet UITextField * tfName;
@property (weak, nonatomic) IBOutlet UILabel * labName;

@end

@implementation NewnameView{
    UserVO * UserV;
    int   type;
    UIImage *img;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"NewnameView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        type = 0;
        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [_bgView setUserInteractionEnabled:YES];
        [_bgView addGestureRecognizer:tapGuesture1];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextFieldTextDidChangeNotification" object:_tfName];
    }
    return self;
}
//** 键盘输入监听通知
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

-(void)setUser:(UserVO *)_UserV{

}
- (IBAction)onSure:(id)sender {
    if (_tfName.text.length == 0) {
        [self makeToast:@"请填写昵称！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    if (_tfName.text.length > 20) {
        [self makeToast:@"昵称的长度不能大于20～！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic[@"nickname"]   = _tfName.text;
    [self makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]editUserr:dic andCallback:^(id data) {
        [self hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            //            NSString * msg  = data[@"msg"];
            //            [self makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
            if(data[@"object"]){
                UserV  = [UserVO mj_objectWithKeyValues:data[@"object"]];
            }
            if (_delegate) {
                [_delegate informationDelegate:UserV];
            }
            if (code.intValue == 0) {
                [DataManager getInstance].user = [UserVO mj_objectWithKeyValues:data[@"object"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdate" object:nil];
                [self performSelector:@selector(func1:) withObject:nil afterDelay:1.0];
            }
        }

    }];
 
    
}

-(void) func1:(UITapGestureRecognizer *) tap{
    [self removeFromSuperview];
}
@end
