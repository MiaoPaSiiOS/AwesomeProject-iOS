//
//  AresJsbWKWebViewController.h
//  Pods
//
//  Created by zhuyuhui on 2021/12/6.
//

#import <DarkStarUIKit/DarkStarUIKit.h>
#import "AresJsbWKWebView.h"
#import "WebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, WebViewLoadingStatus) {
    WebViewLoadingStatusBegin,
    WebViewLoadingStatusLoading,
    WebViewLoadingStatusFinish
};

@interface AresJsbWKWebViewController : DSViewController
/// baseWebView
@property(nonatomic, strong, readonly) AresJsbWKWebView *baseWebView;
/// 加载状态
@property(nonatomic, assign) WebViewLoadingStatus status;

#pragma mark - Public
- (void)webViewStopLoading;

#pragma mark - JS & Native互调
- (void)registerHandler:(NSString*)handlerName handler:(nullable WVJBHandler)handler;
- (void)removeHandler:( NSString* )handlerName;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(nullable id)data;
- (void)callHandler:(NSString*)handlerName data:(nullable id)data responseCallback:(nullable  WVJBResponseCallback)responseCallback;

- (void)JSHandleMeta:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
