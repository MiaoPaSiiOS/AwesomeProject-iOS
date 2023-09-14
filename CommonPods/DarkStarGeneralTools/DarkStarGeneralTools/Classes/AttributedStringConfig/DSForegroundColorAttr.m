//
//  DSForegroundColorAttr.m
//  DSAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "DSForegroundColorAttr.h"

@implementation DSForegroundColorAttr
- (NSString *)attributeName {

    return NSForegroundColorAttributeName;
}

- (id)attributeValue {
    
    if (self.color) {
        
        return self.color;
        
    } else {
        
        return [UIColor blackColor];
    }
}

+ (instancetype)configWithColor:(UIColor *)color range:(NSRange)range {
    
    DSForegroundColorAttr *config = [[self class] new];
    config.color                           = color;
    config.effectiveStringRange            = range;
    
    return config;
}

+ (instancetype)configWithColor:(UIColor *)color {
    
    DSForegroundColorAttr *config = [[self class] new];
    config.color                           = color;
    
    return config;
}
@end
