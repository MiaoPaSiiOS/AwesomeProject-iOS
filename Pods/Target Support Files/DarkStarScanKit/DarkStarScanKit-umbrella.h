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

#import "DarkStarScanKit.h"
#import "DSDetectorQRImage.h"
#import "DSScanEventLog.h"
#import "DSScanner.h"
#import "DSScannerTool.h"
#import "DSScanView.h"

FOUNDATION_EXPORT double DarkStarScanKitVersionNumber;
FOUNDATION_EXPORT const unsigned char DarkStarScanKitVersionString[];

