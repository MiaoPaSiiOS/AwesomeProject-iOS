//
//  NrParagraphAttr.m
//  NrAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "NrParagraphAttr.h"

@implementation NrParagraphAttr
- (NSString *)attributeName {
    
    return NSParagraphStyleAttributeName;
}

- (id)attributeValue {
    
    if (self.paragraphStyle) {
        
        return self.paragraphStyle;
        
    } else {
        
        return [NSParagraphStyle defaultParagraphStyle];
    }
}

+ (instancetype)configWithParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    
    NrParagraphAttr *config = [[self class] new];
    config.paragraphStyle            = paragraphStyle;
    config.effectiveStringRange = range;
    
    return config;
}

+ (instancetype)configWithParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    
    NrParagraphAttr *config = [[self class] new];
    config.paragraphStyle            = paragraphStyle;
    
    return config;
}
@end
