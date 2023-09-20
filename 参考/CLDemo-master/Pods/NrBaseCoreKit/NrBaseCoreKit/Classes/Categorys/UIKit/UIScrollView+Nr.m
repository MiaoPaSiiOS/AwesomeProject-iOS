
#import "UIScrollView+Nr.h"

@implementation UIScrollView (Nr)
- (void)nr_scrollToTop {
    [self nr_scrollToTopAnimated:YES];
}

- (void)nr_scrollToBottom {
    [self nr_scrollToBottomAnimated:YES];
}

- (void)nr_scrollToLeft {
    [self nr_scrollToLeftAnimated:YES];
}

- (void)nr_scrollToRight {
    [self nr_scrollToRightAnimated:YES];
}

- (void)nr_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)nr_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)nr_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)nr_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
