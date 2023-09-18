
#import <UIKit/UIKit.h>

@interface UIView (NrAnimationMethod)

/**
 *  Set the view's alpha.
 *
 *  @param alpha    Alpha.
 *  @param duration Animation's duration.
 *  @param animated Animated or not.
 */
- (void)alpha:(CGFloat)alpha duration:(NSTimeInterval)duration animated:(BOOL)animated;

@end


@interface UIView (TmallAnimationProperty)

/**
 *  CGAffineTransformMakeScale
 */
@property (nonatomic) CGFloat  scale;

/**
 *  CGAffineTransformMakeRotation
 */
@property (nonatomic) CGFloat  angle;

@end
