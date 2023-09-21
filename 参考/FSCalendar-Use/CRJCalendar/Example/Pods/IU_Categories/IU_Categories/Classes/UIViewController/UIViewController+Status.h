
#import <UIKit/UIKit.h>

@interface UIViewController (Status)

/**
 To check, that this controller is pushed from NavigationController.

 @return Is pushed from NavigationController or not.
 */
- (BOOL)isPushedFromNavigationController;

@end
