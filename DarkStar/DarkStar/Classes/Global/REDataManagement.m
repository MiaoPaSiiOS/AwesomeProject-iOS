//
//  REDataManagement.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/4.
//

#import "REDataManagement.h"
#import "DataEncrypt.h"

static NSString *kBCMAESKey = @"kPNCAESCommonKey";
static NSString *kBCMUserSessionKey = @"PNCLoginInfoKey";
static NSString *kBCMMerchantKey = @"PNCMerchantInfoKey";
static NSString *kBCMPrivacyAgreementKey = @"PNCPrivacyAgreementInfoKey";
static NSString *kBCMUTKey = @"PNCUTKey";
//static NSString *kBCMLoginCardNumKey = @"PNCLoginCardNumKey";
//static NSString *kBCMLoginUserKey = @"BCMLoginUserKey";


@interface REDataManagement ()

@property(nonatomic, strong, readwrite) REUser *user;//用户信息

@property(nonatomic, strong, readwrite) REMerchantModel *merchant;//门店信息

@property(nonatomic, strong, readwrite) REPrivacyAgreementModel *privacyAgreement;//隐私协议

@property(nonatomic, copy, readwrite) NSString *token; //ut值
@end

@implementation REDataManagement

#pragma mark - init
+ (instancetype)shared {
    static REDataManagement *share = nil;
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *lastUT = [self loadUTCache];
        if (!isStringEmptyOrNil(lastUT)) {
            _token = lastUT;
        }
        
        NSDictionary *lastUserInfo = [self loadUserInfoCache];
        if (!isDictEmptyOrNil(lastUserInfo)) {
            _user = [REUser mj_objectWithKeyValues:lastUserInfo];
        }
        
        NSDictionary *lasMerchantInfo = [self loadMerchantInfoCache];
        if (!isDictEmptyOrNil(lasMerchantInfo)) {
            _merchant = [REMerchantModel mj_objectWithKeyValues:lasMerchantInfo];
        }
        
        NSDictionary *lastPrivacyAgreementInfo = [self loadPrivacyAgreementInfoCache];
        if (!isDictEmptyOrNil(lastPrivacyAgreementInfo)) {
            _privacyAgreement = [REPrivacyAgreementModel mj_objectWithKeyValues:lasMerchantInfo];
        }

    }
    return self;
}

#pragma mark - Public - 保存UT
/// 保存用户信息
- (void)saveUT:(NSString *)ut {
    if( ![ut isEqualToString:_token])
    {
        _token = ut;
        [[NSUserDefaults standardUserDefaults] setObject:[DataEncrypt Encrypt:safeString(ut) withKey:kBCMAESKey] forKey:kBCMUTKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotification:REReloadWebViewNotification];
        });
    }
}

- (void)clearUT {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBCMUTKey];
}


///加载上次登录用户信息
- (NSString *)loadUTCache
{
    NSString *useNameInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kBCMUTKey];
    NSString *string = [DataEncrypt Decrypt:useNameInfo withKey:kBCMAESKey];
    return string;
}


#pragma mark - Public - 保存用户信息
/// 保存用户信息
- (void)saveUserInfo:(NSDictionary *)infoDict {
    _user = [REUser mj_objectWithKeyValues:infoDict];
    NSString *InfoJson = [isEmptyDict(infoDict) mj_JSONString];
    [[NSUserDefaults standardUserDefaults] setObject:[DataEncrypt Encrypt:safeString(InfoJson) withKey:kBCMAESKey] forKey:kBCMUserSessionKey]; //保存用户信息至UserDefault
}

/// 清空用户 Session
- (void)clearUserInfoDiskUserSession {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBCMUserSessionKey];
}

///加载上次登录用户信息
- (NSDictionary *)loadUserInfoCache
{
    NSString *useNameInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kBCMUserSessionKey];
    NSString *string = [DataEncrypt Decrypt:useNameInfo withKey:kBCMAESKey];
    NSDictionary *InfoDict = [string mj_JSONObject];
    return InfoDict;
}

#pragma mark - Public - 保存店铺信息
- (void)saveMerchant:(NSDictionary *)infoDict {
    _merchant = [REMerchantModel mj_objectWithKeyValues:infoDict];
    NSString *InfoJson = [isEmptyDict(infoDict) mj_JSONString];
    [[NSUserDefaults standardUserDefaults] setObject:[DataEncrypt Encrypt:safeString(InfoJson) withKey:kBCMAESKey] forKey:kBCMMerchantKey];
}

- (void)clearMerchantInfoDiskUserSession {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBCMMerchantKey];
}

