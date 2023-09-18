//
//  NSMutableAttributedString+NrAttrConfig.m
//  NrAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "NSMutableAttributedString+NrAttrConfig.h"

@implementation NSMutableAttributedString (NrAttrConfig)

- (void)nr_addStringAttribute:(NrAttrStringConfig *)stringAttribute {
    
    [self addAttribute:stringAttribute.attributeName
                 value:stringAttribute.attributeValue
                 range:stringAttribute.effectiveStringRange];
}

- (void)nr_removeStringAttribute:(NrAttrStringConfig *)stringAttribute {
    
    [self removeAttribute:stringAttribute.attributeName
                    range:stringAttribute.effectiveStringRange];
}

+ (instancetype)nr_mutableAttributedStringWithString:(NSString *)string
                                              config:(void (^)(NSString *string, NSMutableArray <NrAttrStringConfig *> *configs))configBlock {
    
    NSMutableAttributedString *atbString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableArray            *array     = nil;
    
    if (configBlock) {
        
        array = [NSMutableArray array];
        configBlock(string, array);
    }
    
    [array enumerateObjectsUsingBlock:^(NrAttrStringConfig *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [atbString nr_addStringAttribute:obj];
    }];
    
    return atbString;
}

@end
