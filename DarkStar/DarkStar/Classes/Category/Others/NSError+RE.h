//
//  NSError+NSString.h
//  IHome4Phone
//
//  Created by sean on 2016/3/30.
//  Copyright © 2016年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (RE)

- (NSString *)toString;

+ (NSError *)frameworkErrorWithMessage:(NSString *)errorMessage;

@end
