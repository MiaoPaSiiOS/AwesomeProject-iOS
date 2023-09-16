//
//  AmenJsbWKWebViewCookieManager.m
//  AmenWebKit
//
//  Created by zhuyuhui on 2021/12/7.
//

#import "AmenJsbWKWebViewCookieManager.h"
static NSString* const PAWKCookiesKey = @"org.skyfox.PAWKShareInstanceCookies";

@implementation AmenJsbWKWebViewCookieManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AmenJsbWKWebViewCookieManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

+ (NSString *)ajaxCookieScripts {
    @autoreleasepool {
        NSArray *cookieArr = [[AmenJsbWKWebViewCookieManager sharedInstance] sharedHTTPCookieStorage];
        NSMutableArray *cookieStringMarr = [NSMutableArray array];
        NSString *ajaxCookieScriptsString;
        for (NSHTTPCookie *cookie in cookieArr) {
            NSMutableString *cookieString = [NSMutableString string];
            [cookieString appendString:[NSString stringWithFormat:@"document.cookie = '%@=%@';",cookie.name,cookie.value]];
            [cookieStringMarr addObject:cookieString];
        }
        ajaxCookieScriptsString = [cookieStringMarr componentsJoinedByString:@""];
        return ajaxCookieScriptsString;
    }
}

+ (void)copyWKHTTPCookieStoreToNSHTTPCookieStorageForWebView:(WKWebView *)webView withResponse:(WKNavigationResponse *)navigationResponse withCompletion:(void (^)(void))completion {
    if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore *cookieStore = webView.configuration.websiteDataStore.httpCookieStore;
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        if (cookies.count == 0) return;
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStore setCookie:cookie completionHandler:^{
                if ([cookies.lastObject isEqual:cookie]) {
                    if (completion) {
                        completion();
                    }
                }
            }];
        }
    } else {
        // Fallback on earlier versions
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
        if ([response.URL.scheme.lowercaseString containsString:@"http"]) {
            NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
            //存储cookies
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                @try{
                    //存储cookies
                    for (NSHTTPCookie *cookie in cookies) {
                        [self insertCookie:cookie forWebView:webView];
                    }
                } @catch (NSException *e) {
                    NSLog(@"failed: %@", e);
                } @finally {
                    
                }
            });
        }
    }
}

+ (void)insertCookie:(NSHTTPCookie *)cookie forWebView:(WKWebView *)webView {
    @autoreleasepool {
        NSHTTPCookieStorage * shareCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [shareCookie setCookie:cookie];
        
        NSMutableArray *TempCookies = [NSMutableArray array];
        NSMutableArray *localCookies =[NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: PAWKCookiesKey]];
        for (int i = 0; i < localCookies.count; i++) {
            NSHTTPCookie *TempCookie = [localCookies objectAtIndex:i];
            if ([cookie.name isEqualToString:TempCookie.name] &&
                [cookie.domain isEqualToString:TempCookie.domain]) {
                [localCookies removeObject:TempCookie];
                i--;
                break;
            }
        }
        [TempCookies addObjectsFromArray:localCookies];
        [TempCookies addObject:cookie];
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: TempCookies];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:PAWKCookiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (NSMutableArray *)sharedHTTPCookieStorage {
    @autoreleasepool {
        NSMutableArray *cookiesArr = [NSMutableArray array];
        /** 获取NSHTTPCookieStorage cookies  WKHTTPCookieStore 的cookie 已经同步*/
        NSHTTPCookieStorage * shareCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in shareCookie.cookies){
            [cookiesArr addObject:cookie];
        }
        
        /** 获取自定义存储的cookies */
        NSMutableArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: PAWKCookiesKey]];
        
        //删除过期的cookies
        for (int i = 0; i < cookies.count; i++) {
            NSHTTPCookie *cookie = [cookies objectAtIndex:i];
            if (!cookie.expiresDate) {
                [cookiesArr addObject:cookie]; //当cookie不设置过期时间时，视cookie的有效期为长期有效。
                continue;
            }
            if ([cookie.expiresDate compare:self.currentTime]) {
                [cookiesArr addObject:cookie];
            } else {
                [cookies removeObject:cookie]; //清除过期的cookie。
                i--;
            }
        }
        
        //存储最新有效的cookies
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: cookies];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:PAWKCookiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return cookiesArr;
    }
}


- (NSDate *)currentTime {
    return [NSDate dateWithTimeIntervalSinceNow:0];
}
@end
