//
//  REGlobal.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/17.
//

#import <Foundation/Foundation.h>
#import "REUITabBarController.h"
NS_ASSUME_NONNULL_BEGIN

@interface REGlobal : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) REUITabBarController *globalTbc;
//tab页面对应的下标位置
@property (nonatomic, copy) NSNumber   *tab_homeIndex;
@property (nonatomic, copy) NSNumber   *tab_noticeIndex;
@property (nonatomic, copy) NSNumber   *tab_dataIndex;
@property (nonatomic, copy) NSNumber   *tab_mineIndex;


@property (nonatomic, strong) UINavigationController *globalNavC;

@property (nonatomic, copy) NSString      *userAgent;

@property (nonatomic, copy) NSString  *noticeTabDefaultSelectIndex;

#pragma mark - RSA加解密
/// 公钥信息
@property(nonatomic, strong) NSDictionary *encryption;
/**
 * -------RSA 字符串公钥加密-------
 @param plaintext 明文，待加密的字符串
 @return 密文，加密后的字符串
 */
+ (NSString *)encryptString:(NSString *)plaintext;
@end

NS_ASSUME_NONNULL_END
