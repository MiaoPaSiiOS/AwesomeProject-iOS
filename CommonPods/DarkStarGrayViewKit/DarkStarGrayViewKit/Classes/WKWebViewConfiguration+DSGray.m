//
//  WKWebViewConfiguration+DSGray.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "WKWebViewConfiguration+DSGray.h"
#import "DSGrayUtil.h"

@implementation WKWebViewConfiguration (DSGray)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [WKWebViewConfiguration class];
        
        Method setUserContentControllerMethod = class_getInstanceMethod(class, @selector(setUserContentController:));
        Method setGrayUserContentControllerMethod = class_getInstanceMethod(class, @selector(setGrayUserContentController:));
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(setUserContentController:) oriMethod:setUserContentControllerMethod swizzledSel:@selector(setGrayUserContentController:) swizzledMethod:setGrayUserContentControllerMethod oriClass:class];
    });
}

- (void)setGrayUserContentController:(WKUserContentController *)userContentController {
    if (userContentController && [DSGrayManager shared].grayViewEnabled) {
        NSString *js = @"function setGrayStyle(newStyle) {\
        var styleElement = document.getElementById('styles_js');\
        if (!styleElement) {\
        styleElement = document.createElement('style');\
        styleElement.type = 'text/css';\
        styleElement.id = 'styles_js';\
        document.getElementsByTagName('head')[0].appendChild(styleElement);\
        }\
        styleElement.appendChild(document.createTextNode(newStyle));\
        }\
        window.onload = setGrayStyle('html {\
        -webkit-filter: grayscale(1);\
        -moz-filter: grayscale(1);\
        -ms-filter: grayscale(1);\
        -o-filter: grayscale(1);\
        filter: grayscale(1);\
        filter: progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);\
        }');\
        ";
        WKUserScript *jsUserScript = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userContentController addUserScript:jsUserScript];
    }
    [self setGrayUserContentController:userContentController];
}


@end
