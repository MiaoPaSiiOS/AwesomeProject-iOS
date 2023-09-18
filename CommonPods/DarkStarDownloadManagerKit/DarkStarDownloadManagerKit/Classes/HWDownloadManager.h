//
//  HWDownloadManager.h
//  HWProject
//
//  Created by wangqibin on 2018/4/24.
//  Copyright © 2018年 wangqibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HWDownloadModel;


@interface HWDownloadManager : NSObject

// 初始化下载单例，若之前程序杀死时有正在下的任务，会自动恢复下载
+ (instancetype)shareManager;

@property (nonatomic, copy) void (^ backgroundSessionCompletionHandler)(void);  // 后台所有下载任务完成回调


// 开始下载
- (void)startDownloadTask:(HWDownloadModel *)model;

// 暂停下载
- (void)pauseDownloadTask:(HWDownloadModel *)model;

// 删除下载任务及本地缓存
- (void)deleteTaskAndCache:(HWDownloadModel *)model;

@end
