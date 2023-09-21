//
//  AMENVersionCompareTool.h
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMENVersionCompareTool : NSObject

+ (NSComparisonResult)compareVersionWithFirst:(NSString *)firstVersion second:(NSString *)secondVersion;

//第一个版本是否比第二个版本高
+ (BOOL)isFirstVersion:(NSString *)firstVersion largerThanSecondVersion:(NSString *)secondVersion;

+ (BOOL)isFirstVersion:(NSString *)firstVersion largerThanOrEqualToSecondVersion:(NSString *)secondVersion;

//第一个版本是否比第二个版本低
+ (BOOL)isFirstVersion:(NSString *)firstVersion smallerThanSecondVersion:(NSString *)secondVersion;

+ (BOOL)isFirstVersion:(NSString *)firstVersion smallerThanOrEqualToSecondVersion:(NSString *)secondVersion;

+ (BOOL)isBigUpdateVersion:(NSString *)currentVersion baseVersion:(NSString *)baseVersion;

+ (BOOL)isMiddleUpdateVersion:(NSString *)currentVersion baseVersion:(NSString *)baseVersion;

+ (BOOL)isSmallUpdateVersion:(NSString *)currentVersion baseVersion:(NSString *)baseVersion;

@end

NS_ASSUME_NONNULL_END
