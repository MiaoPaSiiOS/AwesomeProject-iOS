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

#import "DarkStarAuthorityKit.h"
#import "DSAddressBookManger.h"
#import "DSAuthorityLog.h"
#import "DSEventManger.h"
#import "DSLocationManger.h"
#import "DSMediaManger.h"
#import "DSPhotoManger.h"
#import "DSPushManger.h"

FOUNDATION_EXPORT double DarkStarAuthorityKitVersionNumber;
FOUNDATION_EXPORT const unsigned char DarkStarAuthorityKitVersionString[];

