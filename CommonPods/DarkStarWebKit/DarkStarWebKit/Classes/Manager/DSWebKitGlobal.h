//
//  DSWebKitGlobal.h
//  AmenWebKit
//
//  Created by zhuyuhui on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSWebKitGlobal : NSObject
+ (instancetype)sharedInstance;
/// 网页白名单
@property(nonatomic, strong) NSArray *pageWhiteList;
/// h5缓存名单列表
@property(nonatomic, strong) NSArray *webCacheWhiteList;
/// 商户回调白名单
@property(nonatomic, strong) NSArray *pageMerchantList;
/// 特殊情况放行的链接
@property(nonatomic, strong) NSArray *pageSpecialList;




#pragma mark - 特殊情况url判断
+ (BOOL)SpecialIOSListFlag:(NSString *)netUrl;
#pragma mark - 网络白名单
+ (BOOL)DomainFlag:(NSString *)netUrl;




#pragma mark - Public
+ (NSDictionary *)parseParams:(NSString *)query;
// 字符串包含
+ (BOOL)parentString:(NSString *)pString containsString:(NSString *)aString;
//
+ (NSString *)noWhiteSpaceString:(NSString *)str;

+ (NSBundle *)AssetsBundle;
@end

NS_ASSUME_NONNULL_END
