//
//  DSWebKitGlobal.m
//  AmenWebKit
//
//  Created by zhuyuhui on 2021/12/7.
//

#import "DSWebKitGlobal.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
@implementation DSWebKitGlobal

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DSWebKitGlobal *instance = nil;
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
        NSDictionary *functionList = [self loadDefaultJsonWithName:@"visualmenufunctionlist"];
        //网络白名单
        NSArray *PAGEWHITELIST = [functionList objectForKey:@"PAGEWHITELIST"];
        if (!isArrayEmptyOrNil(PAGEWHITELIST)) {
            self.pageWhiteList = PAGEWHITELIST;
        } else {
            NSDictionary *SRSdic = @{@"description" : @"从缓存/服务器获取的网络白名单为空"};
            NSLog(@"%@",SRSdic);
        }
        //h5缓存名单列表
        NSArray *WEBCACHEWHITELIST = [functionList objectForKey:@"WEBCACHEWHITELIST"];
        if (!isArrayEmptyOrNil(WEBCACHEWHITELIST)) {
            self.webCacheWhiteList = WEBCACHEWHITELIST;
        } else {
            NSDictionary *SRSdic = @{@"description" : @"从缓存/服务器获取的h5缓存名单列表为空"};
            NSLog(@"%@",SRSdic);
        }
        
        // 获取商户回调白名单
        NSArray *PAGEMERCHANTLIST = functionList[@"PAGEMERCHANTLIST"];
        NSMutableArray *pageMerchantList = [NSMutableArray new];
        for (NSDictionary *dict in PAGEMERCHANTLIST) {
            if (dict[@"DOMAIN"]) {
                [pageMerchantList addObject:dict[@"DOMAIN"]];
            }
        }
        self.pageMerchantList = pageMerchantList;
        
        
        // 特殊情况放行的链接
        NSArray *PAGESPECIALLIST = functionList[@"PAGESPECIALLIST"];
        NSMutableArray *pageSpecialList = [NSMutableArray new];
        for (NSDictionary *dict in PAGESPECIALLIST) {
            if (dict[@"DOMAIN"]) {
                [pageSpecialList addObject:dict[@"DOMAIN"]];
            }
        }
        self.pageSpecialList = pageSpecialList;
    }
    return self;
}


#pragma mark - 特殊情况url判断
+ (BOOL)SpecialIOSListFlag:(NSString *)netUrl {
    if (isStringEmptyOrNil(netUrl)) {
        return YES;
    }
    NSMutableArray *netPageUrl=[[NSMutableArray alloc]init];
    [netPageUrl addObjectsFromArray:[[DSWebKitGlobal sharedInstance] pageSpecialList]];
    [netPageUrl addObject:@"mdb://"];
    [netPageUrl addObject:@"tel://"];
    [netPageUrl addObject:@"mailto://"];
    [netPageUrl addObject:@"sms://"];
    [netPageUrl addObject:@"itms-apps://"];
    [netPageUrl addObject:@"about:srcdoc"];//重定向，避免弹出外链警告框
    [netPageUrl addObject:@"about:blank"];//重定向

    for(NSString *domain in netPageUrl) {
        //去除url中空格符
        netUrl= [netUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([netUrl isEqualToString:domain] || [netUrl hasPrefix:domain]){
            return YES;
        }
    }
    return NO;
}

#pragma mark - 网络白名单
+ (BOOL)DomainFlag:(NSString *)netUrl {
    //菜单列表［domain];
    NSMutableArray *netPageUrl = [[NSMutableArray alloc] init];
    [netPageUrl addObjectsFromArray:[[DSWebKitGlobal sharedInstance] pageWhiteList]];
    //固化 bankcomm.com
    NSDictionary *dictDomain1 = @{ @"DOMAIN": @"bankcomm.com" };
    NSDictionary *dictDomain2 = @{ @"DOMAIN": @"unionpay.com" };
    NSDictionary *dictDomain3 = @{ @"DOMAIN": @"95516.com" };
    NSDictionary *dictDomain4 = @{ @"DOMAIN": @"95559.com.cn" };
//    NSDictionary *dictDomain5 = @{ @"DOMAIN": @"vip.com" };
    [netPageUrl addObject:dictDomain1];
    [netPageUrl addObject:dictDomain2];
    [netPageUrl addObject:dictDomain3];
    [netPageUrl addObject:dictDomain4];
//    [netPageUrl addObject:dictDomain5];

    for (NSDictionary *domain in netPageUrl) {
        //去除url中空格符
        netUrl = [netUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSURL *url = [NSURL URLWithString:[netUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        NSString *host = [url host];
        if (isStringEmptyOrNil(host)) {
            return NO;
        }
        if ([host isEqualToString:@"apps.apple.com"]) {
            return NO;
        }
        if ([host isEqualToString:[domain objectForKey:@"DOMAIN"]] || [host hasSuffix:[domain objectForKey:@"DOMAIN"]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Public
+ (NSDictionary *)parseParams:(NSString *)query {
    NSArray *components = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[components count]];
    
    NSUInteger i;
    for (i = 0; i < [components count]; i++)
    {
        NSString *component = [components objectAtIndex:i];
        if ([component length] > 0)
        {
            NSRange range = [component rangeOfString:@"="];
            if (range.location != NSNotFound)
            {
                NSString *escapedKey = [component substringToIndex:(range.location + 0)];
                NSString *escapedValue = [component substringFromIndex:(range.location + 1)];
                
                if ([escapedKey length] > 0)
                {
                    NSString *key, *value;
                    key = [escapedKey stringByRemovingPercentEncoding];
                    value = [escapedValue stringByRemovingPercentEncoding];
                    
                    if (key) {
                        if (value){
                            [result setObject:value forKey:key];
                        }else {
                            [result setObject:[NSNull null] forKey:key];
                        }
                    }
                }
            }
        }
    }
    
    return result;
}

// 字符串包含
+ (BOOL)parentString:(NSString *)pString containsString:(NSString *)aString {
    if (!aString || !pString) {
        return NO;
    }
    
    if (!isIOS8Later) {
        if(!isStringEmptyOrNil(pString) && [pString rangeOfString:aString].location != NSNotFound) {
            return YES;
        }
    }else{
        if ([pString containsString:aString]){
            return YES;
        }
    }
    return NO;
}

+ (NSString *)noWhiteSpaceString:(NSString *)str {
    NSString *newString = str;
    //去除掉首尾的空白字符和换行字符
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newString;
}


// 读取本地JSON文件
- (NSDictionary *)loadDefaultJsonWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[DSWebKitGlobal AssetsBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
}

+ (NSBundle *)AssetsBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarWebKit" inPod:@"DarkStarWebKit"];
    });
    return bundle;
}

@end
