
#import "UIScrollView+DarkStar.h"

@implementation UIScrollView (DarkStar)
- (void)ds_scrollToTop {
    [self ds_scrollToTopAnimated:YES];
}

- (void)ds_scrollToBottom {
    [self ds_scrollToBottomAnimated:YES];
}

- (void)ds_scrollToLeft {
    [self ds_scrollToLeftAnimated:YES];
}

- (void)ds_scrollToRight {
    [self ds_scrollToRightAnimated:YES];
}

- (void)ds_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)ds_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)ds_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)ds_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
