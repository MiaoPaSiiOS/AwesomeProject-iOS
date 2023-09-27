//
//  AresJsbWKWebViewController.m
//  Pods
//
//  Created by zhuyuhui on 2021/12/6.
//

#import "AresJsbWKWebViewController.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <Masonry/Masonry.h>
@interface AresJsbWKWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property(nonatomic, strong, readwrite) AresJsbWKWebView *baseWebView;

@property(nonatomic, strong) WKWebViewConfiguration *configuration;

@property(nonatomic, strong) WKUserContentController *userContentController;

/// 进度条
@property(nonatomic, strong) UIProgressView *progressView;
/// H5标志，方便查看是否是H5页面
@property(nonatomic, strong) UILabel *typeLabel;

@property(nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation AresJsbWKWebViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)dealloc {
    [self.baseWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.baseWebView stopLoading];
    self.baseWebView.scrollView.delegate = nil;
    self.baseWebView.UIDelegate = nil;
    self.baseWebView.navigationDelegate = nil;
    self.userContentController = nil;
    self.baseWebView = nil;
    NSLog(@"%s",__FUNCTION__);
}



#pragma mark - 监察进度条和标题
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.baseWebView) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            if (self.baseWebView.URL.absoluteString.length || self.baseWebView.estimatedProgress<1.f) {
                self.progressView.hidden = NO;
            }
            BOOL animated = self.baseWebView.estimatedProgress > self.progressView.progress;
            [self.progressView setProgress:self.baseWebView.estimatedProgress animated:animated];
            if (self.baseWebView.estimatedProgress >= 1.0) {
                [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.progressView.hidden = YES;
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
    }
}

#pragma mark - Initialize UI
- (void)setupViews {
#pragma mark - 网页标志
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.text = @"此网页为WKWebView";
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.font = [UIFont fontWithName:@"American Typewriter" size:12];
    self.typeLabel.textColor = [UIColor darkGrayColor];
    self.typeLabel.hidden = YES;
    [self.dsView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_offset(0);
        make.height.mas_equalTo(50);
    }];
    
#pragma mark - WKWebView
    self.userContentController = [[WKUserContentController alloc] init];
    
    self.configuration = [[WKWebViewConfiguration alloc] init];
    self.configuration.userContentController = self.userContentController;
    self.configuration.preferences = [[WKPreferences alloc] init];
    self.configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    self.configuration.allowsInlineMediaPlayback = YES;// 允许内联播放
    if (@available(iOS 10.0, *)) {
        self.configuration.mediaTypesRequiringUserActionForPlayback = NO;// 允许自动播放背景音乐
    } else {
        // Fallback on earlier versions
    }
    
    self.baseWebView = [[AresJsbWKWebView alloc] initWithFrame:self.dsView.bounds configuration:self.configuration];
    [self.baseWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.baseWebView setOpaque:NO];//开启手势触摸
    [self.baseWebView setBackgroundColor:[UIColor clearColor]];
    [self.baseWebView setAllowsLinkPreview:NO];
    [self.baseWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.baseWebView sizeToFit]; //适应你设定的尺寸
    self.baseWebView.scrollView.delegate = self;
    self.baseWebView.navigationDelegate = self;
    [self.dsView addSubview:self.baseWebView];
    [self.baseWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    
    //WebViewJavascriptBridge
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.baseWebView];
    self.bridge.consolePipeBlock = ^(id  _Nonnull water) {
        NSLog(@"Next line is javascript console.log------>>>>");
        NSLog(@"%@",water);
    };
    
    
#pragma mark - 进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.tintColor = [DSCommonMethods colorWithHexString:@"0x4586ff"];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.hidden = YES;
    [self.appBar addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];

}


#pragma mark - Public
- (void)webViewStopLoading {
    [self.baseWebView stopLoading];
    self.progressView.hidden = YES;
    [self.progressView setProgress:0.0];
}

#pragma mark - JS & Native互调
- (void)registerHandler:(NSString*)handlerName handler:(nullable WVJBHandler)handler {
    [_bridge registerHandler:handlerName handler:handler];
}
- (void)removeHandler:( NSString* )handlerName {
    [_bridge removeHandler:handlerName];
}
- (void)callHandler:(NSString*)handlerName {
    [_bridge callHandler:handlerName];
}
- (void)callHandler:(NSString*)handlerName data:(nullable id)data {
    [_bridge callHandler:handlerName data:data];
}
- (void)callHandler:(NSString*)handlerName data:(nullable id)data responseCallback:(nullable  WVJBResponseCallback)responseCallback {
    [_bridge callHandler:handlerName data:data responseCallback:responseCallback];
}

- (void)JSHandleMeta:(NSDictionary *)dict {
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -26) {
        self.typeLabel.hidden = NO;
    } else {
        self.typeLabel.hidden = YES;
    }
}

@end
