
#import <UIKit/UIKit.h>

@interface GHNewFeatureCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;


// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;
@end
