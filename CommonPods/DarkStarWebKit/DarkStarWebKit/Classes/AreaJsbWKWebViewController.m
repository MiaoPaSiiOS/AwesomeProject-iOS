//
//  AreaJsbWKWebViewController.m
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/6.
//

#import "AreaJsbWKWebViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <DarkStarNetWorkKit/DarkStarNetWorkKit.h>

#import "AreaJsbWKWebViewController+JSMethods.h"
#import "AreaJsbWKWebViewController+JSApplePay.h"
#import "AresJsbWebTitleView.h"
#import "AresJsbWebErrorView.h"

#import "DSWebKitGlobal.h"
#import "DSWKWebViewCookieManager.h"

#define kAreaJsbWebCallBack  @"webCallBack"
#define kAreaJsbNativeMethod  @"nativeMethod"


@interface AreaJsbWKWebViewController ()<WKNavigationDelegate, WKUIDelegate>
/// 重新加载 url
@property(nonatomic, copy) NSString *strReloadUrl;
/// 加载成功 当前页面URL
@property(nonatomic, copy) NSString *currentURL;
/// 获取原生页面跳到web页面的url
@property(nonatomic, copy) NSString *tmpURL;

#pragma mark - url拦截器
@property(nonatomic, copy) NSString *interceptUrl;
@property(nonatomic, assign) BOOL interceptResult;

#pragma mark - 标题
@property(nonatomic, strong) AresJsbWebTitleView *aTitleView;

#pragma mark - 返回按钮
/// 点击返回按钮时需要调用的 JS 方法
@property(nonatomic, copy) NSString *backJSFunc;
/// 返回加载 URL,meta 标签控制
@property(nonatomic, copy) NSString *gobackLoadUrl;
/// webview 返回时显示关闭标志
@property(nonatomic, assign) BOOL WebPageBack;

#pragma mark - 关闭按钮


#pragma mark - 右上角... meta 标签按钮
@property(nonatomic, strong) UIButton *metaBtn;
@property(nonatomic, strong) UILabel *badgeNumLabel;// 消息数目
@property(nonatomic, strong) NSDictionary *metaDict;// js 调用给到的metaDict


/// 网络原因展示页面
@property(nonatomic, strong) AresJsbWebErrorView *codeErrorView;
/// 加载失败或错误标志
@property(nonatomic, assign) BOOL loadError;

@property(nonatomic, assign) BOOL firstLoad;
@end

@implementation AreaJsbWKWebViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [DSHelper colorWithHexString:@"0xf4f6f8"];
    // 第一次进入展示返回按钮
    self.appBar.leftBarButtonItem = [[DSBarButtonItem alloc] initBackWithTarget:self action:@selector(backToPrev)];
    // Do any additional setup after loading the view.

    // 注册交互
    [self registerOtherWebCode];
    
    //
    self.baseWebView.UIDelegate = self;
    self.baseWebView.navigationDelegate = self;
    
    //
    [self initTitleView];
    [self initMetaBtn];

    self.tmpURL = self.reqModel.requestFullURL;
    self.currentURL = @"";
    
    [self loadRequest];
    
    self.firstLoad = YES;    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 注册通知
    [self registerNotification];
    
    // 更新消息角标
    if (self.metaBtn) {
        [self updateMsgCenterState];
    }
    
    // 刷新
    if (self.reqModel.isNeedReload) {
        [self loadRequest];
    }
    
    // 再次进入
    if (!self.firstLoad) {
        [self webPageReloade];
    }
    
    [self statusBarIsLightContentStyle:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.dsInteractivePopDisabled = self.reqModel.forbiddenGesture;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // 移除通知
    [self resignNotification];

    [self clearInterceptInfo];
    
    self.firstLoad = NO;
}

- (void)dealloc {
    [AresJsbWKWebView setUserAgentWithWKWebView:self.baseWebView];
}

#pragma mark - Nav


