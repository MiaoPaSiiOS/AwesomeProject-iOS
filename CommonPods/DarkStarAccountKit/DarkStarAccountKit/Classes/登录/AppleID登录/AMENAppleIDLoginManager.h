//
//  AMENAppleIDLoginManager.h
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(ios(13.0))
typedef void (^appleIDLoginBindCredentialBlock) (ASAuthorizationAppleIDCredential *credential, BOOL isBind, NSDictionary *param);

API_AVAILABLE(ios(13.0))
@interface AMENAppleIDLoginManager : NSObject
<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (copy, nonatomic) appleIDLoginBindCredentialBlock appleIDLoginBindBlock;

+ (instancetype)sharedInstance;
- (void)signInWithApple;
@end

NS_ASSUME_NONNULL_END
