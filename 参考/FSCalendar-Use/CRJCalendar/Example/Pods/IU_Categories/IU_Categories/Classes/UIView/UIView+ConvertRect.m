

#import "UIView+ConvertRect.h"

@implementation UIView (ConvertRect)

- (CGPoint)frameOriginFromView:(UIView *)view {
    
    return [self convertPoint:CGPointZero toView:view];
}

- (CGRect)frameFromView:(UIView *)view {
    
    return [self convertRect:self.bounds toView:view];
}

@end