#pragma mark - loadRequest
- (void)loadRequest {
    if (self.reqModel.loadType == AresJsbWKWebViewLoadRequest) {
        if (![DSHelper isStringEmptyOrNil:(self.strReloadUrl)]) {
            self.reqModel.requestFullURL = self.strReloadUrl;
        }
        //URL 中含空格将其转码
        if ([self.reqModel.requestFullURL containsString:@" "]) {
            self.reqModel.requestFullURL = [self.reqModel.requestFullURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.reqModel.requestFullURL] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:30];
        [self.baseWebView loadRequest:request];

    } else if (self.reqModel.loadType == AresJsbWKWebViewLoadFileURL) {
        [self.baseWebView loadFileURL:self.reqModel.fileURL allowingReadAccessToURL:self.reqModel.readAccessURL];
        
    } else if (self.reqModel.loadType == AresJsbWKWebViewLoadHTMLString) {
        [self.baseWebView loadHTMLString:self.reqModel.htmlString baseURL:self.reqModel.baseURL];
        
    } else if (self.reqModel.loadType == AresJsbWKWebViewLoadData) {
        [self.baseWebView loadData:self.reqModel.data MIMEType:self.reqModel.MIMEType characterEncodingName:self.reqModel.characterEncodingName baseURL:self.reqModel.baseURL];
    }
}

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // 拦截 window.open(), _blank
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// Alert Method
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    [DSHelper showAlertControllerWithTitle:nil message:message buttonTitles:@[@"确定"] alertClick:^(int clickNumber) {
        
    }];
    completionHandler();
}

// Confirm Panel Method
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    [DSHelper showAlertControllerWithTitle:nil message:message buttonTitles:@[@"取消", @"确定"] alertClick:^(int clickNumber) {
        if (0 == clickNumber) {
            completionHandler(NO);
        } else if (1 == clickNumber) {
            completionHandler(YES);
        }
    }];
}

