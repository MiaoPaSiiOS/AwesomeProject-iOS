//
//  RERouter.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "RERouter.h"
#import "RERouterDefines.h"
//#import "NSString+RE.h"
//#import "NSDictionary+RE.h"
//#import "UIViewController+RERouter.h"

@interface RERouter ()

@property (nonatomic, strong) NSMutableDictionary *mapping;
@property (nonatomic, strong) NSMutableDictionary *nativeFuncMapping;
@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic) HJPlatformType platformType;
@property (nonatomic, assign) long lastPageTime;

@end

@implementation RERouter

+ (instancetype)singletonInstance
{
    static RERouter *router = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        router = [NSClassFromString(@"PhoneRouter") new];
        if (!router) {
            router = [NSClassFromString(@"PadRouter") new];
            router.platformType = HJPlatformTypePad;
        }
    });
    return router;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.mapping = [NSMutableDictionary dictionary];
        self.nativeFuncMapping = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerClass:(Class)aClass key:(NSString *)aKey
{
    HJMappingVO *vo = [HJMappingVO new];
    vo.createdType = HJMappingClassCreateByCode;
    vo.className = NSStringFromClass(aClass);
    [self registerRouterVO:vo withKey:aKey];
}

- (void)registerRouterVO:(HJMappingVO *)aVO withKey:(NSString *)aKeyName
{
    aKeyName = [aKeyName lowercaseString];
    if (self.mapping[aKeyName]) {
        NSLog(@"overwrite router vo key[%@], mapping vo,%@", aKeyName, self.mapping[aKeyName]);
    }
    self.mapping[aKeyName] = aVO;
}

- (void)registerNativeFuncVO:(RERouterVO *)aVO withKey:(NSString *)aKeyName
{
    aKeyName = [aKeyName lowercaseString];
    if (self.nativeFuncMapping[aKeyName]) {
        NSLog(@"overwrite native func vo key[%@], mapping vo,%@", aKeyName, self.nativeFuncMapping[aKeyName]);
    }
    self.nativeFuncMapping[aKeyName] = aVO;
}
//nieyongqiang
- (id)routerWithUrlString:(NSString *)aUrlString navigationController:(UINavigationController *)nc animated:(BOOL)animated;
{
    //nieyongqiang
    return [self routerWithUrlString:aUrlString navigationController:nc callbackBlock:nil animated:animated];
}

- (id)routerWithUrlString:(NSString *)aUrlString navigationController:(UINavigationController *)nc;
{
    return [self routerWithUrlString:aUrlString navigationController:nc callbackBlock:nil];
}
//nieyongqiang
- (id)routerWithUrlString:(NSString *)aUrlString navigationController:(UINavigationController *)nc callbackBlock:(RERouterVOBlock)aBlock animated:(BOOL)animated
{
    NSLog(@"aUrlString = %@", aUrlString.urlDecoding);
    //nieyongqiang
    return [self routerWithUrl:[NSURL URLWithString:aUrlString] navigationController:nc callbackBlock:aBlock animated:animated];
}

- (id)routerWithUrlString:(NSString *)aUrlString navigationController:(UINavigationController *)nc callbackBlock:(RERouterVOBlock)aBlock
{
    if ([aUrlString containsString:@"{"] ||
        [aUrlString containsString:@"\""])
    {
        aUrlString = aUrlString.urlEncoding;
    }

    NSURL * url = [NSURL URLWithString:aUrlString];

    NSLog(@"aUrlString = %@", aUrlString.urlDecoding);
    return [self routerWithUrl:url navigationController:nc callbackBlock:aBlock];
}

