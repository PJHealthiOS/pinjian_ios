#import <UIKit/UIKit.h>
#import "HospitalVO.h"

@protocol SelectHospitalViewDelegate <NSObject>
-(void) selectHospitalViewDelegate:(HospitalVO*) vo;
@end

@interface SelectHospitalView : UIView
@property(assign) id<SelectHospitalViewDelegate> delegate;
@end
