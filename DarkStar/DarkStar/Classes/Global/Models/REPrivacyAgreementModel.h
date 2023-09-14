//
//  REPrivacyAgreementModel.h
//  REWLY
//
//  Created by zhuyuhui on 2023/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REPrivacyAgreementModel : NSObject
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *entryCode;
@property(nonatomic, copy) NSString *entryType;
@property(nonatomic, copy) NSString *entryTypeStr;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *updateTime;
@end

NS_ASSUME_NONNULL_END
/*
 {
     "content": "<p>ssssssssssss</p>",
     "entryCode": "eeeeeeeee",
     "entryType": "11",
     "entryTypeStr": "App隐私协议",
     "id": 19090611926067,
     "status": 1,
     "title": "werwe",
     "updateTime": 1680443177000
 }
 */
