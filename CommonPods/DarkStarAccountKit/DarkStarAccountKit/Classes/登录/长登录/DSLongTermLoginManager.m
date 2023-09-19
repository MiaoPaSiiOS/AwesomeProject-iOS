//
//  DSLongTermLoginManager.m
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/2.
//

#import "DSLongTermLoginManager.h"

@interface DSLongTermLoginManager()

@end


@implementation DSLongTermLoginManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DSLongTermLoginManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)signInWithLongTerm {
}


- (void)configWithBlock:(LoginBlock)loginBlock{

}
@end
