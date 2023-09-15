//
//  NSBundle+DarkStar.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (DarkStar)

+ (NSArray *)preferredScales;

+ (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)bundlePath;

- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext;

- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

@end

NS_ASSUME_NONNULL_END
