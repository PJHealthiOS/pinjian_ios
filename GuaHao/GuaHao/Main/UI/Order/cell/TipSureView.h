
#import <UIKit/UIKit.h>
#import "PatientVO.h"

@protocol TipSureViewDelegate <NSObject>
-(void)tipSureDelegate:(BOOL) isSure;
@end
@interface TipSureView : UIView
-(void)setNames:(NSString*)name;
@property(assign) id<TipSureViewDelegate> delegate;
@property(nonatomic) PatientVO * patient;
@end
