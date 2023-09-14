//
//  DSAppConfiguration.h
//  DarkStarConfiguration
//
//  Created by zhuyuhui on 2023/6/2.
//

#import <Foundation/Foundation.h>
#import "DSEnvironment.h"


NS_ASSUME_NONNULL_BEGIN

extern NSString *const developer_url;

@interface DSAppConfiguration : NSObject
+ (instancetype)shareConfiguration;
@property (nonatomic, strong) NSMutableArray *environments;
@property (nonatomic, strong) DSEnvironment *environment;

@end

NS_ASSUME_NONNULL_END
