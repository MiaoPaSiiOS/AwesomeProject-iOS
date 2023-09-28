//
//  AresJsbWKWebView.m
//  Pods
//
//  Created by zhuyuhui on 2021/12/6.
//

#import "AresJsbWKWebView.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "DSWKWebViewCookieManager.h"
#import "DSWebViewCacheManager.h"
@implementation AresJsbWKWebView
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (!configuration) configuration = [[WKWebViewConfiguration alloc] init];
    if (!configuration.userContentController) configuration.userContentController = [[WKUserContentController alloc] init];
    configuration.processPool = [AresJsbWKWebView processPool];
    if (self = [super initWithFrame:frame configuration:configuration]) {
        [self syncAjaxCookie];
    }
    return self;
}
#pragma mark - cookie 缓存
- (WKNavigation *)loadRequest:(NSURLRequest *)request {
    NSMutableURLRequest *muRequest = [DSWebViewCacheManager achiveRequestWithRequest:request];
    [AresJsbWKWebView setUserAgentWithWKWebView:self];
    return [super loadRequest:muRequest];
}

- (WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL {
    [AresJsbWKWebView setUserAgentWithWKWebView:self];
    return [super loadFileURL:URL allowingReadAccessToURL:readAccessURL];
}

- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    [AresJsbWKWebView setUserAgentWithWKWebView:self];
    return [super loadHTMLString:string baseURL:baseURL];
}

- (WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {
    [AresJsbWKWebView setUserAgentWithWKWebView:self];
    return [super loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL];
}



- (void)syncAjaxCookie {
    [self evaluateJavaScript:[DSWKWebViewCookieManager ajaxCookieScripts] completionHandler:^(id _Nullable content, NSError * _Nullable error) {
    }];
}

#pragma mark - UA
+ (void)setUserAgentWithWKWebView:(WKWebView *)wk {
    BOOL isWKWebView = YES;
    if (!wk) {
        isWKWebView = NO;
        wk = [WKWebView new];
    }
    [wk evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable oldAgent, NSError * _Nullable error) {
        [wk class];
        if (!error && [oldAgent isKindOfClass:[NSString class]]) {
            NSString *oldAgentStr = (NSString *)oldAgent;
            NSString *newAgentStr = oldAgentStr;
            if ([oldAgentStr containsString:@"UIWebView"]) {
                if (isWKWebView) newAgentStr = [oldAgentStr stringByReplacingOccurrencesOfString:@"UIWebView" withString:@"WKWebView"];
            } else if ([oldAgentStr containsString:@"WKWebView"]) {
                if (!isWKWebView) newAgentStr = [oldAgentStr stringByReplacingOccurrencesOfString:@"WKWebView" withString:@"UIWebView"];
            } else {
                newAgentStr = [oldAgentStr stringByAppendingString:isWKWebView ? @" WKWebView" : @" UIWebView"];
            }
            
            if (isWKWebView && DSDeviceInfo.isIOS9Later) {
                wk.customUserAgent = newAgentStr;
            }
            //register the new agent
            NSDictionary * dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgentStr, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
            
        }
    }];
}


#pragma mark - process
/**
 通过让所有 WKWebView 共享同一个WKProcessPool实例，可以实现多个 WKWebView 之间共享 Cookie（session Cookie and persistent Cookie）数据。Session Cookie（代指没有设置 expires 的 cookie），Persistent Cookie （设置了 expires 的 cookie）。
 
 另外 WKWebView WKProcessPool 实例在 app 杀进程重启后会被重置，导致 WKProcessPool 中的 session Cookie 数据丢失。
 同样的，如果是存储在 NSHTTPCookieStorage 里面的 SeesionOnly cookie 也会在 app 杀掉进程后清空。
 
 @return processPool
 */
+ (WKProcessPool *)processPool {
    static WKProcessPool *pool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[WKProcessPool alloc] init];
    });
    return pool;
}

@end
