//
//  DSCacheManger.h
//  DarkStarResourceKit
//
//  Created by zhuyuhui on 2023/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSCacheManger : NSObject
+ (instancetype)sharedInstance;

// 松手刷新循环
@property (nonatomic, strong) NSArray * mjPulling2Array;

// 松手刷新状态
@property (nonatomic, strong) NSArray * mjPullingArray;

// mj header
@property (nonatomic, strong) NSArray * mjHeaderArray;
// mj footer
@property (nonatomic, strong) NSArray * mjFooterArray;
// 下啦 数组
@property (nonatomic, strong) NSArray * mjDragArray;
// 刷新 数组
@property (nonatomic, strong) NSArray * refreshBlueLoadingArray;

@property (nonatomic, strong) NSArray * refreshWhiteLoadingArray;

@property (nonatomic, strong) NSString * isDidReceiveMemory;

@end

NS_ASSUME_NONNULL_END
