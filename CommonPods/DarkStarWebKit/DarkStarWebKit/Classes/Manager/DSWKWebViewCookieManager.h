//
//  DSWKWebViewCookieManager.h
//  AmenWebKit
//
//  Created by zhuyuhui on 2021/12/7.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DSWKWebViewCookieManager : NSObject
+ (NSString *)ajaxCookieScripts;

+ (void)copyWKHTTPCookieStoreToNSHTTPCookieStorageForWebView:(WKWebView *)webView withResponse:(WKNavigationResponse *)navigationResponse withCompletion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