// Text Input Panel Method
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
        textField.textColor = [UIColor blackColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - WKNavigationDelegate
#pragma mark - 点击链接, 在发送请求之前, 决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //打印请求的全地址
    NSLog(@"==== decidePolicyForNavigationAction url = %@", navigationAction.request.URL.absoluteString);
    self.dsInteractivePopDisabled = YES;
    // 如果是跳转一个新页面, _black
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([navigationAction.request.URL.scheme isEqualToString:@"tel"]) {
        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            NSString *tel = navigationAction.request.URL.absoluteString;
            if ([tel hasPrefix:@"tel://"]) {
                tel = [tel substringFromIndex:6];
            } else if ([tel hasPrefix:@"tel:"]) {
                tel = [tel substringFromIndex:4];
            }

            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    //跳转拦截器
    if ([self interceptLoadingURL:navigationAction.request.URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}


#pragma mark - 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    [DSWKWebViewCookieManager copyWKHTTPCookieStoreToNSHTTPCookieStorageForWebView:webView withResponse:navigationResponse withCompletion:nil];

    self.interceptResult = [self interceptLoadingURL:navigationResponse.response.URL];
    if (self.interceptResult) {
        decisionHandler(WKNavigationResponsePolicyCancel);
        return;
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - WKWebView终止, web内容处理错误 wkwebview内存占用过大时
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    // 初步解决 WKWebView内存过大导致的白屏问题, 在一些高内存消耗的页面可能会频繁刷新当前页面
    [webView reload];
}

#pragma mark - 页面开始加载时调用
- (void)startLoadUrl {
    // 加载时右上角菜单按钮不可以点击
    self.metaDict = nil;
    self.metaBtn.enabled = NO;
    // 移除之前的分享按钮

    // 隐藏之前的标题
    self.aTitleView.hidden = YES;
    
    // 清空之前的通用按钮点击事件

    // 显示返回按钮
    self.appBar.leftBarButtonItem = [[DSBarButtonItem alloc] initBackWithTarget:self action:@selector(backToPrev)];
    
    // 判断是否返回过，返回过显示关闭按钮
    if (self.WebPageBack && !self.dsBackBtnHidden) {
        UIButton *closeBtn = (UIButton *)[self.appBar viewWithTag:23];
        if (!closeBtn || ![closeBtn isDescendantOfView:self.appBar]) {
            [self initCloseBtn];
        } else {
            closeBtn.frame = CGRectMake(15+35,32,31,20);
            closeBtn.centerY = DSDeviceInfo.naviBarContentHeight/2;
        }
    }
    // 清空返回的js
    self.backJSFunc = @"";
    // 清空返回的url
    self.gobackLoadUrl = @"";
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    self.status = WebViewLoadingStatusLoading;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self startLoadUrl];

    self.interceptResult = [self interceptLoadingURL:webView.URL];
    if (self.interceptResult) {
        [self webViewStopLoading];
        return;
    }
}


#pragma mark - 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.status = WebViewLoadingStatusFinish;
    [self loadWebViewResultWithSuccess:YES];
    

    //加载成功时的Url
    kWeakSelf
    [webView evaluateJavaScript:@"document.location.href" completionHandler:^(id _Nullable currentURL, NSError * _Nullable error) {
        kStrongSelf
        if (!error && [currentURL isKindOfClass:[NSString class]]) {
            strongSelf.currentURL = currentURL;
            if (![DSWebKitGlobal parentString:strongSelf.currentURL containsString:@"loadError"] &&
                ![DSWebKitGlobal parentString:strongSelf.currentURL containsString:@"loadNetworkError"]) {
                strongSelf.strReloadUrl = strongSelf.currentURL;
            } else {
                NSString *jsStr = [NSString stringWithFormat:@"setURL('%@')",strongSelf.strReloadUrl];
                [strongSelf.baseWebView evaluateJavaScript:jsStr completionHandler:nil];
            }
        }
    }];
    
    [self.baseWebView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        kStrongSelf
        NSString *titleStr = (title && [title isKindOfClass:[NSString class]]) ? (NSString *)title : @"";
        if(![DSHelper isStringEmptyOrNil:(titleStr)]) {
            if(titleStr.length>8) {
                titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(8,titleStr.length-8) withString:@"..."];
            }
        } else {
            titleStr = @"";
        }
        if([DSHelper isStringEmptyOrNil:(titleStr)]) {
            [strongSelf setupNavTitleView:nil];
        } else {
            NSDictionary * dict = @{@"type":@"1",@"title":[DSHelper safeString:(titleStr)]};
            strongSelf.title = @"";
            strongSelf.aTitleView.showUrl = strongSelf.baseWebView.URL.absoluteString;
            [strongSelf.aTitleView configWithDict:dict];
            [strongSelf setupNavTitleView:nil];
        }
    }];
    
    // 加载结束右上角菜单按钮可以点击
    self.metaBtn.enabled = YES;
    [self setupNavView];
    [self DisplayCloseBtn];//关闭按钮的显示或隐藏
    [self getNativeright];
    [self getBackJSMethod:nil];
    [self getGoBackLoadRequest:nil];
    
    self.loadError = NO;
    
    
    [webView evaluateJavaScript:@"document.onPageShow" completionHandler:^(id _Nullable content, NSError * _Nullable error) {
        NSLog(@"document.onPageShow =  %@, %@", content, error);
    }];
}

//
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.status = WebViewLoadingStatusFinish;
    
    self.metaBtn.enabled = YES;
    [self setupNavView];
    [self setupNavTitleView:nil];
    [self getNativeright];
    
    
    NSDictionary *userInfo = error.userInfo;
    NSString *errorUrl = [userInfo objectForKey:@"NSErrorFailingURLStringKey"];
    if (error.code !=-999 && error.code !=102 &&
        ![errorUrl hasPrefix:@"urlscheme-"] &&
        ![errorUrl hasPrefix:@"mdb://"]) {
        [self loadWebViewResultWithSuccess:NO];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.status = WebViewLoadingStatusFinish;

    self.metaBtn.enabled = YES;
    [self setupNavView];
    [self getNativeright];
    
    NSDictionary *userInfo = error.userInfo;
    NSString *errorUrl = [userInfo objectForKey:@"NSErrorFailingURLStringKey"];
    if (error.code !=-999 && error.code !=102 &&
        ![errorUrl hasPrefix:@"urlscheme-"] &&
        ![errorUrl hasPrefix:@"mdb://"]) {
        [self loadWebViewResultWithSuccess:NO];
    }
}



