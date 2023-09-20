//
//  UIColor+Nr.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2022/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Nr)
+ (UIColor *)nr_colorWithHexString:(NSString *)hexString;
+ (UIColor *)nr_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)nr_colorWithColorString:(NSString *)colorString;
+ (UIColor *)nr_randomColor;
@end

NS_ASSUME_NONNULL_END
