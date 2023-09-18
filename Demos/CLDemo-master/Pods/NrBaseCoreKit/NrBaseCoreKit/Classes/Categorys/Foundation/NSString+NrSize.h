//
//  NSString+NrSize.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NrSize)
#pragma mark - Size计算
- (CGFloat)nr_heightWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute
                        fixedWidth:(CGFloat)width;

- (CGFloat)nr_widthWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute;

- (CGFloat)nr_heightWithFont:(UIFont *)font fixedWidth:(CGFloat)width;

- (CGFloat)nr_widthWithFont:(UIFont *)font;

+ (CGFloat)nr_oneLineOfTextHeightWithAttribute:(nullable NSDictionary <NSString *, id> *)attribute;

+ (CGFloat)nr_oneLineOfTextHeightWithFont:(UIFont *)font;
@end

@interface NSAttributedString (NrSize)

- (CGFloat)nr_heightWithFixedWidth:(CGFloat)width;

- (CGFloat)nr_width;

- (CGFloat)nr_coreTextHeightWithFixedWidth:(CGFloat)width;

@end



NS_ASSUME_NONNULL_END
