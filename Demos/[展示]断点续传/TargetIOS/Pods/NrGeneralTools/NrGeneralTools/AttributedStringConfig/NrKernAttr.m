//
//  NrKernAttr.m
//  NrAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "NrKernAttr.h"

@implementation NrKernAttr
- (NSString *)attributeName {
    
    return NSKernAttributeName;
}

- (id)attributeValue {

    return self.kern;
}

+ (instancetype)configWithKern:(NSNumber *)kern range:(NSRange)range {
    
    NrKernAttr *config = [[self class] new];
    config.kern                 = kern;
    config.effectiveStringRange = range;
    
    return config;
}

+ (instancetype)configWithKern:(NSNumber *)kern {
    
    NrKernAttr *config = [[self class] new];
    config.kern                 = kern;
    
    return config;
}

@end
