#import <UIKit/UIKit.h>

@class BankLogVO;
@protocol BankLogViewDelegate <NSObject>
-(void) bankLogViewDelegate:(BankLogVO*) vo;
@end

@interface BankLogViewView : UIView
@property(assign) id<BankLogViewDelegate> delegate;
@end
