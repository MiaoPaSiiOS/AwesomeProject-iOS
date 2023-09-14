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

#import "DarkStarUpdateSDK.h"
#import "NrAppUpdateConfig.h"
#import "NrAppUpdateManager.h"
#import "NrAppUpdateResponseModel.h"
#import "NrUpdateNetworkReachabilityManager.h"
#import "NrUpdateUtils.h"

FOUNDATION_EXPORT double DarkStarUpdateSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char DarkStarUpdateSDKVersionString[];

