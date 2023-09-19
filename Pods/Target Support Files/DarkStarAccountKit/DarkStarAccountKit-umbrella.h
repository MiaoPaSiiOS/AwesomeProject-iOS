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

#import "DarkStarAccountKit.h"
#import "CTMediator+AmenAccountKit.h"
#import "Target_AmenAccountKit.h"
#import "DSAccountTool.h"
#import "DSUserSession.h"
#import "AMENRegisterCodeValidateViewController.h"
#import "AMENAppleIDLoginManager.h"
#import "AMENCreditCardViewController.h"
#import "AMENVocalLoginViewController.h"
#import "AMENVocalPrintSecretViewController.h"
#import "AMENVocalSetViewController.h"
#import "AMENVocalPrintInfoUtil.h"
#import "AMENWeChatLoginManager.h"
#import "AMENGestureLoginViewController.h"
#import "AMENGestureInfoUtil.h"
#import "AMENPhoneLoginViewController.h"
#import "AMENPhoneCodeLoginViewController.h"
#import "AMENPhonePwdLoginViewController.h"
#import "AMENTouchIDLoginViewController.h"
#import "AMENTouchIDSettingViewController.h"
#import "AMENTouchIDInfoUtil.h"
#import "AMENLoginViewController.h"
#import "AMENRiskCheckPhoneCodeViewController.h"
#import "AMENAccountLoginViewController.h"
#import "AMENLongTermLoginManager.h"

FOUNDATION_EXPORT double DarkStarAccountKitVersionNumber;
FOUNDATION_EXPORT const unsigned char DarkStarAccountKitVersionString[];

