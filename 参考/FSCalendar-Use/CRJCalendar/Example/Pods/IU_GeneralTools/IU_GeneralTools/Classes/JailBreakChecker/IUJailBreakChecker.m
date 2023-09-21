//
//  IUJailBreakChecker.m
//  CRJGeneralTools
//
//  Created by 朱玉辉(EX-ZHUYUHUI002) on 2021/1/12.
//

#import "IUJailBreakChecker.h"

@implementation IUJailBreakChecker
/*
 1.通过越狱后增加的越狱文件判断

 通常情况下，手机越狱后会增加以下文件
 /Applications/Cydia.app
 /Library/MobileSubstrate/MobileSubstrate.dylib
 /bin/bash
 /usr/sbin/sshd
 /etc/apt
 判断这些文件是否存在，让文件添加到数组中，遍历数组，如果存在任何一个文件，就认为是越狱了
 */
+ (BOOL)isJailBreak1{
    const char* jailbreak_tool_pathes[] = {
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/etc/apt"
    };

    int arraySize = sizeof(jailbreak_tool_pathes)/sizeof(jailbreak_tool_pathes[0]);
    NSLog(@"arraySize = %d",arraySize);
    for (int i=0; i< arraySize; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            NSLog(@"The device is jail broken! %s is exists",jailbreak_tool_pathes[i]);
           return YES;
        }
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

/*
 2.是否能打开cydia这个协议头
 */
+ (BOOL)isJailBreak2{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

/*
 3.越狱后的手机是可以获取到手机内安装的所有应用程序的，如果可以获取到就说明越狱了
 */
+ (BOOL)isJailBreak3{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
        NSLog(@"The device is jail broken!");
        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
        NSLog(@"appList = %@", appList);
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}


+ (BOOL)isJailBroken {
    if ([IUJailBreakChecker isJailBreak1]){
        return YES;
    }
    if ([IUJailBreakChecker isJailBreak2]){
        return YES;
    }
    if ([IUJailBreakChecker isJailBreak3]){
        return YES;
    }
    return NO;
}
@end
