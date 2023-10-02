
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (DarkStar)
#pragma mark - 点击范围放大
- (void)ds_setEnlargeEdge:(CGFloat)size;
- (void)ds_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end

NS_ASSUME_NONNULL_END
