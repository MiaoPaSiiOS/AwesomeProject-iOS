//
//  NSError+NSString.m
//  IHome4Phone
//
//  Created by sean on 2016/3/30.
//  Copyright © 2016年 ihome. All rights reserved.
//

#import "NSError+RE.h"

static NSString *__unkown_error = @"Unkown error!";
NSString * const HJFrameworkErrorDomain = @"HJFrameworkError";


@implementation NSError (RE)

- (NSString *)toString
{
    NSString *localizedDescription = [self localizedDescription];
    if ([localizedDescription length] > 0)
    {
        return localizedDescription;
    }

    NSString *description = [self description];
    if ([description length] > 0)
    {
        return description;
    }

    return __unkown_error;
}


+ (NSError *)frameworkErrorWithMessage:(NSString *)errorMessage {
    NSString *message = errorMessage ? errorMessage : @"Unknow reason.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
    id error = [self errorWithDomain:HJFrameworkErrorDomain code:0 userInfo:userInfo];
    return error;
}

@end
