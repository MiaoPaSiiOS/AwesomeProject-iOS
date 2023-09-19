//
//  DataEncrypt.h
//  PufaBankMobile
//
//  Created by P&C on 10-12-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataEncrypt : NSObject {

}
+ (NSString *)Encrypt:(NSString *)inputString;
+ (NSString *)Encrypt:(NSString *)inputString withKey:(NSString *)key;
+ (NSString *)Decrypt:(NSString *)encryptString;
+ (NSString *)Decrypt:(NSString *)encryptString withKey:(NSString *)key;\
@end
