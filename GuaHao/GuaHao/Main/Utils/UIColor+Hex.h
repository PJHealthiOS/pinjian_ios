//
//  UIColor+Hex.h
//  Calvin
//
//  Created by Kevin Wu on 11/30/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR_LINE  0xFFE6E6E6L

@interface UIColor (Hex)

+(UIColor *) colorWithHex:(long long) hex;

+(UIColor *)generateUIColorByHexString:(NSString *)hexString;

+(UIColor *)generateUIColorByHexString:(NSString *)hexString withAlpha:(float) alpha;

@end
