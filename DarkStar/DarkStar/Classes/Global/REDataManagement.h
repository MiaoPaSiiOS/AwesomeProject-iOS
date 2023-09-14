//
//  REDataManagement.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/4.
//

#import <Foundation/Foundation.h>
#import "REUser.h"
#import "REMerchantModel.h"
#import "REPrivacyAgreementModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface REDataManagement : NSObject

@property(nonatomic, strong, readonly) REUser *user;//用户信息

@property(nonatomic, strong, readonly) REMerchantModel *merchant;//门店信息

@property(nonatomic, strong, readonly) REPrivacyAgreementModel *privacyAgreement;//隐私协议


@property(nonatomic, copy, readonly) NSString *token; //ut值

//@property(nonatomic, strong) NSDate *tokenLastDate;  //最新记录token的时间

+ (BOOL)isLogin;

///单例
+ (instancetype)shared;


#pragma mark - Public - 保存UT
- (void)saveUT:(NSString *)ut;

#pragma mark - Public - 保存用户信息
- (void)saveUserInfo:(NSDictionary *)infoDict;

#pragma mark - Public - 保存店铺信息
- (void)saveMerchant:(NSDictionary *)infoDict;
- (NSDictionary *)loadMerchantInfoCache;
- (BOOL)hasMerchantInfo;

#pragma mark - Public - 保存隐私协议信息
- (void)savePrivacyAgreement:(NSDictionary *)infoDict;
- (NSDictionary *)loadPrivacyAgreementInfoCache;
- (BOOL)hasPrivacyAgreementInfo;


#pragma mark - Public - 退出登录
- (void)logOut;

- (BOOL)hasTokenOutDate;

///获取登录用户信息
- (NSDictionary *)loadUserInfoCache;



#pragma mark - 网络请求
+ (void)getUserInfo:(void (^)(BOOL success))callBack;

@end

NS_ASSUME_NONNULL_END
