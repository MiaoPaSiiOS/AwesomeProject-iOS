//
//  AMENVocalPrintInfoUtil.h
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <Foundation/Foundation.h>
typedef void(^VocalStatus)(NSDictionary *_Nullable);
typedef void(^LeaveStatus)(void);

NS_ASSUME_NONNULL_BEGIN

@interface AMENVocalPrintInfoUtil : NSObject
+ (void)vocalOpenStatusDes:(VocalStatus)vStatus leave:(LeaveStatus)leave;
@end

NS_ASSUME_NONNULL_END
