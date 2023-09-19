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
#import "DSRegisterCodeValidateViewController.h"
#import "DSAppleIDLoginManager.h"
#import "DSCreditCardViewController.h"
#import "DSVocalLoginViewController.h"
#import "DSVocalPrintSecretViewController.h"
#import "DSVocalSetViewController.h"
#import "DSVocalPrintInfoUtil.h"
#import "DSWeChatLoginManager.h"
#import "DSGestureLoginViewController.h"
#import "DSGestureInfoUtil.h"
#import "DSPhoneLoginViewController.h"
#import "DSPhoneCodeLoginViewController.h"
#import "DSPhonePwdLoginViewController.h"
#import "DSTouchIDLoginViewController.h"
#import "DSTouchIDSettingViewController.h"
#import "DSTouchIDInfoUtil.h"
#import "DSLoginViewController.h"
#import "DSRiskCheckPhoneCodeViewController.h"
#import "DSAccountLoginViewController.h"
#import "DSLongTermLoginManager.h"

FOUNDATION_EXPORT double DarkStarAccountKitVersionNumber;
FOUNDATION_EXPORT const unsigned char DarkStarAccountKitVersionString[];

