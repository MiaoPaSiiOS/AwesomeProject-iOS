//
//  DSResourceTool.h
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSResourceTool : NSObject
+ (NSBundle *)AssetsBundle;

+ (UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
