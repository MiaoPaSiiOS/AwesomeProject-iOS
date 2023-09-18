
#import "NrAuthorityLog.h"

static int kNrAuthorityLogEventID = 100001;
static NSString * const kNrAuthorityLogSubTypeKey = @"kNrAuthorityLogSubTypeKey";


@implementation NrAuthorityLog

+ (void)authorityLogWithType:(NrAuthorityLogType)type withSubType:(NSInteger)subType withDict:(NSDictionary *)dict withDesc:(NSString *)desc {
    NSString * eventId = [NSString stringWithFormat:@"%ld",(long)(kNrAuthorityLogEventID + type)];
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [paramDict setObject:@(subType) forKey:kNrAuthorityLogSubTypeKey];
    NSLog(@"%@-%@-%@",eventId,desc,paramDict);
}

@end