- (void)setupNavView {
    [self setupBackBtnView:nil];
    [self setupCloseBtnView:nil];
}



#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - URL 拦截处理
- (BOOL)interceptLoadingURL:(NSURL *)loadingURL {
    NSString *strUrl = loadingURL.absoluteString;
    if ([self.interceptUrl isEqualToString:strUrl] && self.interceptResult) {
        return YES;
    }
    self.interceptUrl = strUrl;
    
    // 唤醒拦截
    if([self openOtherApp:loadingURL]) {
        return YES;
    }
    
    // 原生页面拦截
    if ([self gotoNativePage:strUrl]) {
        return YES;
    }
    return NO;
}

- (void)clearInterceptInfo {
    self.interceptUrl = @"";
    self.interceptResult = NO;
}

#pragma mark - 唤醒拦截
- (BOOL)openOtherApp:(NSURL *)url {
    NSURL *tempUrl = url;
    if ([url.absoluteString hasPrefix:@"urlscheme-"]) {
        NSArray *arraystrUrlPara = [url.absoluteString componentsSeparatedByString:@"urlscheme-"];
        NSString *containsUrl = [arraystrUrlPara lastObject];
        tempUrl = [NSURL URLWithString:containsUrl];
    }
    return [self isNeedOpenOtherAppWith:tempUrl];
}

