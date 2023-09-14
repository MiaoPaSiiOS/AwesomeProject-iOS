//
//  DSGrayManager.h
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//
//  全局置灰
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface DSGrayManager : NSObject

+ (instancetype)shared;

@property (nonatomic, assign) BOOL grayViewEnabled;

@end

NS_ASSUME_NONNULL_END
