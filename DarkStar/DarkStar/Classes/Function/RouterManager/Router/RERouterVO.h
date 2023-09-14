//
//  RERouterVO.h
//  REFramework
//
//  Created by RE on 2015/7/20.
//  Copyright (c) 2015年 RE. All rights reserved.
//

typedef NS_ENUM(NSUInteger, RERouterVOPlatformType)
{
    RERouterVOPlatformTypePhone     = 0,//只在iPhone上加载此func
    RERouterVOPlatformTypePad       = 1,//只在iPad上加载此func
    RERouterVOPlatformTypeUniversal = 2,//任何平台都加载此func
};

typedef id (^RERouterVOBlock)(NSDictionary *params);


#import <Foundation/Foundation.h>

@interface RERouterVO : NSObject

@property (nonatomic, assign) BOOL needLogin;
@property (nonatomic, strong) NSString *classKey;
@property (nonatomic, strong) NSString *className;

/**
 *  调用的方法,默认传送一个参数，为NSDictionary
 */
@property (nonatomic, copy) RERouterVOBlock block;
/**
 *  func过滤
 */
@property (nonatomic) RERouterVOPlatformType funcFilterType;

+ (instancetype)createWithBlock:(RERouterVOBlock)block;

@end
