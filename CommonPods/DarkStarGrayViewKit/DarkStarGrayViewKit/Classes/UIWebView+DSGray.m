//
//  UIWebView+DSGray.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "UIWebView+DSGray.h"
#import "DSGrayUtil.h"

@implementation UIWebView (DSGray)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [UIWebView class];
        
        Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"webView:resource:didFinishLoadingFromDataSource:"));
        Method swizzledMethod = class_getInstanceMethod(class, @selector(swizzled_webView:resource:didFinishLoadingFromDataSource:));
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:NSSelectorFromString(@"webView:resource:didFinishLoadingFromDataSource:") oriMethod:originalMethod swizzledSel:@selector(swizzled_webView:resource:didFinishLoadingFromDataSource:) swizzledMethod:swizzledMethod oriClass:class];
    });
}

- (void)swizzled_webView:(id)arg1 resource:(id)arg2 didFinishLoadingFromDataSource:(id)arg3 {
    if ([DSGrayManager shared].grayViewEnabled) {
        [self grayWebaction:arg1];
    }
    [self swizzled_webView:arg1 resource:arg2 didFinishLoadingFromDataSource:arg3];
}

- (void)grayWebaction:(UIWebView *)web {
    NSString *params = @"var filter = '-webkit-filter:grayscale(100%);\
    -moz-filter:grayscale(100%);\
    -ms-filter:grayscale(100%);\
    -o-filter:grayscale(100%);\
    filter:grayscale(100%);';\
    document.getElementsByTagName('html')[0].style.filter = 'grayscale(100%)';\
    ";
    [web stringByEvaluatingJavaScriptFromString:params];
}

@end
