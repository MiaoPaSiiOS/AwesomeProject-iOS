//
//  AMENUIDataManager.m
//  AmenCore
//
//  Created by zhuyuhui on 2021/11/19.
//

#import "AMENUIDataManager.h"
#import "DarkStarNetWorkKit.h"
#import "DarkStarGeneralTools.h"
#import "AmenFeedTool.h"
static NSString * const kUIDataPageFold = @"UI_Data_Page_Cache";

@interface AMENUIDataManager()

@end

@implementation AMENUIDataManager

+ (void)achieveJSONCacheDataWithJsonUrl:(NSString *)jsonUrl
             completeHandler:(void(^)(BOOL success, NSDictionary *responseObject))completeHandler {
    NSString *fileName = [AmenFeedTool qmui_md5:jsonUrl];
    NSString *filePath = [self jsonCacheDataPath:fileName];
    [DSBTFileHelp asyncFetchFileAsString:filePath complete:^(id  _Nullable content) {
        if (!content || ![content isKindOfClass:[NSString class]]) {
            if (completeHandler) {
                completeHandler(NO, nil);
            }
            // 删除缓存数据
            [DSBTFileHelp asyncRemoveItemAtPath:filePath complete:nil];
            return;
        }
        NSDictionary *dictionary = [self dictionaryWithJsonString:content];
        if (completeHandler) {
            completeHandler(YES, dictionary);
        }
    }];
}

+ (void)achieveJSONDataWithJsonUrl:(NSString *)jsonUrl
             completeHandler:(void(^)(BOOL success, NSDictionary *responseObject))completeHandler {
    NSString *fileName = [AmenFeedTool qmui_md5:jsonUrl];
    NSString *filePath = [self jsonCacheDataPath:fileName];
    [[DSNetWorkManager sharedInstance] dataTaskWithUrlPath:jsonUrl requestType:DSNetworkRequestTypeGET header:@{} params:@{} completionHandler:^(DSNetResponse *response) {
        if (response.success) {
            if (response.responseObject) {
                if (![DSBTFileHelp isExistsAtPath:filePath]) {
                    [DSBTFileHelp createFileAtPath:filePath];
                }
                NSDictionary *resDic = @{};
                if ([response.responseObject isKindOfClass:NSDictionary.class]) {
                    resDic = response.responseObject;
                } else if ([response.responseObject isKindOfClass:NSArray.class]) {
                    resDic = @{@"data":response.responseObject};
                }
                
                [DSBTFileHelp asyncWriteFileAtPath:filePath content:[self JSONString:resDic] complete:nil];
                if (completeHandler) {
                    completeHandler(YES, response.responseObject);
                }
            } else {
                if (completeHandler) {
                    completeHandler(NO, nil);
                }
            }
        } else {
            if (completeHandler) {
                completeHandler(NO, nil);
            }
        }
    }];
}




#pragma mark - Private Method
+ (NSString *)cacheJSONDataFoldPath {
    if (![DSBTFileHelp isExistsAtPath:[[DSBTFileHelp documentsDir] stringByAppendingPathComponent:kUIDataPageFold]]) {
        [DSBTFileHelp createDirectoryAtPath:[[DSBTFileHelp documentsDir] stringByAppendingPathComponent:kUIDataPageFold]];
    }
    return [[DSBTFileHelp documentsDir] stringByAppendingPathComponent:kUIDataPageFold];
}

/// page
+ (NSString *)jsonCacheDataPath:(NSString *)fileName {
    if (!fileName || fileName.length <= 0) return @"";
    return [[self cacheJSONDataFoldPath] stringByAppendingPathComponent:fileName];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;

    }
    return obj;
}

+ (NSString *)JSONString:(NSDictionary *)obj {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (str.length) {
            return str;
        }
    }

    return @"";
}

+ (NSString *)base64Encode:(NSString *)data{
    if (!data) {
        return nil;
    }
    NSData *sData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [sData base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}
 
+ (NSString *)base64Dencode:(NSString *)data{
    if (!data) {
        return nil;
    }
    NSData *sData = [[NSData alloc]initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *dataString = [[NSString alloc]initWithData:sData encoding:NSUTF8StringEncoding];
    return dataString;
}

@end
