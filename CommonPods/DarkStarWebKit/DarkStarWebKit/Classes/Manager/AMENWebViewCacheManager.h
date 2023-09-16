//
//  AMENWebViewCacheManager.h
//  AmenWebKit
//
//  Created by zhuyuhui on 2021/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMENWebViewCacheManager : NSObject

+ (NSMutableURLRequest *)achiveRequestWithRequest:(NSURLRequest *)request;
+ (NSMutableURLRequest *)achiveRequestWithURL:(NSURL *)url timeoutInterval:(NSTimeInterval)timeInterval;

+ (void)deleteAllWebViewCache;

+ (void)deleteAllCookies;

@end

NS_ASSUME_NONNULL_END
