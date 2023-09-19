//
//  DSAwesomeKitTool.h
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSAwesomeKitTool : NSObject
+ (NSBundle *)AssetsBundle;

+ (nullable UIImage *)imageNamed:(NSString *)name;

+ (nullable UIImage *)imageNamed:(NSString *)name inDirectory:(nullable NSString *)subpath;

+ (nullable NSString *)imagePathWithNamed:(NSString *)name inDirectory:(nullable NSString *)subpath;
@end

NS_ASSUME_NONNULL_END
