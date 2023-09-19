//
//  DSLongTermLoginManager.h
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^LoginBlock)(BOOL success, NSError *_Nullable error);

@interface DSLongTermLoginManager : NSObject
//长登录block
@property (nonatomic, copy) LoginBlock loginBlock;

+ (instancetype)sharedInstance;

/// 设置回调block
- (void)configWithBlock:(LoginBlock)loginBlock;

/// 是否需要长登录
@property (nonatomic, assign) BOOL needLogin;

///长登录是否执行过
@property (nonatomic, assign) BOOL isExecuted;

///长登录是否正在执行
@property (nonatomic, assign) BOOL isExecuting;

- (void)signInWithLongTerm;

@end

NS_ASSUME_NONNULL_END
