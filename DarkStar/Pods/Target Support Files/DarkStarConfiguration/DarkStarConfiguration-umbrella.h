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

#import "DSAppConfiguration.h"
#import "DSDBTool.h"
#import "DSEnvironment.h"
#import "DSEnvironmentTool.h"

FOUNDATION_EXPORT double DarkStarConfigurationVersionNumber;
FOUNDATION_EXPORT const unsigned char DarkStarConfigurationVersionString[];

