//
//  REUser.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REUser : NSObject

@property(nonatomic, copy) NSString *authorizeStatus;
/// 用户头像
@property(nonatomic, copy) NSString *headPicUrl;
/// 用户Id
@property(nonatomic, copy) NSString *userId;
/// 昵称
@property(nonatomic, copy) NSString *nickName;
/// 性别 MALE, FEMALE
@property(nonatomic, copy) NSString *sex;
/// 用户姓名
@property(nonatomic, copy) NSString *userName;
///
@property(nonatomic, copy) NSString *identityCardName;
/// 登录手机号
@property(nonatomic, copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
