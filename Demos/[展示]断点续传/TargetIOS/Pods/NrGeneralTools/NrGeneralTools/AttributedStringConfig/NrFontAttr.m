//
//  NrFontAttr.m
//  NrAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "NrFontAttr.h"

@implementation NrFontAttr
- (NSString *)attributeName {
    
    return NSFontAttributeName;
}

- (id)attributeValue {
    
    if (self.font) {
        
        return self.font;
        
    } else {
        
        return [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
}

+ (instancetype)configWithFont:(UIFont *)font range:(NSRange)range {
    
    NrFontAttr *config = [[self class] new];
    config.font                 = font;
    config.effectiveStringRange = range;
    
    return config;
}

+ (instancetype)configWithFont:(UIFont *)font {
    
    NrFontAttr *config = [[self class] new];
    config.font                 = font;
    
    return config;
}

@end
