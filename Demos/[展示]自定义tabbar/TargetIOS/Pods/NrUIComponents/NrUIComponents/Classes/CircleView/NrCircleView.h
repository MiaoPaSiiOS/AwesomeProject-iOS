//
//  NrCircleView.h
//  Pods
//
//  Created by zhuyuhui on 2020/9/17.
//

#import <UIKit/UIKit.h>
#import <NrQMUI/QMUIAnimationHelper.h>

@interface NrCircleView : UIView
/**
 *  Line width.
 */
@property (nonatomic)         CGFloat   lineWidth;

/**
 *  Line color.
 */
@property (nonatomic, strong) UIColor  *lineColor;
/**
 *  baseLineColor color.
 */
@property (nonatomic, strong) UIColor  *baseLineColor;

/**
 *  是否顺时针.
 */
@property (nonatomic)         BOOL      clockWise;

/**
 *  Start angle, range is 0°~360°
 */
@property (nonatomic)         CGFloat   startAngle;


- (void)makeConfigEffective;
/**
 *  Start strokeEnd animation.
 *
 *  @param value    StrokeEnd value, range is [0, 1].
 *  @param easing     Easing function point.
 *  @param animated Animated or not.
 *  @param duration The animation's duration.
 */
- (void)strokeEnd:(CGFloat)value
           easing:(QMUIAnimationEasings)easing
         animated:(BOOL)animated
         duration:(CGFloat)duration;

/**
 *  Start strokeStart animation.
 *
 *  @param value    StrokeEnd value, range is [0, 1].
 *  @param easing     Easing function point.
 *  @param animated Animated or not.
 *  @param duration The animation's duration.
 */
- (void)strokeStart:(CGFloat)value
             easing:(QMUIAnimationEasings)easing
           animated:(BOOL)animated
           duration:(CGFloat)duration;

/**
 *  Convenient constructor.
 *
 *  @param frame     View frame.
 *  @param width     Line width.
 *  @param color     Line color.
 *  @param clockWise Clockwise or not.
 *  @param angle     Start angle, range is 0°~360°.
 *
 *  @return CircleView instance.
 */
+ (instancetype)circleViewWithFrame:(CGRect)frame
                          lineWidth:(CGFloat)width
                          lineColor:(UIColor *)color
                          clockWise:(BOOL)clockWise
                         startAngle:(CGFloat)angle;

@end

