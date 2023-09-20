
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Nr)
- (void)nr_scrollToTop;
- (void)nr_scrollToBottom;
- (void)nr_scrollToLeft;
- (void)nr_scrollToRight;
- (void)nr_scrollToTopAnimated:(BOOL)animated;
- (void)nr_scrollToBottomAnimated:(BOOL)animated;
- (void)nr_scrollToLeftAnimated:(BOOL)animated;
- (void)nr_scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
