
#import "UIViewController+Status.h"

@implementation UIViewController (Status)

- (BOOL)isPushedFromNavigationController {
    
    __block BOOL isPushed = NO;
    
    if (self.navigationController) {
        
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
            
            if ([controller isEqual:self]) {
                
                isPushed = YES;
                *stop    = YES;
            }
        }];
    }
    
    return isPushed;
}

@end
