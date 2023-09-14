//
//  HJMappingVO.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RERouterVO.h"

typedef NS_ENUM(NSUInteger, HJMappingClassCreateType)
{
    HJMappingClassCreateByCode       = 0,//编码方式创建
    HJMappingClassCreateByXib        = 1,//xib方式创建
    HJMappingClassCreateByStoryboard = 2,//storyboard方式创建
};

typedef NS_ENUM(NSUInteger, HJMappingClassPlatformType)
{
    HJMappingClassPlatformTypePhone     = 0,//只在iPhone上load
    HJMappingClassPlatformTypePad       = 1,//只在iPad上load
    HJMappingClassPlatformTypeUniversal = 2,//任何平台都load
};

@interface HJMappingVO : RERouterVO
/**
 *  创建的方式
 */
@property (nonatomic) HJMappingClassCreateType createdType;
/**
 *  load过滤
 */
@property (nonatomic) HJMappingClassPlatformType loadFilterType;
/**
 *  资源文件名称
 */
@property (nonatomic, strong) NSString *nibName;
/**
 *  storyboard名称
 */
@property (nonatomic, strong) NSString *storyboardName;
/**
 *  storyboard中storyboardID名称
 */
@property (nonatomic, strong) NSString *storyboardID;

@end
