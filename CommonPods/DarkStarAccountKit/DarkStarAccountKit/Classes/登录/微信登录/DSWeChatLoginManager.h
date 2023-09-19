//
//  DSWeChatLoginManager.h
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^weChatLoginBlock) (BOOL success, BOOL isBind, NSString * _Nullable resCode, NSDictionary * _Nullable param);

@interface DSWeChatLoginManager : NSObject
@property (nonatomic, copy) weChatLoginBlock loginBlock;

+ (instancetype)sharedInstance;

- (void)signInWithWeChat;

@end

NS_ASSUME_NONNULL_END
