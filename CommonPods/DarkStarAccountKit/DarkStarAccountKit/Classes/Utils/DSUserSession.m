//
//  DSUserSession.m
//  AmenCore
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "DSUserSession.h"

@interface DSUserSession()
@property(nonatomic, strong, readwrite) NSDictionary *userinfo;
@property(nonatomic, strong, readwrite) NSString *userid;
@property(nonatomic, assign, readwrite) BOOL isLogin;
@end

@implementation DSUserSession

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DSUserSession *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

//处理登录后服务器端返回的内容
+ (void)setLoginUserInfo:(NSDictionary *)info {
    if (!info || !info.allKeys.count || ![info.allKeys containsObject:@"userid"]) {
        [self setLoginOut];
    } else {
        [DSUserSession sharedInstance].userinfo = info;
        [DSUserSession sharedInstance].userid = info[@"userid"];
        [DSUserSession sharedInstance].isLogin = info ? YES:NO;
    }
}

//处理登出
+ (void)setLoginOut {
    [DSUserSession sharedInstance].userinfo = nil;
    [DSUserSession sharedInstance].userid = nil;
    [DSUserSession sharedInstance].isLogin = NO;
}



#pragma mark - getter
- (NSString *)userid {
    return self.userinfo[@"userid"];;
}

- (BOOL)isLogin {
    return self.userinfo ? YES:NO;
}
@end
