#import <UIKit/UIKit.h>
#import "ScheduleDateVO.h"

@protocol SelectDateViewDelegate <NSObject>
-(void) selectDateViewDelegate:(ScheduleDateVO*) vo;
@end

@interface SelectDateView : UIView
@property(assign) id<SelectDateViewDelegate> delegate;


@property(nonatomic) NSNumber * hospitalID;
@property(nonatomic) NSNumber * departmentID;
-(void)updateView;
@end
