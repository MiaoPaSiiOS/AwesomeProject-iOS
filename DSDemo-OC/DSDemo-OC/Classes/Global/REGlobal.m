//
//  REGlobal.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/17.
//

#import "REGlobal.h"
#import "PGGCryptoRSA.h"

@implementation REGlobal

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static REGlobal *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}
@end
