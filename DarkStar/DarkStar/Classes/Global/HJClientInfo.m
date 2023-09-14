//
//  HJClientInfo.m
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import "HJClientInfo.h"
//#import "REGlobal.h"
#import "HJKeychain.h"
#import "HJKeychainDefine.h"
#import "UIDevice+IdentifierAddition.h"
#import "HJReachability.h"

#if (PHONE_TRACK_TYPE == 0)
#define phoneTrackid @"8366231"
#define phoneTrackName @"appstore_iphone"
#define phoneCobubAppKey  @"93678a96a1be5c589cc8beb9a24f69bd"

#elif (PHONE_TRACK_TYPE == 1)
#define phoneTrackid @"9495060"
#define phoneTrackName @"同步助手_iphone"
#define phoneCobubAppKey @"0194ffe256ed43431fff61f9564c0104"

#elif (PHONE_TRACK_TYPE == 2)
#define phoneTrackid @"10107021978"
#define phoneTrackName @"91助手_iphone"
#define phoneCobubAppKey @"5c1e4ed208d2238fefe71450b3b28b22"

#elif (PHONE_TRACK_TYPE == 3)
#define phoneTrackid @"10875922787"
#define phoneTrackName @"PP助手_iphone"
#define phoneCobubAppKey @"12d3ca1efa5e4655d1f1ab7c2f408b3d"

#elif (PHONE_TRACK_TYPE == 4)
#define phoneTrackid @"10958540151"
#define phoneTrackName @"快用_iphone"
#define phoneCobubAppKey @"4d8e9aebb9a082370530961a08329c54"

#elif (PHONE_TRACK_TYPE==5)
#define phoneTrackid @"1063359230"
#define phoneTrackName @"91应用大赏_iphone"
#define phoneCobubAppKey @"47898c05b71a5d8cb2cdc0244b931efa"

#elif (PHONE_TRACK_TYPE==6)
#define phoneTrackid @"10342259732"
#define phoneTrackName @"苹果树助手_iphone"
#define phoneCobubAppKey @"47898c05b71a5d8cb2cdc0244b931efb"

#elif (PHONE_TRACK_TYPE==7)
#define phoneTrackid @"10599979166"
#define phoneTrackName @"爱思助手_iphone"
#define phoneCobubAppKey @"47898c05b71a5d8cb2cdc0244b931efb"

#elif (PHONE_TRACK_TYPE==8)
#define phoneTrackid @"10624889577"
#define phoneTrackName @"海马_iphone"
#define phoneCobubAppKey @"47898c05b71a5d8cb2cdc0244b931efb"

#elif (PHONE_TRACK_TYPE==9)
#define phoneTrackid @"106741185582"
#define phoneTrackName @"itools"
#define phoneCobubAppKey @"47898c05b71a5d8cb2cdc0244b931efb"

#endif

//@interface REGlobal()
//
//@property (nonatomic, copy) NSString *clientInfoString;
//
//@end


@interface HJClientInfo ()

@property (nonatomic, copy) NSString *clientAppVersion;
@property (nonatomic, copy) NSString *clientSystem;
@property (nonatomic, copy) NSString *clientVersion;
@property (nonatomic, copy) NSString *deviceCode;
@property (nonatomic, copy) NSString *unionKey;
@property (nonatomic, copy) NSString *nettype;
@property (nonatomic, copy) NSNumber *iaddr;
@property (nonatomic, copy) NSString *phoneType;


@end

@implementation HJClientInfo
//DEF_SINGLETON(HJClientInfo)
+ (instancetype)sharedInstance
{
    static HJClientInfo *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[HJClientInfo alloc] init];
    });
    
    return helper;
}

@synthesize deviceToken = _deviceToken;

- (id)init {
    self = [super init];
    if (self) {
        _clientSystem = @"iosSystem";
        _clientVersion = [[UIDevice currentDevice] systemVersion];
        _clientDeviceType = @"iPhone";
        _traderName = kAppStoreChannel?@"APPStore":@"OtherChannel";
        
        _appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        
        _deviceCode = [NSString stringWithString:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
        _unionKey = phoneTrackid;
        
        _iaddr = @1;
        _nettype = @"";
        
        [[HJReachability sharedInstance] addObserver:self forKeyPath:@"currentNetStatus" options:NSKeyValueObservingOptionInitial context:nil];
    }
    
    return self;
}

- (NSString*)deviceToken{
    if (_deviceToken==nil) {
        _deviceToken= [HJKeychain getKeychainValueForType:HJ_KEYCHAIN_DEVICETOKEN];
    }
    return _deviceToken;
}

- (void)setDeviceToken:(NSString *)deviceToken {
    NSString *sr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    sr = [sr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [HJKeychain setKeychainValue:sr forType:HJ_KEYCHAIN_DEVICETOKEN];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.nettype = nil;
    
    //网络类型
    switch ([[HJReachability sharedInstance] currentNetStatus]) {
        case kConnectTo2G:
            self.nettype = @"2g";
            break;
        case kConnectTo3G:
            self.nettype = @"3g";
            break;
        case kConnectTo4G:
            self.nettype = @"4g";
            break;
        case kConnectToWifi:
            self.nettype = @"WIFI";
            break;
        default:
            self.nettype = @"";
            break;
    }
    
//    [REGlobal sharedInstance].clientInfoString = nil;
}

- (void)setLongitude:(NSNumber *)longitude
{
    _longitude = longitude;
//    [REGlobal sharedInstance].clientInfoString = nil;
}

- (void)setLatitude:(NSNumber *)latitude
{
    _latitude = latitude;
//    [REGlobal sharedInstance].clientInfoString = nil;
}

@end
