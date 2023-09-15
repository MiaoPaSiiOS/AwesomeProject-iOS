//
//  AMENUIDataManager.h
//  AmenCore
//
//  Created by zhuyuhui on 2021/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMENUIDataManager : NSObject
//加载本地缓存的数据
+ (void)achieveJSONCacheDataWithJsonUrl:(NSString *)jsonUrl
                        completeHandler:(void(^)(BOOL success, NSDictionary *responseObject))completeHandler;
//加载服务器的数据
+ (void)achieveJSONDataWithJsonUrl:(NSString *)jsonUrl
                   completeHandler:(void(^)(BOOL success, NSDictionary *responseObject))completeHandler;

@end

NS_ASSUME_NONNULL_END
