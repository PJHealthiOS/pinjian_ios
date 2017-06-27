//
//  UILabel+DownTime.h
//  GuaHao
//
//  Created by qiye on 16/5/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DownTime)


-(void)startTime:(NSString*)txt second:(NSNumber*) second type:(NSNumber*) type;
- (void)stopTime;
@end
