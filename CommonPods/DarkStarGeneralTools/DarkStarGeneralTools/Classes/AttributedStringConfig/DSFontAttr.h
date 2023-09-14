//
//  DSFontAttr.h
//  DSAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//  字体

#import "DSAttrStringConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSFontAttr : DSAttrStringConfig
@property (nonatomic, strong) UIFont *font;

+ (instancetype)configWithFont:(UIFont *)font range:(NSRange)range;
+ (instancetype)configWithFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
