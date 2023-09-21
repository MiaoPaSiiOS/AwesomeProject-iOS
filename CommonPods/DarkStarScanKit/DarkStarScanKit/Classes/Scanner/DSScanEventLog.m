//
//  DSScanEventLog.m
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import "DSScanEventLog.h"

@implementation DSScanEventLog

+ (void)scanLogWithType:(DSScanEventLogType)type withSubType:(NSInteger)subType withDict:(NSDictionary *)dict withDesc:(NSString *)desc {
//    NSString * eventId = [NSString stringWithFormat:@"%ld",(long)(kSRSScanEventLogID + type)];
//    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
//    [paramDict setObject:@(subType) forKey:kSRSScanSubTypeKey];
//    SRSLogIDFormatterModel *model = [[SRSLogIDFormatterModel alloc] init];
//    model.logID = @"101";
//    model.logIDDesc = @"扫码组件";
//    [SRSLogInterface trackLogEvent:eventId serviceID:model logMap:paramDict desc:desc];
}

@end
