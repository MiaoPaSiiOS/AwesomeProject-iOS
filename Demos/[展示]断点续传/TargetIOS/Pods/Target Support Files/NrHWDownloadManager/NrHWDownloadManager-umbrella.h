#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HWDataBaseManager.h"
#import "HWDownloadManager.h"
#import "HWDownloadModel.h"
#import "HWDownloadNoti.h"
#import "HWGlobeConst.h"
#import "HWNetworkReachabilityManager.h"
#import "HWProgressHUD.h"
#import "HWToolBox.h"
#import "NrHWDownloadManager.h"
#import "NSURLSession+CorrectedResumeData.h"

FOUNDATION_EXPORT double NrHWDownloadManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char NrHWDownloadManagerVersionString[];