- (BOOL)isNeedOpenOtherAppWith:(NSURL *)url {
    NSString *urlStr = url.absoluteString;
    NSRange range = [urlStr rangeOfString:@"://"];
    if (range.location != NSNotFound) {
        NSString *urlSchemeStr = [urlStr substringToIndex:(range.location + range.length)];
        NSArray *merchantUrlScheme = [DSWebKitGlobal sharedInstance].pageMerchantList;
        if ([merchantUrlScheme containsObject:urlSchemeStr]) { //只要在后台配置的协议白名单中，拦截跳转
            if ([[UIApplication sharedApplication] canOpenURL:url]) { //已经在本地协议白名单中，直接跳转
                [[UIApplication sharedApplication] openURL:url];
            } else { //不在本地协议白名单中，app可能已安装，尝试跳转；如果失败提示未安装
                BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
                if (!isSuccess) {
                    NSString *messageStr = nil;
                    NSDictionary *paramsDic = [DSWebKitGlobal parseParams:url.query];
                    if (paramsDic) {
                        NSString *nameValueStr = paramsDic[@"name"];
                        if ([DSHelper isStringEmptyOrNil:(nameValueStr)]) {
                            messageStr = @"请前往应用市场下载APP";
                        } else {
                            messageStr = nameValueStr;
                        }
                    } else {
                        messageStr = @"请前往应用市场下载APP";
                    }
                    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keywindow animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = [DSHelper safeString:(messageStr)];
                    [hud hideAnimated:YES afterDelay:2.f];
                }
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - 原生页面拦截
- (BOOL)gotoNativePage:(NSString *)strUrl {
    if ([strUrl isEqualToString:@"amen://closeWebPage"]) {
        [self closeWebview];
        return YES;
    }
    
    //不在网络白名单内的
    if (!self.reqModel.closeWhiteList && ![DSWebKitGlobal SpecialIOSListFlag:strUrl] && ![DSWebKitGlobal DomainFlag:strUrl]) {
        NSArray *array = [NSArray arrayWithObjects:@"取消",@"浏览器打开", nil];
        
        NSMutableString *mStr = @"即将打开外部页面，外部页面不受我们控制哦，使用时请注意安全".mutableCopy;
        [mStr appendFormat:@"\n测试环境下信息, 链接:%@", strUrl];
        if (![DSWebKitGlobal DomainFlag:strUrl]) {
            [mStr appendString:@", 该链接不在白名单中"];
        }
        [DSHelper showAlertControllerWithTitle:nil message:mStr.copy buttonTitles:array alertClick:^(int clickNumber) {
            [self clearInterceptInfo];
            if (clickNumber == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
            }
        }];
        return YES;
    }
    return NO;
}

#pragma mark - JS 方法
- (void)webPageReloade {
//    总的来说，这段代码是用于在特定情况下触发一个名为 'pageshow' 的自定义事件，并传递了一个包含 'persisted' 属性的附加信息。这个事件的具体处理方式需要在代码的其他部分进行定义和监听。
    NSString *jsString = @"var event = new CustomEvent('pageshow', {detail:{persisted:'true'}}); window.dispatchEvent(event);";
    [self.baseWebView evaluateJavaScript:jsString completionHandler:^(id _Nullable content, NSError * _Nullable error) {}];
}

#pragma mark - 重写返回键
- (void)backToPrev {
    if(![DSNETShareUtil isConnectionAvailable]) {
        [self commonPopViewController];
        return;
    }
    if (![DSHelper isStringEmptyOrNil:(self.backJSFunc)]) {
        [self.baseWebView evaluateJavaScript:self.backJSFunc completionHandler:nil];
        self.backJSFunc = nil;
        return;
    }
    
    if (![DSHelper isStringEmptyOrNil:(self.gobackLoadUrl)]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.gobackLoadUrl] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:30.f];
        [self.baseWebView loadRequest:request];
        self.gobackLoadUrl = @"";
        return;
    }
    
    if ([self.tmpURL isEqualToString:self.currentURL] || self.baseWebView.backForwardList.backItem == nil) {
        [self commonPopViewController];
        return;
    }
    
    if ([self.baseWebView canGoBack]) {
        self.WebPageBack = YES;
        if (self.loadError) {
            [self.codeErrorView removeFromSuperview];
        }
        [self.baseWebView goBack];
    } else {
        if (self.loadError) {
            [self.codeErrorView removeFromSuperview];
            if ([DSHelper isStringEmptyOrNil:(self.strReloadUrl)]) {
                [self commonPopViewController];
            } else {
                [self loadRequest];
            }
            return;
        }
        [self commonPopViewController];
    }
}

- (void)commonPopViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 注册通知
/// 注册通知
- (void)registerNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    // 截屏通知
    [defaultCenter addObserver:self selector:@selector(userDidTakeScreenshot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    // 录屏通知
    if (@available(iOS 11.0,*)) { // ios11之后才可以录屏
        [defaultCenter addObserver:self selector:@selector(tipsVideoRecord) name:UIScreenCapturedDidChangeNotification object:nil];
    }
    
}

- (void)userDidTakeScreenshot {
    [DSHelper showAlertControllerWithTitle:@"温馨提示" message:@"为保护个人信息安全，请勿分享截屏" buttonTitles:@[@"确定"] alertClick:nil];
}

- (void)tipsVideoRecord {
    if (@available(iOS 11.0,*)) {
        UIScreen * sc = [UIScreen mainScreen];
        if (sc.isCaptured) {
            [DSHelper showAlertControllerWithTitle:@"温馨提示" message:@"为保护个人信息安全，请勿录屏" buttonTitles:@[@"确定"] alertClick:nil];
        }
    }
}


#pragma mark - 清除通知
/// 清除通知
- (void)resignNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    if (@available(iOS 11.0, *)) {
        [defaultCenter removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    }
}


#pragma mark - 加载网页失败时处理
- (void)loadWebViewResultWithSuccess:(BOOL)success {
    self.dsInteractivePopDisabled = self.reqModel.forbiddenGesture;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    //无网络时加载无wifi
    if(![DSNETShareUtil isConnectionAvailable]) {
        // 显示网络错误
        [self loadFailedView:AresJsbWebErrorViewNetworkNotReachable];
    } else {
        if (!success) {
            // 显示加载失败
            [self loadFailedView:AresJsbWebErrorViewServerError];
        }
    }
}

#pragma mark - 网络原因错误页面
- (void)loadFailedView:(AresJsbWebErrorViewType)style {
    kWeakSelf
    self.codeErrorView = [[AresJsbWebErrorView alloc] init];
    self.codeErrorView.type = style;
    [self.codeErrorView setRefreshHandle:^(AresJsbWebErrorView * loadErrorView) {
        kStrongSelf
        [strongSelf.codeErrorView removeFromSuperview];
        [strongSelf loadRequest];
    }];
    self.loadError = YES;
    [self.view addSubview:self.codeErrorView];
}

#pragma mark - 关闭当前 webview(回到跟视图)
- (void)closeWebview {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - JSHandle
- (void)JSHandleMeta:(NSDictionary *)dict {
    [super JSHandleMeta:dict];
//    NSString *nativeMethodStr = [NSString stringWithFormat:@"%@",[dict objectForKey:kAreaJsbNativeMethod]];
//    NSString *callBack = [NSString stringWithFormat:@"%@",[dict objectForKey:kAreaJsbWebCallBack]];
    NSDictionary *paramsDict = [dict objectForKey:@"parameters"];
    NSLog(@"%@",paramsDict);
}


#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 标题 & 逻辑处理
- (void)initTitleView {
    self.aTitleView = [[AresJsbWebTitleView alloc] init];
    self.aTitleView.frame = CGRectMake(0, 0,(380/2.f), (48/2.f));
    self.aTitleView.centerX = self.appBar.centerX;
    self.aTitleView.centerY = 44/2;
    [self.appBar addSubview:self.aTitleView];
    self.aTitleView.hidden = YES;
}

- (void)setupNavTitleView:(NSDictionary *)dict {
    if (dict) {
        NSDictionary *titleInfoDict = [dict objectForKey:@"content"];
        [self navTitleView:titleInfoDict];
    } else {
        kWeakSelf
        [self srsAchiveJSMethodWithName: @"titleInfo" completionHandler:^(NSString * _Nullable str, NSError * _Nullable error) {
            kStrongSelf
            if (!error && [str isKindOfClass:[NSString class]]) {
                NSString *titleInfoStr = [str isKindOfClass:[NSString class]] ? (NSString *)str : @"";
                NSDictionary *aDict = [DSHelper JSON_OBJ_FROM_STRING:titleInfoStr];
                [strongSelf navTitleView:aDict];
                
            }
        }];
    }
}

- (void)navTitleView:(NSDictionary *)dict {
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        self.title = @"";
        self.aTitleView.hidden = NO;
        self.aTitleView.showUrl = self.baseWebView.URL.absoluteString;
        [self.aTitleView configWithDict:dict];
    }
}


#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 关闭按钮 & 处理逻辑
- (void)setupCloseBtnView:(NSDictionary *)dict {
    if (dict) {
        NSDictionary *closeDict = [dict objectForKey:@"content"];
        [self closeBtnView:closeDict];
    } else {
        kWeakSelf
        [self srsAchiveJSMethodWithName: @"closeInfo" completionHandler:^(NSString * _Nullable str, NSError * _Nullable error) {
            kStrongSelf
            if (!error && [str isKindOfClass:[NSString class]]) {
                NSString *closeInfoStr = [str isKindOfClass:[NSString class]] ? (NSString *)str : @"";
                if (closeInfoStr && closeInfoStr.length) {
                    NSDictionary *closeDict = [DSHelper JSON_OBJ_FROM_STRING:closeInfoStr];
                    [strongSelf closeBtnView:closeDict];
                    
                } else {
                    [strongSelf closeBtnView:nil];
                }
            }
        }];
    }
}

- (void)closeBtnView:(NSDictionary *)dict {
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSString *type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
        if ([type isEqualToString:@"1"]) {
            [self isShowCloseBtn:NO];
        } else {
            [self isShowCloseBtn:YES];
        }
    } else {
        if (_WebPageBack && !self.dsBackBtnHidden) {
            [self isShowCloseBtn:YES];
        }else {
            [self isShowCloseBtn:NO];
        }
    }
}

- (void)isShowCloseBtn:(BOOL)isShow {
    if (isShow) {
        UIButton *closeBtn=(UIButton *)[self.appBar viewWithTag:23];
        if (![closeBtn isDescendantOfView:self.appBar]) {
            //关闭按钮
            [self initCloseBtn];
        }else {
            if (self.appBar.leftBarButtonItem) {
                closeBtn.frame = CGRectMake(15+35,32,31,20);
            } else {
                closeBtn.frame = CGRectMake(15,32,31,20);
            }
            closeBtn.centerY = DSDeviceInfo.naviBarContentHeight/2;
        }
    } else {
        UIButton *closeBtn=(UIButton *)[self.appBar viewWithTag:23];
        if ([closeBtn isDescendantOfView:self.appBar]) {
            [closeBtn removeFromSuperview];
        }
    }
}

- (void)DisplayCloseBtn {
    //webview返回时显示关闭按钮
    if (self.WebPageBack && !self.dsBackBtnHidden) {
        UIButton *closeBtn = (UIButton *)[self.appBar viewWithTag:23];
        if (![closeBtn isDescendantOfView:self.appBar]) {
            //关闭按钮
            [self initCloseBtn];
        }
    } else {
        UIButton *closeBtn = (UIButton *)[self.appBar viewWithTag:23];
        if ([closeBtn isDescendantOfView:self.appBar]) {
            [closeBtn removeFromSuperview];
        }
    }
}

- (void)initCloseBtn {
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.tag = 23;
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    if (self.appBar.leftBarButtonItem) {
        closeBtn.frame = CGRectMake(15+35,32,31,20);
    } else {
        closeBtn.frame = CGRectMake(15,32,31,20);
    }
    closeBtn.centerY = DSDeviceInfo.naviBarContentHeight/2;
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn setTitleColor:[DSHelper colorWithHexString:@"0x333333"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action: @selector(closeWebview)forControlEvents:UIControlEventTouchUpInside];
    [self.appBar addSubview:closeBtn];
}


#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 右上角... meta 标签 & 处理逻辑
- (void)initMetaBtn {
    self.metaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.metaBtn.tag = 25;
    self.metaBtn.frame = CGRectMake(DSDeviceInfo.screenWidth-45,0,45,44);
    self.metaBtn.centerY = DSDeviceInfo.naviBarContentHeight/2;
    [self.metaBtn setImageEdgeInsets:UIEdgeInsetsMake(12,10,12,15)];
    [self.metaBtn setImage:[UIImage imageNamed:@"blackPoint"] forState:UIControlStateNormal];
    [self.metaBtn addTarget:self action:@selector(showMetaMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.appBar addSubview:self.metaBtn];

    
    self.badgeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 5,18, 13)];
    self.badgeNumLabel.tag = 6666667;
    self.badgeNumLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeNumLabel.textColor = [UIColor whiteColor];
    self.badgeNumLabel.font = [UIFont systemFontOfSize:9];
    [_metaBtn addSubview:self.badgeNumLabel];
}

/// 更新右上角...状态（小红点和数字是否显示）
- (void)updateMsgCenterState {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 9) {
        self.badgeNumLabel.hidden = NO;
        self.badgeNumLabel.text = @"9+";
    } else if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        self.badgeNumLabel.hidden = NO;
        self.badgeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber];
    } else {
        self.badgeNumLabel.hidden = YES;
    }
}

