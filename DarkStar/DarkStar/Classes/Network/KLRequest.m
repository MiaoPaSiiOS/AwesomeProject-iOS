//
//  KLRequest.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/8.
//

#import "KLRequest.h"

@implementation KLRequest
/**
 *  功能:初始化方法
 */
+ (instancetype)createReqWithUrl:(NSString *)urlPath
                          header:(NSDictionary *)header
                          params:(NSDictionary *)params
                     requestType:(AmenNetworkRequestType)requestType;
 {
     KLRequest *request = [self new];
     request.urlPath = urlPath;
     request.requestType = requestType;
     request.header = header ? header : @{};
     request.params = params ? params : @{};
     request.timeoutInterval = 30;
     return request;
}
@end
