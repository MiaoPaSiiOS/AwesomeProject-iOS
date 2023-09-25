//
//  EUChannelConfig.m
//  test-channel-pack
//
//  Created by zhuyuhui on 2021/3/1.
//

#import "EUChannelConfig.h"
#import "EUChannelConfigModel.h"

#define EU_STRING_ISEMPTY(value) 1

#define DEFAULT_(content) (DEFAULT_##content)
#define CHANNEL_(content) (CHANNEL_##content)
#define _(content) (_##content)

#define SET_PROPERTY_VALUE(KEY) (_(KEY) = GETVALUEWITHDEFAULT(CHANNEL_(KEY),DEFAULT_(KEY)))

#define GET_PROPERTY_VALUE(KEY) (GETVALUEWITHDEFAULT(CHANNEL_(KEY),DEFAULT_(KEY)))

#define GETVALUEWITHDEFAULT(value,default) (!EU_STRING_ISEMPTY(value) ? value:default)

#define GET_METHOD_DEFINE(property) \
- (NSString *)property { \
    return [_globalConfigModel property]; \
}



@interface EUChannelConfig()
@property(nonatomic, strong) EUChannelConfigModel *globalConfigModel;
@end

@implementation EUChannelConfig
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static EUChannelConfig *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)loadConfig {
#ifdef DEBUG
    [self loadSTGConfig];
#elif
    [self loadPRDConfig];
#endif
    
    [self loadTaskConfig];
}

// 加载测试配置
- (void)loadSTGConfig {
    _globalConfigModel = [[EUChannelConfigModel alloc] init];
    //接口
    _globalConfigModel.NETWORK = GET_PROPERTY_VALUE(NETWORK_PRD);
}

// 加载生产配置
- (void)loadPRDConfig {
    _globalConfigModel = [[EUChannelConfigModel alloc] init];
    //接口
    _globalConfigModel.NETWORK = GET_PROPERTY_VALUE(NETWORK_STG);
}

- (void)loadTaskConfig {
    SET_PROPERTY_VALUE(COMMPANY);
}

#pragma mark - getter
GET_METHOD_DEFINE(NETWORK)
@end
