
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (DarkStar)
- (void)ds_scrollToTop;
- (void)ds_scrollToBottom;
- (void)ds_scrollToLeft;
- (void)ds_scrollToRight;
- (void)ds_scrollToTopAnimated:(BOOL)animated;
- (void)ds_scrollToBottomAnimated:(BOOL)animated;
- (void)ds_scrollToLeftAnimated:(BOOL)animated;
- (void)ds_scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
