//
//  GHSearchBar.m
//  GuaHao
//
//  Created by PJYL on 16/9/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHSearchBar.h"

@implementation GHSearchBar

- (id)initWithFrame:(CGRect)frame isHome:(BOOL)ishome
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
        //设置背景图片
        if (ishome) {
            [self setBackgroundImage:[UIImage imageNamed:@"homepage_search_background"]];
        }else{
            [self setBackgroundImage:[UIImage imageNamed:@"homepage_search_background_black"]];
        }
        
        //设置背景色
        [self setBackgroundColor:[UIColor clearColor]];
        //设置文本框背景
        [self setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
        
        
        
        
        
        
        
        
        
        
        
        
        imageHasSet = NO;
        //        [self setSearchBarStyle:UISearchBarStyleMinimal];
//        self.layer.borderColor = [UIColor clearColor].CGColor;
//        self.layer.borderWidth = 0.5;
        
        [self setHasCentredPlaceholder:NO];
        [self setBarTintColor:[UIColor whiteColor]];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    }
    return self;
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
- (void)setCancelButtonTitle:(NSString *)title setPlaceholder:(NSString *)placeholder
{
    self.placeholder = placeholder;
    
    if ([UIDevice currentDevice].systemVersion.floatValue>7.0 ) {
        for(id cc in [self.subviews[0] subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        return;
    }
    for (UIView *searchbuttons in self.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cancelButton setTitle:title forState:UIControlStateNormal];
            break;
        }
    }
}
-(void)layoutSubviews{
    UITextField *textfiled;
    for (UIView *subView in self.subviews) {
        for (UIView* ssubview in subView.subviews) {
            
            if ([ssubview isKindOfClass:[UITextField class]]) {
                textfiled = (UITextField *)ssubview;
                break;
            }
            
        }
    }
    [super layoutSubviews];
    if (textfiled&&!textfiled.rightView) {
        if (self.isHome) {
            [textfiled setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        }else{
            [textfiled setValue:UIColorFromRGB(0xd1d1d1) forKeyPath:@"_placeholderLabel.textColor"];
        }
        
        
        [textfiled setValue:[UIFont systemFontOfSize:13 ] forKeyPath:@"_placeholderLabel.font"];
        textfiled.leftView = nil;
        UIImage*image = [UIImage imageNamed:@"homeage_search_left"];
        
        UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
        imageview.frame = CGRectMake(0, 0, 17, 17);
        textfiled.leftView = imageview;
        textfiled.leftViewMode = UITextFieldViewModeUnlessEditing;
        imageHasSet = YES;
        
    }
    
}
// ------------------------------------------------------------------------------------------
#pragma mark - Methods
// ------------------------------------------------------------------------------------------
- (void)setHasCentredPlaceholder:(BOOL)hasCentredPlaceholder
{
    _hasCentredPlaceholder = hasCentredPlaceholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector])
    {
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&_hasCentredPlaceholder atIndex:2];
        [invocation invoke];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        textField.rightViewMode = UITextFieldViewModeNever;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }else{
        textField.rightViewMode = UITextFieldViewModeUnlessEditing;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
