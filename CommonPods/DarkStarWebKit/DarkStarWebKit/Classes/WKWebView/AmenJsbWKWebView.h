//
//  AmenJsbWKWebView.h
//  Pods
//
//  Created by zhuyuhui on 2021/12/6.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AmenJsbWKWebView : WKWebView
+ (void)setUserAgentWithWKWebView:(WKWebView *)wk;
@end

NS_ASSUME_NONNULL_END
