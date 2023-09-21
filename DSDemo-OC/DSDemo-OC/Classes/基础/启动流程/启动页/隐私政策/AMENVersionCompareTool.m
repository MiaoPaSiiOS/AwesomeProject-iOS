//
//  AMENVersionCompareTool.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "AMENVersionCompareTool.h"

@implementation AMENVersionCompareTool

+ (NSComparisonResult)compareVersionWithFirst:(NSString *)firstVersion second:(NSString *)secondVersion {
    NSArray *firstVersions = [firstVersion componentsSeparatedByString:@"."];
    NSArray *secondVersions = [secondVersion componentsSeparatedByString:@"."];
    
    NSInteger count = MIN(firstVersions.count, secondVersions.count);
    for (int i = 0; i < count; i ++) {
        NSInteger first = [firstVersions[i] integerValue];
        NSInteger second = [secondVersions[i] integerValue];
        if(first > second) {
            return NSOrderedDescending;
        }
        else if(first < second) {
            return NSOrderedAscending;
        }
    }

    //经过上面的for后还没有比较出来，说明两者相同位的版本号都相同，剩下的则看谁的版本号更长，长的则表示版本号大。例：1.0.1 < 1.0.1.1
    if(firstVersions.count < secondVersions.count) {
        return NSOrderedAscending;//升序（说明第一个版本较低）
    }
    else if(firstVersions.count > secondVersions.count) {
        return NSOrderedDescending;//降序(说明第一个版本较高)
    }
    else {
        return NSOrderedSame;
    }
}

+ (BOOL)isFirstVersion:(NSString *)firstVersion largerThanSecondVersion:(NSString *)secondVersion {
    if ([self compareVersionWithFirst:firstVersion second:secondVersion] == NSOrderedDescending) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isFirstVersion:(NSString *)firstVersion largerThanOrEqualToSecondVersion:(NSString *)secondVersion {
    if ([self compareVersionWithFirst:firstVersion second:secondVersion] == NSOrderedAscending) {
        return NO;
    }
    else {
        return YES;
    }
}


+ (BOOL)isFirstVersion:(NSString *)firstVersion smallerThanSecondVersion:(NSString *)secondVersion {
    if ([self compareVersionWithFirst:firstVersion second:secondVersion] == NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isFirstVersion:(NSString *)firstVersion smallerThanOrEqualToSecondVersion:(NSString *)secondVersion {
    if ([self compareVersionWithFirst:firstVersion second:secondVersion] == NSOrderedDescending) {
        return NO;
    }
    else {
        return YES;
    }
}

+ (BOOL)isBigUpdateVersion:(NSString *)currentVersion baseVersion:(NSString *)baseVersion {
    NSArray *currentVersions = [currentVersion componentsSeparatedByString:@"."];
    NSArray *baseVersions = [baseVersion componentsSeparatedByString:@"."];
    if (currentVersions.count != 3 || baseVersions.count != 3) {
        return YES;
    }
    else {
        NSInteger currentV = [currentVersions[0] integerValue];
        NSInteger baseV = [baseVersions[0] integerValue];
        if (currentV == baseV) {
            return NO;
        }
        else {
            return YES;
        }
    }
}

+ (BOOL)isMiddleUpdateVersion:(NSString *)currentVersion baseVersion:(NSString *)baseVersion {
    NSArray *currentVersions = [currentVersion componentsSeparatedByString:@"."];
    NSArray *baseVersions = [baseVersion componentsSeparatedByString:@"."];
    if (currentVersions.count != 3 || baseVersions.count != 3) {
        return YES;
    }
    else {
        NSInteger currentV0 = [currentVersions[0] integerValue];
        NSInteger baseV0 = [baseVersions[0] integerValue];
        
        NSInteger currentV1 = [currentVersions[1] integerValue];
        NSInteger baseV1 = [baseVersions[1] integerValue];
        if (currentV0 == baseV0 && currentV1 == baseV1) {
            return NO;
        }
        else {
            return YES;
        }
    }
}

+ (BOOL)isSmallUpdateVersion:(NSString *)currentVersion baseVersion:(NSString *)baseVersion {
    NSArray *currentVersions = [currentVersion componentsSeparatedByString:@"."];
    NSArray *baseVersions = [baseVersion componentsSeparatedByString:@"."];
    if (currentVersions.count != 3 || baseVersions.count != 3) {
        return YES;
    }
    else {
        NSInteger currentV0 = [currentVersions[0] integerValue];
        NSInteger baseV0 = [baseVersions[0] integerValue];
        
        NSInteger currentV1 = [currentVersions[1] integerValue];
        NSInteger baseV1 = [baseVersions[1] integerValue];
        
        NSInteger currentV2 = [currentVersions[2] integerValue];
        NSInteger baseV2 = [baseVersions[2] integerValue];
        if (currentV0 == baseV0 && currentV1 == baseV1 && currentV2 == baseV2) {
            return NO;
        }
        else {
            return YES;
        }
    }
}
@end
