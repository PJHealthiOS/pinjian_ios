#import <UIKit/UIKit.h>
#import "DepartmentVO.h"

@protocol SelectDepartmentViewDelegate <NSObject>
-(void) selectDepartmentViewDelegate:(DepartmentVO*) vo;
@end

@interface SelectDepartmentView : UIView
@property(assign) id<SelectDepartmentViewDelegate> delegate;
@property(nonatomic) NSNumber * hospitalID;
-(void)updateView;
@end
