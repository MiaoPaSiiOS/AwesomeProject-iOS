//
//  DSKernAttr.m
//  DSAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "DSKernAttr.h"

@implementation DSKernAttr
- (NSString *)attributeName {
    
    return NSKernAttributeName;
}

- (id)attributeValue {

    return self.kern;
}

+ (instancetype)configWithKern:(NSNumber *)kern range:(NSRange)range {
    
    DSKernAttr *config = [[self class] new];
    config.kern                 = kern;
    config.effectiveStringRange = range;
    
    return config;
}

+ (instancetype)configWithKern:(NSNumber *)kern {
    
    DSKernAttr *config = [[self class] new];
    config.kern                 = kern;
    
    return config;
}

@end