- (void)getNativeright {
    kWeakSelf
    [self srsAchiveJSMethodWithName: @"nativeright" completionHandler:^(NSString * _Nullable content, NSError * _Nullable error) {
        kStrongSelf
        if (!error && [content isKindOfClass:[NSString class]] && ![DSHelper isStringEmptyOrNil:(content)]) {
//            NSArray *arr = [content ds_JSONValue];
//            if (arr && [arr isKindOfClass:[NSArray class]]) {
//                NSDictionary *dict = [NSDictionary dictionaryWithObject:arr forKey:@"content"];
//                strongSelf.metaDict = dict;
//            }
            
        }
    }];
}
/// 展示右上角...的下拉菜单
- (void)showMetaMenu {

}


#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 返回按钮 & 处理逻辑
/// 获取点击返回键时要加载的URL
- (void)getGoBackLoadRequest:(NSDictionary *)dict {
    if (dict) {
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
        _gobackLoadUrl=str;
    } else {
        
        kWeakSelf
        [self srsAchiveJSMethodWithName: @"gobackPage" completionHandler:^(NSString * _Nullable str, NSError * _Nullable error) {
            kStrongSelf
            if (!error && [str isKindOfClass:[NSString class]]) {
                strongSelf.gobackLoadUrl = str;
            }
        }];
    }
}

