//
//  HWDownloadNoti.h
//  NrDataStoreFramework
//
//  Created by zhuyuhui on 2022/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/************************* 下载 *************************/
UIKIT_EXTERN NSString * const HWDownloadProgressNotification;                   // 进度回调通知
UIKIT_EXTERN NSString * const HWDownloadStateChangeNotification;                // 状态改变通知
UIKIT_EXTERN NSString * const HWDownloadMaxConcurrentCountKey;                  // 最大同时下载数量key
UIKIT_EXTERN NSString * const HWDownloadMaxConcurrentCountChangeNotification;   // 最大同时下载数量改变通知
UIKIT_EXTERN NSString * const HWDownloadAllowsCellularAccessKey;                // 是否允许蜂窝网络下载key
UIKIT_EXTERN NSString * const HWDownloadAllowsCellularAccessChangeNotification; // 是否允许蜂窝网络下载改变通知



/************************* 网络 *************************/
UIKIT_EXTERN NSString * const HWNetworkingReachabilityDidChangeNotification;    // 网络改变改变通知




@interface HWDownloadNoti : NSObject

@end

NS_ASSUME_NONNULL_END
