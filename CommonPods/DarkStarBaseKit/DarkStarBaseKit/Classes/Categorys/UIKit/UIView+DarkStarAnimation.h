
#import <UIKit/UIKit.h>

@interface UIView (DarkStarAnimation)

/**
 *  Set the view's alpha.
 *
 *  @param alpha    Alpha.
 *  @param duration Animation's duration.
 *  @param animated Animated or not.
 */
- (void)alpha:(CGFloat)alpha duration:(NSTimeInterval)duration animated:(BOOL)animated;

@end


@interface UIView (DarkStarAnimationProperty)

/**
 *  CGAffineTransformMakeScale
 */
@property (nonatomic) CGFloat  scale;

/**
 *  CGAffineTransformMakeRotation angle表示旋转角度（大于0顺时针，小于0逆时针），M_PI_2表示90度。
 */
@property (nonatomic) CGFloat  angle;

@end
