//
//  CALayer+UIColor.m
//  GuaHao
//
//  Created by 123456 on 16/8/3.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)
- (void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