-(BOOL)isInMapping:(NSString *)urlString
{
    if( urlString == nil || ![urlString isKindOfClass:[NSString class]])
    {
        return NO;
    }

    if ([urlString containsString:@"{"] ||
        [urlString containsString:@"\""])
    {
        urlString = urlString.urlEncoding;
    }

    NSURL   *aUrl = [NSURL URLWithString:urlString];
    if (aUrl == nil)
    {
        NSString* string = [urlString urlEncoding];
        aUrl = [NSURL URLWithString:string];
        if( aUrl == nil )
        {
            return NO;
        }
    }

    NSString *host = [aUrl.host lowercaseString];
    
    HJMappingVO *mappingVO = [self.mapping objectForCaseInsensitiveKey:host];
    
    if (!mappingVO)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//nieyongqiang
- (id)routerWithUrl:(NSURL *)aUrl navigationController:(UINavigationController *)nc callbackBlock:(RERouterVOBlock)aBlock animated:(BOOL)animated
{
    if (!aUrl) {
        NSLog(@"router error url");
        return nil;
    }
    
    NSString *scheme = aUrl.scheme;
    NSString *host = [aUrl.host lowercaseString];
    NSString *query = aUrl.query;
    
    NSMutableDictionary *params = ((NSDictionary *)([NSString getDictFromJsonString:query][RERouterParamKey])).mutableCopy;
    params[RERouterFromHostKey] = host;
    params[RERouterFromSchemeKey] = scheme;
    params[RERouterCallbackKey] = aBlock;
    
    if ([self.delegate respondsToSelector:@selector(routerWithScheme:host:params:)]) {
        if ([self.delegate routerWithScheme:scheme host:host params:params]) {//被处理就结束
            return nil;
        }
    }
    
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        HJMappingVO *vo = self.mapping[@"web"];
        NSDictionary *params = @{ @"url" : aUrl.absoluteString };
        //nieyongqiang
        id res = [self routerVCWithMappingVO:vo params:params navigationController:nc animated:animated];
        if (res) {
            return res;
        }
    }
    else if ([hjScheme isEqualToString:scheme]) {
        if ([host isEqualToString:@"back"]) {
            return [self routerBack:params navigationController:nc];
        }
        
        HJMappingVO *mappingVO = [self.mapping objectForCaseInsensitiveKey:host];
        
        if (!mappingVO) {
//            NSLog(@"没有这个HJMappingVO, %@", aUrl.absoluteString.urlDecoding);
            return nil;
        }
        //nieyongqiang
        return [self routerVCWithMappingVO:mappingVO params:params navigationController:nc animated:animated];
    }
    else if ([hjFuncScheme isEqualToString:scheme]) {
        RERouterVO *nativeFuncVO = [self.nativeFuncMapping objectForCaseInsensitiveKey:host];
        
        if (!nativeFuncVO) {
            NSLog(@"没有这个RERouterVO, %@", aUrl.absoluteString.urlDecoding);
            return nil;
        }
        
        return [self routerNativeFuncWithVO:nativeFuncVO params:params];
        ;
    }
    else {
        NSLog(@"is not a router url,%@", aUrl.absoluteString.urlDecoding);
        return nil;
    }
    return nil;
}

