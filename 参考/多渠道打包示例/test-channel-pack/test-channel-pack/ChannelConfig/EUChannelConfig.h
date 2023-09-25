//
//  EUChannelConfig.h
//  test-channel-pack
//
//  Created by zhuyuhui on 2021/3/1.
//

#import <Foundation/Foundation.h>
#import "ChannelColor.h"
#import "ChannelConfig.h"
#import "DefaultChannelColor.h"
#import "DefaultChannelConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface EUChannelConfig : NSObject

@property(nonatomic, copy, readonly) NSString *COMMPANY;
@property(nonatomic, copy, readonly) NSString *NETWORK;


+ (instancetype)sharedInstance;

- (void)loadConfig;

@end

NS_ASSUME_NONNULL_END
