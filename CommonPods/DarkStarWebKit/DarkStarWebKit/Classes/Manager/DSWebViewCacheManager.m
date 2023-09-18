//
//  DSWebViewCacheManager.m
//  AmenWebKit
//
//  Created by zhuyuhui on 2021/12/6.
//

#import "DSWebViewCacheManager.h"
#import <WebKit/WebKit.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "DSWebKitGlobal.h"
@implementation DSWebViewCacheManager

+ (NSMutableURLRequest *)achiveRequestWithRequest:(NSURLRequest *)request {
    return [self achiveRequestWithURL:request.URL timeoutInterval:request.timeoutInterval];
}

+ (NSMutableURLRequest *)achiveRequestWithURL:(NSURL *)url timeoutInterval:(NSTimeInterval)timeInterval {
    NSString *requestUrl = safeString(url.absoluteString);
    NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ENABLE_WEB_CACHE_IOS"]];
    
    if ([str isEqualToString:@"1"] &&
        [DSWebKitGlobal sharedInstance].webCacheWhiteList &&
        [[DSWebKitGlobal sharedInstance].webCacheWhiteList isKindOfClass:[NSArray class]]) { // 总开关打开
        for (NSDictionary *aDict in [DSWebKitGlobal sharedInstance].webCacheWhiteList) {
            if (aDict && [aDict isKindOfClass:[NSDictionary class]]) {
                NSString *str = [NSString stringWithFormat:@"%@",aDict[@"DOMAIN"]];
                if ([requestUrl hasPrefix:str]) {
                    NSDictionary *trackDict = @{
                        @"cache_url":safeString(requestUrl),
                        @"desc":@"webview缓存白名单列表"
                    };
                    NSLog(@"%@",trackDict);
                    //
                    /*
                     NSURLRequestUseProtocolCachePolicy(默认缓存策略)
                     具体工作：如果一个NSCachedURLResponse对于请求并不存在，数据将会从源端获取。如果请求拥有一个缓存的响应，那么URL加载系统会检查这个响应来决定，如果它指定内容必须重新生效的话。假如内容必须重新生效，将建立一个连向源端的连接来查看内容是否发生变化。假如内容没有变化，那么响应就从本地缓存返回数据。如果内容变化了，那么数据将从源端获取.
                     */
                    cachePolicy = NSURLRequestUseProtocolCachePolicy;
                }
            }
        }
    } else {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    NSMutableURLRequest *muRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:timeInterval];
    return muRequest;
}

+ (void)deleteAllWebViewCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
           NSSet *websiteDataTypes= [NSSet setWithArray:@[
              WKWebsiteDataTypeDiskCache,//硬盘缓存
              //WKWebsiteDataTypeOfflineWebApplication,
              WKWebsiteDataTypeMemoryCache,//内存缓存
              //WKWebsiteDataTypeLocal
              //WKWebsiteDataTypeCookies,
              //WKWebsiteDataTypeSessionStorage,
              //WKWebsiteDataTypeIndexedDBDatabases,
              //WKWebsiteDataTypeWebSQLDatabases
           ]];
           
           NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
           [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
               
           }];
           [[NSURLCache sharedURLCache] removeAllCachedResponses];
           
       } else {

           NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
           NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                   objectForKey:@"CFBundleIdentifier"];
           NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
           NSString *webKitFolderInCaches = [NSString
                                             stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
           NSString *webKitFolderInCachesfs = [NSString
                                               stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
           NSError *error;
           /* iOS8.0 WebView Cache的存放路径 */
           [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
           [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
           /* iOS7.0 WebView Cache的存放路径 */
           [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
           
           [[NSURLCache sharedURLCache] removeAllCachedResponses];
       }
}


+ (void)deleteAllCookies {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
           NSSet *websiteDataTypes= [NSSet setWithArray:@[
              //WKWebsiteDataTypeDiskCache,//硬盘缓存
              //WKWebsiteDataTypeOfflineWebApplication,//离线应用缓存
              //WKWebsiteDataTypeMemoryCache,//内存缓存
              //WKWebsiteDataTypeLocalStorage,//localStorage,cookie的一个兄弟
              WKWebsiteDataTypeCookies,//cookie
              //WKWebsiteDataTypeSessionStorage,//session
              //WKWebsiteDataTypeIndexedDBDatabases,//索引数据库
              //WKWebsiteDataTypeWebSQLDatabases,//数据库
           ]];
           
           NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
           [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
               
           }];
           [[NSURLCache sharedURLCache] removeAllCachedResponses];
           
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [libraryPath stringByAppendingPathComponent:@"Cookies/Cookies.binarycookies"];
        if (filePath && filePath.length > 0) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
        }
    }
    
}

@end
