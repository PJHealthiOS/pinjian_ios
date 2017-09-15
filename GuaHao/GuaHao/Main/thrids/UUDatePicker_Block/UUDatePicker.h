//
//  UUDatePicker.h
//  Yang
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIActionSheet.h"
@class UUDatePicker;

typedef enum{
    
    UUDateStyle_YearMonthDayHourMinute = 0,
    UUDateStyle_YearMonthDay,
    UUDateStyle_MonthDayHourMinute,
    UUDateStyle_HourMinute,
    UUDateStyle_TimeQuantum
    
}DateStyle;

typedef void (^FinishBlock)(NSString * year,
                            NSString * month,
                            NSString * day,
                            NSString * hour,
                            NSString * minute,
                            NSString * weekDay);


//  说明，uuDatePicker的Size最小是320x216的。
@protocol UUDatePickerDelegate <NSObject>

- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay;
@end


@interface UUDatePicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,assign)BOOL isAccompany;
@property(nonatomic,assign)BOOL isSerious;

@property  BOOL isMedicineOrReport;//是否是成人
@property  BOOL isAdult;//是否是成人
@property (nonatomic) BOOL isChildren;
@property (nonatomic) BOOL isUseSocialCard;///医保卡预约
@property (nonatomic) BOOL isFixBirthday;;
@property (nonatomic,assign) int startByHalfDay;;




@property (nonatomic, assign) id <UUDatePickerDelegate> delegate;

@property (nonatomic, assign) DateStyle datePickerStyle;

@property (nonatomic, retain) NSDate *ScrollToDate;//滚到指定日期
@property (nonatomic, retain) NSDate *maxLimitDate;//限制最大时间（没有设置默认2049）
@property (nonatomic, retain) NSDate *minLimitDate;//限制最小时间（没有设置默认1970）
@property (nonatomic, retain) NSString* openDays;//专家号周排班安排 比如 1112300 0表示不开放 1表示开放全天  2表示开放上午 3表示开放下午

@property(nonatomic) CustomUIActionSheet * sheet;
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (id)initWithframe:(CGRect)frame Delegate:(id<UUDatePickerDelegate>)delegate PickerStyle:(DateStyle)uuDateStyle;
- (id)initWithframe:(CGRect)frame PickerStyle:(DateStyle)uuDateStyle didSelected:(FinishBlock)finishBlock;
- (void)getFirstDate;
- (void)drawRect:(CGRect)rect;
@end