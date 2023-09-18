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

#import "NrAddressBookManger.h"
#import "NrAuthorityKit.h"
#import "NrAuthorityLog.h"
#import "NrEventManger.h"
#import "NrLocationManger.h"
#import "NrMediaManger.h"
#import "NrPhotoManger.h"
#import "NrPushManger.h"

FOUNDATION_EXPORT double NrAuthorityKitVersionNumber;
FOUNDATION_EXPORT const unsigned char NrAuthorityKitVersionString[];

