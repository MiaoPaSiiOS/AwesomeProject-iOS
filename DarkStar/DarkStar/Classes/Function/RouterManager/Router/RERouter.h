//
//  RERouter.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "NSString+RERouter.h"
#import "HJMappingVO.h"
#import "RERouterVO.h"


//平台相关判断
typedef NS_ENUM(NSInteger, HJPlatformType) {
    HJPlatformTypePhone = 0,
    HJPlatformTypePad = 1,
};

@protocol RERouterDelegate <NSObject>
/**
 Router跳转代理
 */
- (BOOL)checkMapVO:(RERouterVO *)vo;
- (BOOL)routerWithScheme:(NSString *)scheme host:(NSString *)host params:(NSMutableDictionary *)params;

@end

@interface RERouter : NSObject
//单例
+ (instancetype)singletonInstance;

@property (nonatomic, strong, readonly) NSMutableDictionary *mapping;

@property (nonatomic, readonly) HJPlatformType platformType;
@property (nonatomic, weak) id<RERouterDelegate> delegate;

@property(nonatomic, weak) UINavigationController *currentNC;

-(BOOL)isInMapping:(NSString *)urlString;

- (UIViewController *)getRouterVC:(NSURL *)urlString;
/**
 根据H5链接进行跳转
 @param params 链接数据
 @param nc 导航栏
 */
+ (void)jumpByAppData:(NSDictionary *)params navigationController:(UINavigationController *)nc;

- (void)registerClass:(Class)aClass key:(NSString *)aKey;
/**
 *  注册VC
 *
 *  @param aVO      HJMappingVO
 *  @param aKeyName 对应的Key
 */
- (void)registerRouterVO:(HJMappingVO *)aVO withKey:(NSString *)aKeyName;
/**
 *  注册本地方法
 *
 *  @param aVO      RERouterVO
 *  @param aKeyName 对应的Key
 */
- (void)registerNativeFuncVO:(RERouterVO *)aVO withKey:(NSString *)aKeyName;
//nieyongqiang
- (id)routerWithUrlString:(NSString *)aUrlString navigationController:(UINavigationController *)nc animated:(BOOL)animated;
- (id)routerWithUrlString:(NSString *)aUrlString navigationController:(UINavigationController *)nc;
- (id)routerWithUrlString:(NSString *)aUrlString navigationController:(UINavigationController *)nc callbackBlock:(RERouterVOBlock)aBlock;

//nieyongqiang
- (id)routerWithUrlString:(NSString *)aUrlString navigationController:(UINavigationController *)nc callbackBlock:(RERouterVOBlock)aBlock animated:(BOOL)animated;

#pragma mark -- 根据协议跳转原生页面
+ (void)gotoOriginalPageWithScheme:(NSString*)scheme navigationController:(UINavigationController *)nc params:(NSDictionary *)params;

@end



//跳转分类
@interface PhoneRouter : RERouter

@end


