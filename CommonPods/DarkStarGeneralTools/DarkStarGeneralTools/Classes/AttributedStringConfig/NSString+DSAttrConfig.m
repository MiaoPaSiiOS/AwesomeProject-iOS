//
//  NSString+DSAttrConfig.m
//  DSAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "NSString+DSAttrConfig.h"

@implementation NSString (DSAttrConfig)

- (NSMutableAttributedString *)nr_mutableAttributedStringWithStringAttributes:(NSArray <DSAttrStringConfig *> *)attributes {
    
    NSMutableAttributedString *attributedString = nil;
    
    if (self) {
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:self];
        
        for (DSAttrStringConfig *attribute in attributes) {
            
            [attributedString addAttribute:[attribute attributeName]
                                     value:[attribute attributeValue]
                                     range:[attribute effectiveStringRange]];
        }
    }
    
    return attributedString;
}

- (NSAttributedString *)nr_attributedStringWithStringAttributes:(NSArray <DSAttrStringConfig *> *)attributes {
    
    NSAttributedString *attributedString = nil;
    
    if (self) {
        
        NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
        
        for (DSAttrStringConfig *attribute in attributes) {
            
            [attributesDictionary setObject:[attribute attributeValue]
                                     forKey:[attribute attributeName]];
        }
        
        attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributesDictionary];
    }
    
    return attributedString;
}

- (NSAttributedString *)nr_attributedStringWithConfigs:(void (^)(NSMutableArray <DSAttrStringConfig *> *configs))configBlock {
    
    NSMutableArray      *array                = nil;
    NSMutableDictionary *attributesDictionary = nil;
    
    if (configBlock) {
        
        array                = [NSMutableArray array];
        attributesDictionary = [NSMutableDictionary dictionary];
        
        configBlock(array);
        
        [array enumerateObjectsUsingBlock:^(DSAttrStringConfig *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [attributesDictionary setObject:obj.attributeValue forKey:obj.attributeName];
        }];
    }
    
    NSAttributedString *atbString = [[NSAttributedString alloc] initWithString:self attributes:attributesDictionary];
    
    return atbString;
}

@end
