//
//  DSUserSession.h
//  AmenCore
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <Foundation/Foundation.h>

@interface DSUserSession : NSObject
@property(nonatomic, strong, readonly) NSDictionary *userinfo;
@property(nonatomic, strong, readonly) NSString *userid;
@property(nonatomic, assign, readonly) BOOL isLogin;

+ (instancetype)sharedInstance;
//处理登录后服务器端返回的内容
+ (void)setLoginUserInfo:(NSDictionary *)info;
//处理登出
+ (void)setLoginOut;
@end
