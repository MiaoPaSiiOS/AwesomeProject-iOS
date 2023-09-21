

#import <UIKit/UIKit.h>

@interface UIView (DebugFrame)

/**
 显示指定颜色的外边框

 @param color 颜色
 */
- (void)showOutlineWithColor:(UIColor *)color;

/**
 显示随机颜色的外边框
 */
- (void)showRandomColorOutline;

/**
 显示随机颜色的外边框与背景色
 */
- (void)showRandomColorOutlineAndBackgroundColor;

@end
