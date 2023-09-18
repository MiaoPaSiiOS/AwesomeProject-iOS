//
//  NrForegroundColorAttr.h
//  NrAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//  字体颜色

#import "NrAttrStringConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NrForegroundColorAttr : NrAttrStringConfig
@property (nonatomic, strong) UIColor *color;

+ (instancetype)configWithColor:(UIColor *)color range:(NSRange)range;
+ (instancetype)configWithColor:(UIColor *)color;


@end

NS_ASSUME_NONNULL_END
