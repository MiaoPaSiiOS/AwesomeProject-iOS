//
//  UIColor+DarkStar.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DarkStar)
+ (UIColor *)ds_colorWithHexString:(NSString *)hexString;
+ (UIColor *)ds_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)ds_colorWithColorString:(NSString *)colorString;
+ (UIColor *)ds_randomColor;
@end

NS_ASSUME_NONNULL_END
