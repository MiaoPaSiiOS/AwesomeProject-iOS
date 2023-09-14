//
//  NSAttributedString+DSAttrConfig.h
//  DSAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAttrStringConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (DSAttrConfig)
/**
 [构造器] 便利的设置不可变富文本对象
 
 @param string 字符串
 @param configBlock 配置的AttributedStringConfig数组
 @return 富文本对象
 */
+ (instancetype)nr_attributedStringWithString:(NSString *)string
                                       config:(void (^)(NSMutableArray <DSAttrStringConfig *> *configs))configBlock;

@end

NS_ASSUME_NONNULL_END