- (id)routerWithUrl:(NSURL *)aUrl navigationController:(UINavigationController *)nc callbackBlock:(RERouterVOBlock)aBlock {
    if (!aUrl) {
        NSLog(@"router error url");
        return nil;
    }
    NSDate* datenow = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [datenow timeIntervalSince1970];
    long  now = time * 1000;
    
    //小于0.35s不做处理或提示点击太快
    if (now - self.lastPageTime < 350) {
        return nil;
    }
    self.lastPageTime = now;

    
    
    NSString *scheme = aUrl.scheme;
    NSString *host = [aUrl.host lowercaseString];
    NSString *query = aUrl.query;
    
    NSMutableDictionary *params = ((NSDictionary *)([NSString getDictFromJsonString:query][RERouterParamKey])).mutableCopy;
    params[RERouterFromHostKey] = host;
    params[RERouterFromSchemeKey] = scheme;
    params[RERouterCallbackKey] = aBlock;
    
    if ([self.delegate respondsToSelector:@selector(routerWithScheme:host:params:)]) {
        if ([self.delegate routerWithScheme:scheme host:host params:params]) {//被处理就结束
            return nil;
        }
    }
    
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        HJMappingVO *vo = self.mapping[[kMainH5WebPage lowercaseString]];
        
        NSDictionary *params = @{ @"url" : aUrl.absoluteString ,
                                  @"isRouter" : @(1)};
        id res = [self routerVCWithMappingVO:vo params:params navigationController:nc];
        if (res) {
            return res;
        }
    }
    
    else if ([hjScheme isEqualToString:scheme]) {
        if ([host isEqualToString:@"back"]) {
            return [self routerBack:params navigationController:nc];
        }
        
        HJMappingVO *mappingVO = [self.mapping objectForCaseInsensitiveKey:host];
        
        if (!mappingVO) {
            NSLog(@"没有这个HJMappingVO, %@", aUrl.absoluteString.urlDecoding);
            return nil;
        }
        return [self routerVCWithMappingVO:mappingVO params:params navigationController:nc];
    }
    
    else if ([hjScheme isEqualToString:scheme]) {
        if ([host isEqualToString:@"back"]) {
            return [self routerBack:params navigationController:nc];
        }
        
        HJMappingVO *mappingVO = [self.mapping objectForCaseInsensitiveKey:host];
        
        if (!mappingVO) {
            NSLog(@"没有这个HJMappingVO, %@", aUrl.absoluteString.urlDecoding);
            return nil;
        }
        return [self routerVCWithMappingVO:mappingVO params:params navigationController:nc];
    }
    else if ([hjFuncScheme isEqualToString:scheme]) {
        RERouterVO *nativeFuncVO = [self.nativeFuncMapping objectForCaseInsensitiveKey:host];
        
        if (!nativeFuncVO) {
            NSLog(@"没有这个RERouterVO, %@", aUrl.absoluteString.urlDecoding);
            return nil;
        }
        
        return [self routerNativeFuncWithVO:nativeFuncVO params:params];
        ;
    }
    else {
        NSLog(@"is not a router url,%@", aUrl.absoluteString.urlDecoding);
        return nil;
    }
    return nil;
}


- (id)routerNativeFuncWithVO:(RERouterVO *)aVO params:(NSDictionary *)aParams
{
    if ([self.delegate respondsToSelector:@selector(checkMapVO:)]) {
        if (![self.delegate checkMapVO:aVO]) {
            return nil;
        }
    }
    if (aVO.block) {
        return aVO.block(aParams);
    }
    else {
        return nil;
    }
    
    
}
//nieyongqiang
- (id)routerVCWithMappingVO:(HJMappingVO *)aVO params:(NSDictionary *)aParams navigationController:(UINavigationController *)nc animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(checkMapVO:)]) {
        if (![self.delegate checkMapVO:aVO]) {
            return nil;
        }
    }
    
    UIViewController *vc = [UIViewController createWithMappingVO:aVO extraData:aParams];
    if (!vc) {
        NSLog(@"router error %@, can not new one", aVO);
        return nil;
    }
    //nieyongqiang
    [self routerWithVC:vc param:aParams navigationController:nc animated:animated];
    
    return @[ vc ];
}
- (id)routerVCWithMappingVO:(HJMappingVO *)aVO params:(NSDictionary *)aParams navigationController:(UINavigationController *)nc
{
    if ([self.delegate respondsToSelector:@selector(checkMapVO:)]) {
        if (![self.delegate checkMapVO:aVO]) {
            return nil;
        }
    }
    
    UIViewController *vc = [UIViewController createWithMappingVO:aVO extraData:aParams];
    if (!vc) {
        NSLog(@"router error %@, can not new one", aVO);
        return nil;
    }
    [self routerWithVC:vc param:aParams navigationController:nc ];
    
    //return @[ vc ];
    return vc;  //新策略中需要使用返回值
}
//nieyongqiang
- (void)routerWithVC:(UIViewController *)aVC param:(NSDictionary *)aParams navigationController:(UINavigationController *)nc animated:(BOOL)animated
{
    if ([nc isKindOfClass:[UINavigationController class]]) {
        //nieyongqiang
        [nc pushViewController:aVC animated:animated];
    }
    else {
        NSLog(@"没有导航怎么push?");
    }
}
- (void)routerWithVC:(UIViewController *)aVC param:(NSDictionary *)aParams navigationController:(UINavigationController *)nc
{
    if ([nc isKindOfClass:[UINavigationController class]]) {
        [nc pushViewController:aVC animated:YES];
    }
    else {
        NSLog(@"没有导航怎么push?");
    }
}

