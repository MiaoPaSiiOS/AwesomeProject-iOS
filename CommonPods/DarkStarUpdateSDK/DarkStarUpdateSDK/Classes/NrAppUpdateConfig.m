//
//  NrAppUpdateConfig.m
//  IU_UpdateSDK
//
//

#import "NrAppUpdateConfig.h"
#import "NrUpdateUtils.h"

#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>

NSString * const NrAppUpdateEVersionKey = @"e_version";

NSString * const NrAppUpdateEModelKey = @"e_model";

NSString * const NrAppUpdateAppIdKey = @"appId";

NSString * const NrAppUpdateAppVersionKey = @"appVersion";

NSString * const NrAppUpdateOsKey = @"os";

NSString * const NrAppUpdateOsVersionKey = @"osVersion";

NSString * const NrAppUpdateHostKey = @"host";

NSString * const NrAppUpdateDeviceIdKey = @"deviceId";

NSString * const NrAppUpdateEncryptRsaKey = @"rsaKey";


@interface NrAppUpdateConfig ()

@property (nonatomic, copy, readwrite) NSString *e_version; // RSA秘钥版本号(如果存在e_model则必填)
@property (nonatomic, copy, readwrite) NSString *e_model; // 对敏感信息使用RSA加密后的字符串
@property (nonatomic, copy, readwrite) NSString *appId; // 渠道号
@property (nonatomic, copy, readwrite) NSString *appVersion; // 手机端当前app产品版本号
@property (nonatomic, copy, readwrite) NSString *os; // 手机操作系统类型[android/ios, 或者 1/2]
@property (nonatomic, copy, readwrite) NSString *osVersion; // 手机操作系统版本号
@property (nonatomic, copy, readwrite) NSString *host; // host地址
@property (nonatomic, copy, readwrite) NSString *deviceId; // 设备唯一标识符
@property (nonatomic, copy, readwrite) NSString *encryptRsaKey; // 加密RSA Key

@end

@implementation NrAppUpdateConfig

+ (instancetype)configWithDict:(NSDictionary *)dictionary
{
    NrAppUpdateConfig *config = [[NrAppUpdateConfig alloc] init];

    if (config != nil)
    {
        config.e_version = dictionary[NrAppUpdateEVersionKey]? :@"1.0";
        config.appId = dictionary[NrAppUpdateAppIdKey];
        config.appVersion = dictionary[NrAppUpdateAppVersionKey];
        config.os = dictionary[NrAppUpdateOsKey]? :@"ios";
        config.osVersion = dictionary[NrAppUpdateOsVersionKey]? :[UIDevice currentDevice].systemVersion;
        config.host = dictionary[NrAppUpdateHostKey]? :@"https://fzcms.jryzt.com";
        config.deviceId = dictionary[NrAppUpdateDeviceIdKey]? :[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        config.encryptRsaKey = dictionary[NrAppUpdateEncryptRsaKey];

        NSAssert(config.appId, @"appId must not be nil.");
        NSAssert(config.appVersion, @"appVersion must not be nil.");
        NSAssert(config.encryptRsaKey, @"encryptRsaKey must not be nil.");

        NSMutableDictionary *eModelParameters = [[NSMutableDictionary alloc] initWithCapacity:0];
        eModelParameters[NrAppUpdateDeviceIdKey] = config.deviceId;

        NSString *eModelString = [NrUpdateUtils stringWithObject:eModelParameters];
        NSString *eModel = [NrUpdateUtils encryptRSAWithString:eModelString publicKey:config.encryptRsaKey];
        config.e_model = eModel;
    }

    return config;
}

- (instancetype)initWithAppId:(NSString *)appId
                   appVersion:(NSString *)appVersion
                encryptRsaKey:(NSString *)key
{
    return [self initWithAppId:appId
                    appVersion:appVersion
                 encryptRsaKey:key
                      deviceId:nil
                     e_version:nil
                            os:nil
                     osVersion:nil
                          host:nil];
}

- (instancetype)initWithAppId:(NSString *)appId
                   appVersion:(NSString *)appVersion
                encryptRsaKey:(NSString *)key
                         host:(NSString *)host
{
    return [self initWithAppId:appId
                    appVersion:appVersion
                 encryptRsaKey:key
                      deviceId:nil
                     e_version:nil
                            os:nil
                     osVersion:nil
                          host:host];
}

- (instancetype)initWithAppId:(NSString *)appId
                   appVersion:(NSString *)appVersion
                encryptRsaKey:(NSString *)key
                     deviceId:(NSString *)deviceId
                         host:(NSString *)host
{
    return [self initWithAppId:appId
                    appVersion:appVersion
                 encryptRsaKey:key
                      deviceId:deviceId
                     e_version:nil
                            os:nil
                     osVersion:nil
                          host:host];
}

- (instancetype)initWithAppId:(NSString *)appId
                   appVersion:(NSString *)appVersion
                encryptRsaKey:(NSString *)key
                     deviceId:(NSString *)deviceId
                    e_version:(NSString *)e_version
                           os:(NSString *)os
                    osVersion:(NSString *)osVersion
                         host:(NSString *)host
{
    NSAssert(appId, @"appId must not be nil.");
    NSAssert(appVersion, @"appVersion must not be nil.");
    NSAssert(key, @"encryptRsaKey must not be nil.");

    self = [super init];

    if (self)
    {
        self.e_version = e_version? :@"1.0";
        self.appId = appId;
        self.appVersion = appVersion;
        self.os = os? :@"ios";
        self.osVersion = osVersion? :[UIDevice currentDevice].systemVersion;
        self.host = host? :@"https://fzcms.jryzt.com";
        self.deviceId = deviceId? :[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        self.encryptRsaKey = key;

        NSMutableDictionary *eModelParameters = [[NSMutableDictionary alloc] initWithCapacity:0];
        eModelParameters[NrAppUpdateDeviceIdKey] = deviceId;

        NSString *eModelString = [NrUpdateUtils stringWithObject:eModelParameters];
        NSString *eModel = [NrUpdateUtils encryptRSAWithString:eModelString publicKey:key];
        self.e_model = eModel;
    }

    return self;
}

@end

