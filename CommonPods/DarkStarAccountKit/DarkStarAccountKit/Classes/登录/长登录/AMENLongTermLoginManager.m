//
//  AMENLongTermLoginManager.m
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/2.
//

#import "AMENLongTermLoginManager.h"

@interface AMENLongTermLoginManager()

@end


@implementation AMENLongTermLoginManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AMENLongTermLoginManager *instance = nil;
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