/// 获取点击返回键时要执行的JS
- (void)getBackJSMethod:(NSDictionary *)dict {
    if (dict) {
        NSString * backJSFunc = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
        self.backJSFunc = backJSFunc;
    } else {
        kWeakSelf
        [self srsAchiveJSMethodWithName: @"goindex" completionHandler:^(NSString * _Nullable str, NSError * _Nullable error) {
            kStrongSelf
            if (!error && [str isKindOfClass:[NSString class]]) {
                strongSelf.backJSFunc = str;
            }
        }];
    }
}

- (void)setupBackBtnView:(NSDictionary *)dict {
    if (dict) {
        NSDictionary *closeDict = [dict objectForKey:@"content"];
        [self backBtnView:closeDict];
    } else {
        kWeakSelf
        [self srsAchiveJSMethodWithName: @"backInfo" completionHandler:^(NSString * _Nullable str, NSError * _Nullable error) {
            kStrongSelf
            if (!error && [str isKindOfClass:[NSString class]]) {
                NSString *backInfoStr = [str isKindOfClass:[NSString class]] ? (NSString *)str : @"";
                if (backInfoStr && backInfoStr.length) {
                    NSDictionary *closeDict = [DSHelper JSON_OBJ_FROM_STRING:backInfoStr];;
                    [strongSelf backBtnView:closeDict];
                } else {
                    [strongSelf backBtnView:nil];
                }
            }
        }];
    }
}