- (NSArray *)routerBack:(NSDictionary *)aParams navigationController:(UINavigationController *)nc
{
    if ([nc isKindOfClass:[UINavigationController class]]) {
        UIViewController *vc = [nc popViewControllerAnimated:YES];
        if (vc) {
            return @[ vc ];
        }
    }
    else {
        NSLog(@"没有导航怎么pop?");
    }
    return nil;
}
- (UIViewController *)getRouterVC:(NSURL *)aUrl{
    NSString *scheme = aUrl.scheme;
    NSString *host = [aUrl.host lowercaseString];
    NSString *query = aUrl.query;
    
    NSMutableDictionary *params = ((NSDictionary *)([NSString getDictFromJsonString:query][RERouterParamKey])).mutableCopy;
    params[RERouterFromHostKey] = host;
    params[RERouterFromSchemeKey] = scheme;
    HJMappingVO *mappingVO = [self.mapping objectForCaseInsensitiveKey:host];
    
    if (!mappingVO) {
        NSLog(@"没有这个HJMappingVO, %@", aUrl.absoluteString.urlDecoding);
        return nil;
    }
    UIViewController *vc = [UIViewController createWithMappingVO:mappingVO extraData:params];
    return vc;
}



/**
 根据H5链接进行跳转
 @param params 链接数据
 @param nc 导航栏
 */
