//
//  AECResouce.h
//  AmenEnjoyCamera
//
//  Created by zhuyuhui on 2021/6/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface AECResouce : NSObject
+ (UIImage *)imageNamed:(NSString *)name;
+ (UINib *)nibWithNibName:(NSString *)name;
+ (NSBundle *)Config;
+ (NSBundle *)Filters;
+ (NSBundle *)Frames;

@end

NS_ASSUME_NONNULL_END
