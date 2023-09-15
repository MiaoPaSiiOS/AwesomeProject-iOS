//
//  FeedappNetRequest.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "FeedappNetRequest.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "AMENUIDataManager.h"

static NSString * const kWeiBoBaseUrl = @"https://raw.githubusercontent.com/ZiOS-Repo/MockDatas/WeiBo/20220629/";
static NSString * const kTwitterBaseUrl = @"https://raw.githubusercontent.com/ZiOS-Repo/MockDatas/Twitter/20220629/";

@implementation FeedappNetRequest
+ (void)achieveJSONDataWithPath:(NSString *)path
                         branch:(NSString *)branch
                completeHandler:(void(^)(BOOL success, NSDictionary *responseObject))completeHandler {
    NSString *baseUrl = @"";
    if ([branch isEqualToString:@"WeiBo"]) {
        baseUrl = kWeiBoBaseUrl;
    } else if ([branch isEqualToString:@"Twitter"]) {
        baseUrl = kTwitterBaseUrl;
    }
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",baseUrl,path];
    [self _achieveJSONDataWithJsonUrl:fullUrl completeHandler:completeHandler];
}

+ (void)achieveJSONCacheDataWithJsonUrl:(NSString *)path
                                 branch:(NSString *)branch
             completeHandler:(void(^)(BOOL success, NSDictionary *responseObject))completeHandler {
    NSString *baseUrl = @"";
    if ([branch isEqualToString:@"WeiBo"]) {
        baseUrl = kWeiBoBaseUrl;
    } else if ([branch isEqualToString:@"Twitter"]) {
        baseUrl = kTwitterBaseUrl;
    }
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",baseUrl,path];
    [AMENUIDataManager achieveJSONCacheDataWithJsonUrl:fullUrl completeHandler:completeHandler];
}


//https://raw.githubusercontent.com/ZiOS-Repo/MockDatas/JingDong/20220629/functionId/categoryFeeds/result_1.json
+ (void)_achieveJSONDataWithJsonUrl:(NSString *)jsonUrl
                        completeHandler:(void(^)(BOOL success, NSDictionary *datas))completeHandler {
    
    [AMENUIDataManager achieveJSONCacheDataWithJsonUrl:jsonUrl completeHandler:^(BOOL success, NSDictionary *responseObject) {
        if (success) {
            NSLog(@"获取缓存数据成功 %@",jsonUrl);
            if (completeHandler) completeHandler(success,responseObject);
        } else {
            [AMENUIDataManager achieveJSONDataWithJsonUrl:jsonUrl completeHandler:^(BOOL success, NSDictionary *responseObject) {
                if (success) {
                    NSLog(@"获取服务器数据成功 %@",jsonUrl);
                    if (completeHandler) completeHandler(success,responseObject);
                } else {
                    NSLog(@"获取服务器数据失败 %@",jsonUrl);
                    if (completeHandler) completeHandler(NO,nil);
                }
            }];
        }
    }];
}

@end
