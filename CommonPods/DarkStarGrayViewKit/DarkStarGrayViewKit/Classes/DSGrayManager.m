//
//  DSGrayManager.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "DSGrayManager.h"

@implementation DSGrayManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static DSGrayManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.grayViewEnabled = NO;
    }
    return self;
}
@end
