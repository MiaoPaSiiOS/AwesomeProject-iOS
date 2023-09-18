
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface SRSAutoLayoutScrollView : UIScrollView

@property (nonatomic) BOOL isHorizontal;
@property (nonatomic, readonly) UIView *contentView;
@end

NS_ASSUME_NONNULL_END
