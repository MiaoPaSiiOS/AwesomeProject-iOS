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

#import "IUHUD.h"
#import "IU_HUD.h"

FOUNDATION_EXPORT double IU_HUDVersionNumber;
FOUNDATION_EXPORT const unsigned char IU_HUDVersionString[];

