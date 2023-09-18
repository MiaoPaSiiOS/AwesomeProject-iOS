//
//  NSString+NrAttrConfig.m
//  NrAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "NSString+NrAttrConfig.h"

@implementation NSString (NrAttrConfig)

- (NSMutableAttributedString *)nr_mutableAttributedStringWithStringAttributes:(NSArray <NrAttrStringConfig *> *)attributes {
    
    NSMutableAttributedString *attributedString = nil;
    
    if (self) {
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:self];
        
        for (NrAttrStringConfig *attribute in attributes) {
            
            [attributedString addAttribute:[attribute attributeName]
                                     value:[attribute attributeValue]
                                     range:[attribute effectiveStringRange]];
        }
    }
    
    return attributedString;
}

- (NSAttributedString *)nr_attributedStringWithStringAttributes:(NSArray <NrAttrStringConfig *> *)attributes {
    
    NSAttributedString *attributedString = nil;
    
    if (self) {
        
        NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
        
        for (NrAttrStringConfig *attribute in attributes) {
            
            [attributesDictionary setObject:[attribute attributeValue]
                                     forKey:[attribute attributeName]];
        }
        
        attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributesDictionary];
    }
    
    return attributedString;
}

- (NSAttributedString *)nr_attributedStringWithConfigs:(void (^)(NSMutableArray <NrAttrStringConfig *> *configs))configBlock {
    
    NSMutableArray      *array                = nil;
    NSMutableDictionary *attributesDictionary = nil;
    
    if (configBlock) {
        
        array                = [NSMutableArray array];
        attributesDictionary = [NSMutableDictionary dictionary];
        
        configBlock(array);
        
        [array enumerateObjectsUsingBlock:^(NrAttrStringConfig *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [attributesDictionary setObject:obj.attributeValue forKey:obj.attributeName];
        }];
    }
    
    NSAttributedString *atbString = [[NSAttributedString alloc] initWithString:self attributes:attributesDictionary];
    
    return atbString;
}

@end