+ (void)jumpByAppData:(NSDictionary *)params navigationController:(UINavigationController *)nc
{
    NSString * linkUrl = [params getString:@"linkUrl"];
    if (linkUrl) {
         if ([linkUrl containsString:@"packAgeC/live"]) {
//             [self showMessage:@"敬请期待"];
             NSLog(@"敬请期待");
             return;
         }
        NSString * urlString = [[linkUrl componentsSeparatedByString:@"?"]firstObject];
        NSString *paramString = [[linkUrl componentsSeparatedByString:@"?"]lastObject];
        
        NSMutableDictionary * params = @{}.mutableCopy;
        for (NSString *paramStr in [paramString componentsSeparatedByString:@"&"]) {
            NSArray *elts = [paramStr componentsSeparatedByString:@"="];
            if (elts.count < 2) continue;
            [params setObject:[elts lastObject] forKey:[elts firstObject]];
        }
        
        if ([linkUrl containsString:@"http://"] || [linkUrl containsString:@"https://"]) {
            linkUrl = [linkUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//编码
            NSURL * url = [NSURL URLWithString:linkUrl];
            [RERouter gotoOriginalPageWithUrl:url navigationController:nc params:params];
            return;
        }
        
        if (linkUrl.length > 2) {
            NSString * firstCharString= [linkUrl substringWithRange:NSMakeRange(0, 1)];
            NSString * secondCharString = [linkUrl substringWithRange:NSMakeRange(0, 2)];
            if ([firstCharString isEqualToString:@"/"]) {
                if (![secondCharString isEqualToString:@"//"]) {
                    linkUrl =  [H5HOST stringByAppendingString:linkUrl];
                }else if ([secondCharString isEqualToString:@"//"]) {
                    linkUrl =  [@"http:" stringByAppendingString:linkUrl];
                }else{
                    return;
                }
                NSURL * url;
                if (params.allKeys.count > 0) {//有参数链接参数剥离出来
                    url = [NSURL URLWithString:urlString];
                }else{
                    url = [NSURL URLWithString:linkUrl];
                }
                [RERouter gotoOriginalPageWithUrl:url navigationController:nc params:params];
            }
            if ([linkUrl containsString:SCHEME]){
                [RERouter gotoOriginalPageWithScheme:linkUrl navigationController:nc params:params];
            }
        }
    }
}

#pragma mark -- 根据协议跳转原生页面
+ (void)gotoOriginalPageWithScheme:(NSString*)scheme navigationController:(UINavigationController *)nc params:(NSDictionary *)params
{
    NSURL *url = [NSURL URLWithString:scheme];
    NSDictionary *param = params[@"body"];
    [[RERouter singletonInstance] routerWithUrlString:[NSString getRouterVCUrlStringFromUrlString:url.host andParams:param] navigationController:nc];
}


#pragma mark -- 根据Url Path跳转原生页面
+ (void)gotoOriginalPageWithUrl:(NSURL*)url navigationController:(UINavigationController *)nc params:(NSDictionary *)params
{
    return;
    NSString * pageCode = @"";
    NSString * urlPath = url.path;
    //1 普通商城 2积分商城
    NSNumber * pageType = [params getNumber:@"pageType"];
    if ([urlPath isEqualToString:@"/index.html"])//首页
    {
//        [self goToTabWithIndex:[REGlobal sharedInstance].homeIndex];
//        [[NSNotificationCenter defaultCenter] postNotification:@"gotoHome" withObject:nil];
        return;
    }
    else if ([urlPath isEqualToString:@"/search.html"])//搜索页
    {
        pageCode = @"searchResult";
    }else if ([urlPath isEqualToString:@"/cart.html"])//购物车
    {
//        [self goToTabWithIndex:[REGlobal sharedInstance].cartIndex];
        return;
    } else if ([urlPath isEqualToString:@"/my/home.html"])//个人中心
    {
//        [self goToTabWithIndex:[REGlobal sharedInstance].mineIndex];
        return;
    }else if ([urlPath isEqualToString:@"/login.html"])//登陆
    {
//        [[REUser sharedMemory] login];
        return;
    }else if ([urlPath isEqualToString:@"/regis.html"])//登陆
    {
    }else if ([urlPath isEqualToString:@"/search.html"])//搜索结果
    {
        pageCode = @"searchResult";
    }else if ([urlPath isEqualToString:@"/detail.html"])//商品详情
    {
        pageCode = ([pageType  isEqual: @(2)])?@"IntegralProductDetailVC":@"productdetail";
        if ([params hasKey:@"itemId"] && [params getString:@"itemId"]) {
            NSString * mpId = [params getString:@"itemId"];
            [params setValue:mpId forKey:@"mpId"];
        }
    }else if ([urlPath containsString:@"/pointShop.html"])//积分商城首页
    {
        pageCode = @"IntegralHome";
    }
    else if ([urlPath isEqualToString:@"/group/detail.html"])//拼团详情
    {
        
    }
    if (pageCode.length > 0) {
        [[RERouter singletonInstance]routerWithUrlString:[NSString getRouterVCUrlStringFromUrlString:pageCode andParams:params] navigationController:nc];
    }else{
        if (url) {
            NSDictionary * params = @{@"isRouter" : @(1),
                                      @"linkUrl" : url.absoluteString};
            [[RERouter singletonInstance]routerWithUrlString:[NSString getRouterVCUrlStringFromUrlString:kMainH5WebPage andParams:params] navigationController:nc];
        }
    }
}

#pragma mark -- 跳转标签控制器
+ (void)goToTabWithIndex:(NSNumber*)idx
{
//    if (!idx) {
//        return;
//    }
//    NSInteger index = idx.integerValue;
//    //如果就是在index栈的情况下
//    if ([REGlobal sharedInstance].globalTbc.selectedIndex == index)
//    {
//        [[REGlobal sharedInstance].globalNavC popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        if (![REGlobal sharedInstance].globalNavC.tabBarController.tabBar.hidden)
//        {
//            //跳转到index
//            [[REGlobal sharedInstance].globalTbc enterHomeWithIndex:idx];
//        }
//        else
//        {
//            [[REGlobal sharedInstance].globalNavC popToRootViewControllerAnimated:YES];
//            dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , 0.05 * NSEC_PER_SEC ) ;
//            dispatch_after ( time , dispatch_get_main_queue ( ) , ^ {
//                //跳转到index
//                [[REGlobal sharedInstance].globalTbc enterHomeWithIndex:idx];
//            } ) ;
//        }
//    }
}




@end


@implementation PhoneRouter

@end
