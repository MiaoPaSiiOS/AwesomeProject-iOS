
#import "DSAuthorityLog.h"

static int kDSAuthorityLogEventID = 100001;
static NSString * const kDSAuthorityLogSubTypeKey = @"kDSAuthorityLogSubTypeKey";


@implementation DSAuthorityLog

+ (void)authorityLogWithType:(DSAuthorityLogType)type withSubType:(NSInteger)subType withDict:(NSDictionary *)dict withDesc:(NSString *)desc {
    NSString * eventId = [NSString stringWithFormat:@"%ld",(long)(kDSAuthorityLogEventID + type)];
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [paramDict setObject:@(subType) forKey:kDSAuthorityLogSubTypeKey];
    NSLog(@"%@-%@-%@",eventId,desc,paramDict);
}

@end
