//
//  DSNetResponse.m
//  DarkStarNetWorkKit
//
//  Created by zhuyuhui on 2021/6/16.
//

#import "DSNetResponse.h"

@implementation DSNetResponse
- (instancetype)initWithResponseObject:(id)responseObject
                            parseError:(NSError *)parseError
{
    self = [super init];
    if (self) {
        self.responseObject = responseObject;
        self.error = parseError;
        if (parseError) {
            self.success    = NO;
        }else{
            self.success    = YES;
        }
    }
    return self;

}

@end