- (void)backBtnView:(NSDictionary *)dict {
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSString *type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
        if ([type isEqualToString:@"1"]) {
            self.appBar.leftBarButtonItem = nil;
            UIButton *closeBtn=(UIButton *)[self.appBar viewWithTag:23];
            if (closeBtn) {
                closeBtn.frame = CGRectMake(15,32,31,20);
                closeBtn.centerY = DSDeviceInfo.naviBarContentHeight/2;
            }
        } else {
            self.appBar.leftBarButtonItem = [[DSBarButtonItem alloc] initBackWithTarget:self action:@selector(backToPrev)];
            UIButton *closeBtn=(UIButton *)[self.appBar viewWithTag:23];
            if (closeBtn) {
                closeBtn.frame = CGRectMake(15+35,32,31,20);
                closeBtn.centerY = DSDeviceInfo.naviBarContentHeight/2;
            }
        }
    } else {
        self.appBar.leftBarButtonItem = [[DSBarButtonItem alloc] initBackWithTarget:self action:@selector(backToPrev)];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)srsAchiveJSMethodWithName:(NSString *)name completionHandler:(void (^ _Nullable)( NSString * _Nullable, NSError * _Nullable error))completionHandler {
    NSString *str = [NSString stringWithFormat:@"var _elem=document.querySelector('meta[name=\"%@\"]');_elem&&_elem.getAttribute('content')",name];
    [self.baseWebView evaluateJavaScript:str completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            if ([result isKindOfClass:[NSString class]]) {
                completionHandler((NSString *)result,error);
            } else {
                completionHandler(nil,[NSError errorWithDomain:@"获取失败" code:-1 userInfo:nil]);
            }
        }
    }];
}

@end

