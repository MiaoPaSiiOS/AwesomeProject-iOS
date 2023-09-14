//
//  NSString+RERouter.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "NSString+RERouter.h"
#import "HJJsonKit.h"
#import "RERouterDefines.h"

@implementation NSString (router)

+ (NSDictionary *)getDictFromJsonString:(NSString *)aJsonString
{
    //urldecode
    NSString *jsonString = [aJsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    NSArray *params = [jsonString componentsSeparatedByString:@"&"];
    
//    for (NSString *subString in params) {
        NSArray *subStrings = [jsonString componentsSeparatedByString:@"="];
        if ([RERouterParamKey isEqualToString:subStrings[0]]) {
            if (subStrings[1]) {
                NSRange range=[jsonString rangeOfString:@"="];
                //除去body＝剩下纯json格式string
                NSString*jsonStr=[jsonString substringFromIndex:range.location+1];
                NSDictionary *resultDict = [HJJsonKit dictFromString:jsonStr];
                dict[RERouterParamKey] = resultDict;
            }
        }
//    }
    
    [dict.copy enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            dict[key] = [obj stringValue];
        }
    }];
    
    if  (!dict[RERouterParamKey])
        dict[RERouterParamKey] = @{};
    return dict;
}

+ (NSString *)getRouterUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params
{
    NSString *json = [HJJsonKit stringFromDict:params];
    
    if (!json) {
        return urlString;
    }
    
    NSString *jsonString = [urlString stringByAppendingFormat:@"?%@=%@",RERouterParamKey,json];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)getRouterVCUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params
{
    return [self getRouterUrlStringFromUrlString:[NSString stringWithFormat:@"%@://%@",CONSTANT,urlString] andParams:params];
}

+ (NSString *)getRouterFunUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params
{
    return [self getRouterUrlStringFromUrlString:[NSString stringWithFormat:@"hjiosfun://%@",urlString] andParams:params];
}

@end
