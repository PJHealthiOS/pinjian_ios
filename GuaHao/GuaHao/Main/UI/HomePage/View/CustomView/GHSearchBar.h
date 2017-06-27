//
//  GHSearchBar.h
//  GuaHao
//
//  Created by PJYL on 16/9/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHSearchBar : UISearchBar<UITextFieldDelegate>
{
    BOOL imageHasSet;
}
/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
@property (nonatomic, assign, setter = setHasCentredPlaceholder:) BOOL hasCentredPlaceholder;
- (void)setCancelButtonTitle:(NSString *)title setPlaceholder:(NSString *)placeholder;
@property (nonatomic, assign) BOOL isHome;
- (id)initWithFrame:(CGRect)frame isHome:(BOOL)ishome;

@end