- (NSDictionary *)loadMerchantInfoCache {
    NSString *useNameInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kBCMMerchantKey];
    NSString *string = [DataEncrypt Decrypt:useNameInfo withKey:kBCMAESKey];
    NSDictionary *InfoDict = [string mj_JSONObject];
    return InfoDict;
}

- (BOOL)hasMerchantInfo {
    if (!isDictEmptyOrNil([self loadMerchantInfoCache])) {
        return YES;
    }
    return NO;
}

#pragma mark - Public - 保存隐私协议信息
- (void)savePrivacyAgreement:(NSDictionary *)infoDict {
    _privacyAgreement = [REPrivacyAgreementModel mj_objectWithKeyValues:infoDict];
    NSString *InfoJson = [isEmptyDict(infoDict) mj_JSONString];
    [[NSUserDefaults standardUserDefaults] setObject:[DataEncrypt Encrypt:safeString(InfoJson) withKey:kBCMAESKey] forKey:kBCMPrivacyAgreementKey];
}

- (void)clearPrivacyAgreementInfoDiskUserSession {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBCMPrivacyAgreementKey];
}

- (NSDictionary *)loadPrivacyAgreementInfoCache {
    NSString *useNameInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kBCMPrivacyAgreementKey];
    NSString *string = [DataEncrypt Decrypt:useNameInfo withKey:kBCMAESKey];
    NSDictionary *InfoDict = [string mj_JSONObject];
    return InfoDict;
}

- (BOOL)hasPrivacyAgreementInfo {
    if (!isDictEmptyOrNil([self loadPrivacyAgreementInfoCache])) {
        return YES;
    }
    return NO;
}


#pragma mark - Public - 退出登录
- (void)logOut {
    [self clearUserInfo];
    [self clearMerchantInfoDiskUserSession];
    [self clearPrivacyAgreementInfoDiskUserSession];
    [self clearUT];
    [self postNotification:RELoginOutNotification];
    [[AppDelegate sharedDelegate] changeWindowRootVC:0];
}

- (BOOL)hasTokenOutDate {
//    NSDate* currentDate = [NSDate date];
//    NSTimeInterval time = [currentDate timeIntervalSinceDate:self.tokenLastDate];
//    if ((int)time/3600 >= 7*24 || _tokenLastDate == nil || (int)time == 0)
//    { // 时间过期或者为空
//        return YES;
//    }
    return NO;
}



#pragma mark - Private - 用户信息
/// 清空用户信息 包括单例中的所有字段、用户相关的Cookies
- (void)clearUserInfo {
    [self clearUserInfoRAM];// 清空内存数据
//    [self clearUserInfoCookies];// 清空所有非ARES-TOKEN Cookies数据
//    [self clearAllCookies];// 清空所有Cookies数据
//    [self clearUserInfoSession];// 清空设备会话Session
    [self clearUserInfoDiskUserSession];// 清空用户本次磁盘UserSession
}


/// 清空用户 内存信息
- (void)clearUserInfoRAM {
    _user = nil;
    _token = nil;
}

/// 清空用户 Cookies信息
- (void)clearUserInfoCookies {

}

/// 清空所有 Cookies信息
- (void)clearAllCookies {

}

/// 清空用户 Session
- (void)clearUserInfoSession {

}




#pragma mark - getter
+ (BOOL)isLogin
{
    NSString *token = [REDataManagement shared].token;
    if (!isStringEmptyOrNil(token) && ![token isEqualToString:@"default"])
    {
        return YES;
    }
    return NO;
}

#pragma mark - setter
-(void)setToken:(NSString *)token
{
    NSString* newToken = [NSString stringWithFormat:@"%@", token];
    NSString* oldToken = [NSString stringWithFormat:@"%@", _token];
    _token = newToken;
    if( ![newToken isEqualToString:oldToken])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotification:REReloadWebViewNotification];
        });
    }
}

#pragma mark - 网络请求
+ (void)getUserInfo:(void (^)(BOOL success))callBack {
    NSDictionary *params = @{@"identityTypeCode" : @4};
    [[KLNetWorkManager sharedInstance] dataTaskWithRequest:[KLRequest createReqWithUrl:RE_GET_USERINFO header:nil params:params requestType:AmenNetworkRequestTypePOST] completionHandler:^(KLResponse *result) {
        if (result.success) {
            NSDictionary *responseObject = result.responseObject;
            NSDictionary *detail = [responseObject getDict:@"data"];
            [[REDataManagement shared] saveUserInfo:detail];
        }
        
        if (callBack != nil) {
            callBack(result.success);
        }
    }];
}


@end

