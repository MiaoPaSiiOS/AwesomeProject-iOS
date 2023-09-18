//
//  NSObject+NrBundle.m
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2020/9/22.
//

#import "NSObject+NrBundle.h"

@implementation NSObject (NrBundle)

+ (nullable NSBundle *)nr_bundleName:(NSString *)bundleName inPod:(NSString *)podName;
{
    if (bundleName == nil || podName == nil) {
        return nil;
    }
    
    //去除文件后缀
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    
    
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    
    if (!associateBundleURL) {//使用framework形式
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

+ (UIImage *)nr_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    if (!name) return nil;
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
