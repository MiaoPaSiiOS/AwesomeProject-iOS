//
//  AreaJsbWKWebViewController.h
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/6.
//

#import "AmenJsbWKWebViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AmenJsbWKWebViewLoadRequest,
    AmenJsbWKWebViewLoadFileURL,
    AmenJsbWKWebViewLoadHTMLString,
    AmenJsbWKWebViewLoadData,
} AmenJsbWKWebViewLoad;


@interface AreaJsbWKWebViewController : AmenJsbWKWebViewController
/// 重新加载 url
@property(nonatomic, copy) NSString *strReloadUrl;
/// 加载成功时记录当前页面URL
@property(nonatomic, copy, readonly) NSString *currentURL;

/// 是否需要重新加载，如果为YES，则在viewWillAppe:时候重新执行loadRequest
@property(nonatomic, assign) BOOL isNeedReload;
/// 是否禁用侧滑返回
@property(nonatomic, assign) BOOL forbiddenGesture;
/// 是否关闭白名单, 默认为 NO;
@property(nonatomic, assign) BOOL closeWhiteList;
#pragma mark - 加载方式
@property(nonatomic, assign) AmenJsbWKWebViewLoad loadType;
@property(nonatomic, strong) NSString *requestFullURL;
@property(nonatomic, strong) NSURL *fileURL;
@property(nonatomic, strong) NSURL *readAccessURL;
@property(nonatomic, strong) NSString *htmlString;
@property(nonatomic, strong) NSURL *baseURL;
@property(nonatomic, strong) NSData *data;
@property(nonatomic, strong) NSString *MIMEType;
@property(nonatomic, strong) NSString *characterEncodingName;
@end



NS_ASSUME_NONNULL_END
