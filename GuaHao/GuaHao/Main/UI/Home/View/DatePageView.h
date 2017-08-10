#import <UIKit/UIKit.h>
#import "ScheduleDateVO.h"


@protocol DatePageViewDelegate <NSObject>
-(void) datePageViewDelegate:(ScheduleDateVO*) vo;
@end

@interface DatePageView : UIView
@property(assign) id<DatePageViewDelegate> delegate;
@property(nonatomic) NSArray * allDays;
@end
