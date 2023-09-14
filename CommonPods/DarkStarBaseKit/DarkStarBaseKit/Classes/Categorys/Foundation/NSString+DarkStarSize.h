//
//  NSString+DarkStarSize.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DarkStarSize)
#pragma mark - Size计算
- (CGFloat)ds_heightWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute
                        fixedWidth:(CGFloat)width;

- (CGFloat)ds_widthWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute;

- (CGFloat)ds_heightWithFont:(UIFont *)font fixedWidth:(CGFloat)width;

- (CGFloat)ds_widthWithFont:(UIFont *)font;

+ (CGFloat)ds_oneLineOfTextHeightWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute;

+ (CGFloat)ds_oneLineOfTextHeightWithFont:(UIFont *)font;

+ (CGSize)ds_calculateSizeWithHandleBlock:(void (^)(UILabel *lable))handleBlock;

@end

@interface NSAttributedString (DarkStarSize)

- (CGFloat)ds_heightWithFixedWidth:(CGFloat)width;

- (CGFloat)ds_width;

- (CGFloat)ds_coreTextHeightWithFixedWidth:(CGFloat)width;

@end



NS_ASSUME_NONNULL_END
