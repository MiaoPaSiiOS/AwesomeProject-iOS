//
//  NSMutableAttributedString+DSAttrConfig.h
//  DSAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAttrStringConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (DSAttrConfig)

/**
 添加富文本对象
 
 @param stringAttribute 富文本配置对象
 */
- (void)nr_addStringAttribute:(DSAttrStringConfig *)stringAttribute;

/**
 移除富文本对象
 
 @param stringAttribute 富文本配置对象
 */
- (void)nr_removeStringAttribute:(DSAttrStringConfig *)stringAttribute;

/**
 [构造器] 便利构造出富文本对象(可变富文本,可以进行局部设置)
 
 @param string 文本
 @param configBlock AttributedStringConfig配置的数组,往里面添加AttributedStringConfig即可
 @return 富文本实体
 */
+ (instancetype)nr_mutableAttributedStringWithString:(NSString *)string config:(void (^)(NSString *string, NSMutableArray <DSAttrStringConfig *> *configs))configBlock;

@end

NS_ASSUME_NONNULL_END
