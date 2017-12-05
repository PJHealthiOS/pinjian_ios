//
//  UILabel+DownTime.m
//  GuaHao
//
//  Created by qiye on 16/5/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "UILabel+DownTime.h"
#import <objc/runtime.h>
#import "Utils.h"

@interface UILabel (DownTime)
/**
 *  要在Category中扩展的属性
 */
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString * txt;
@property (nonatomic, strong) NSNumber * seconds;
@property (nonatomic, strong) NSNumber * type;
@end

@implementation UILabel (DownTime)

-(void)startTime:(NSString*)txt second:(NSNumber*) second type:(NSNumber*) type
{
    self.seconds = second;
    self.txt = txt;
    self.type = type;
    if(self.timer) [self stopTime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)timerFired:(id) sender{
    if (self.seconds.intValue<0) {
        [self stopTime];
    }
    if (self.type.intValue == 1) {
        NSString* txt = [NSString stringWithFormat:@"(还剩%@)",[Utils MMSSformatFromSeconds:self.seconds.integerValue]];
        self.attributedText = [Utils attributeString:@[self.txt,txt] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14], NSForegroundColorAttributeName:[UIColor whiteColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11], NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    }
    if (self.type.intValue == 2) {
        self.text = [NSString stringWithFormat:@"%@ %@,请尽快前去指定医院领取您的挂号单。",self.txt, [Utils HHMMformatFromSeconds:self.seconds.integerValue]];
    }
    if (self.type.intValue == 3) {
        self.attributedText = [Utils attributeString:@[@"接单时间剩余 ",[Utils HHMMformatFromSeconds:self.seconds.integerValue]] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14], NSForegroundColorAttributeName:[UIColor orangeColor]}]];
    }
    
    int sed = self.seconds.intValue;
    sed--;
    self.seconds = [NSNumber numberWithInt:sed];
}

- (void)stopTime{
    
    if(self.timer != nil){
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSString *)txt {
    return objc_getAssociatedObject(self, @selector(txt));
}

- (NSNumber* )seconds {
    return objc_getAssociatedObject(self, @selector(seconds));
}

- (void)setSeconds:(NSNumber* )seconds {
    objc_setAssociatedObject(self, @selector(seconds), seconds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber* )type {
    return objc_getAssociatedObject(self, @selector(type));
}

- (void)setType:(NSNumber* )type {
    objc_setAssociatedObject(self, @selector(type), type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer {
    return objc_getAssociatedObject(self, @selector(timer));
}

-(void)setTxt:(NSString *)txt
{
    objc_setAssociatedObject(self, @selector(txt), txt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setTimer:(NSTimer *)timer
{
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
