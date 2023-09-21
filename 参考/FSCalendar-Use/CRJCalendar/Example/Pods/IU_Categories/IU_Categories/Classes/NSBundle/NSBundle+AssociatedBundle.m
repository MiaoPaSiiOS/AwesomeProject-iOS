//
//  NSBundle+AssociatedBundle.m
//  CRJCategories
//
//  Created by zhuyuhui on 2020/9/22.
//

#import "NSBundle+AssociatedBundle.h"

@implementation NSBundle (AssociatedBundle)
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName {
    if ([self isBlankString:bundleName] && [self isBlankString:podName]) {
        @throw @"bundleName和podName不能同时为空";
    } else if ([self isBlankString:bundleName]) {
        bundleName = podName;
    } else if ([self isBlankString:podName]) {
        podName = bundleName;
    }
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

////////////
//字符串是否为空
+ (BOOL)isBlankString:(NSString *)aStr{
    if (!aStr) {return YES;}
    if ([aStr isKindOfClass:[NSNull class]]) {return YES;}
    if (![aStr isKindOfClass:[NSString class]]) {return YES;}
    if (!aStr.length) {return YES;}
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {return YES;}
    return NO;
}
@end
