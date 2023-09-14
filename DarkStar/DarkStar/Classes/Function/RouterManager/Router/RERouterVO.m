//
//  RERouterVO.m
//  REFramework
//
//  Created by RE on 2015/7/20.
//  Copyright (c) 2015年 RE. All rights reserved.
//

#import "RERouterVO.h"

@implementation RERouterVO

+ (instancetype)createWithBlock:(RERouterVOBlock)block
{
    RERouterVO *vo = [self new];
    vo.block = block;
    return vo;
}


@end
