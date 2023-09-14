//
//  DSAppConfiguration.m
//  DarkStarConfiguration
//
//  Created by zhuyuhui on 2023/6/2.
//

#import "DSAppConfiguration.h"
#import "MJExtension.h"
#import "DSDBTool.h"

static DSAppConfiguration *_shareconfiguration = nil;
NSString *const developer_url = @"developer_url";

@implementation DSAppConfiguration

+ (instancetype)shareConfiguration {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareconfiguration = [[self alloc] init];
    });
    return _shareconfiguration;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareconfiguration = [super allocWithZone:zone];
    });
    return _shareconfiguration;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray * array = [NSMutableArray arrayWithObjects:
              @{
                    @"title":@"五粮液生产",
                    @"url":@"http://eimspos.wuliangye.com.cn/",
                    @"H5Host":@"http://eimspos.wuliangye.com.cn/",
                    @"companyId":@"21000",
                    @"scheme":@"prodcf",
                    @"fornumUrl":@"http://eimspos.wuliangye.com.cn/"
               },
              @{
                    @"title":@"五粮液dev",
                    @"url":@"http://mpos-wly-dev.oudianyun.com/",
                    @"H5Host":@"http://mpos-wly-dev.oudianyun.com/",
                    @"companyId":@"21000",
                    @"scheme":@"prodcf",
                    @"fornumUrl":@"http://mpos-wly-dev.oudianyun.com/"
               },
              @{
                    @"title":@"五粮液trunk",
                    @"url":@"http://mpos-wly-trunk.oudianyun.com/",
                    @"H5Host":@"http://mpos-wly-trunk.oudianyun.com/",
                    @"companyId":@"21000",
                    @"scheme":@"prodcf",
                    @"fornumUrl":@"http://mpos-wly-trunk.oudianyun.com/"
               },nil];
        
        self.environments = [NSMutableArray array];
        for (NSDictionary * configDic in array) {
            DSEnvironment * model = [DSEnvironment mj_objectWithKeyValues:configDic];
            [self.environments addObject:model];
        }
        
#ifdef DEBUG
        self.environment = [self.environments lastObject];
        NSData *data = [[DSDBTool shareDatabase] readValueForkey:developer_url];
        DSEnvironment *cacheModel = [DSEnvironment mj_objectWithKeyValues:data];
        if(cacheModel){
            self.environment = cacheModel;
        }

#else
        self.environment = [self.environments firstObject];
#endif
    }
    return self;
}






@end


