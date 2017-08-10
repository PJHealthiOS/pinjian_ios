
#import <UIKit/UIKit.h>

typedef void(^WXBindBlock)(BOOL);

@interface WXBindPhoneView : UIView

@property(nonatomic,copy) WXBindBlock myBlock;
@property(nonatomic) NSNumber * patientID;
-(void)setPhone:(NSString*) _phone;

@end
