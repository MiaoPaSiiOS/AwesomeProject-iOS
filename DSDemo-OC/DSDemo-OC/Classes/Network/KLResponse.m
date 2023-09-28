//
//  KLResponse.m
//  AmenCore
//
//  Created by zhuyuhui on 2021/6/16.
//

#import "KLResponse.h"

@implementation KLResponse
- (instancetype)initWithResponseObject:(id)responseObject
                            parseError:(NSError *)parseError
{
    self = [super init];
    if (self) {
        self.responseObject = responseObject;
        self.error = parseError;
        if (parseError) {
            self.success    = NO;
        } else {
            if ([DSCommonMethods isDictEmptyOrNil:(responseObject)]) {
                self.success    = NO;
            } else {
                NSString *code = [DSCommonMethods safeString:(responseObject[@"code"])];
                if ([code isEqualToString:@"0"]) {
                    self.success    = YES;
                } else {
                    self.success    = NO;
                };
            }
        }
    }
    return self;

}

- (NSString *)message {
    if (self.success) {
        return nil;
    }
    if (self.error) {
        return [NSString stringWithFormat:@"%@",self.error.localizedDescription];
    } else if (self.responseObject) {
        return [NSString stringWithFormat:@"%@",[DSCommonMethods safeString:(self.responseObject[@"message"])]];
    }
    return nil;
}

@end
