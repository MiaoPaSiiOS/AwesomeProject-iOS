//
//  FeedappNetRequest.h
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedappNetRequest : NSObject

/// 获取数据{优先获取缓存数据，没有缓存数据，就去接口请求}
/// @param path path description
/// @param branch branch description  "WeiBo"  "Twitter"
/// @param completeHandler completeHandler description
+ (void)achieveJSONDataWithPath:(NSString *)path
                         branch:(NSString *)branch
                completeHandler:(void(^)(BOOL success, NSDictionary *responseObject))completeHandler;

/// 获取缓存数据
/// @param path path description
/// @param branch branch description "WeiBo"  "Twitter"
/// @param completeHandler completeHandler description
+ (void)achieveJSONCacheDataWithJsonUrl:(NSString *)path
                                 branch:(NSString *)branch
                        completeHandler:(void(^)(BOOL success, NSDictionary *responseObject))completeHandler;

@end

NS_ASSUME_NONNULL_END
