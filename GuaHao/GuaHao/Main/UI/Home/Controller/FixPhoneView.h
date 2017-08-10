
#import <UIKit/UIKit.h>

@protocol FixPhoneDelegate <NSObject>
-(void)fixPhoneDelegate:(BOOL) isSure phone:(NSString*) phone;
@end

@interface FixPhoneView : UIView
@property(assign) id<FixPhoneDelegate> delegate;
@property(nonatomic) NSNumber * patientID;
-(void)setPhone:(NSString*) _phone;
@end
