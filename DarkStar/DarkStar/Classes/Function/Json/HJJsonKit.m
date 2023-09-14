
#import "HJJsonKit.h"
//#import "NSObject+JsonToVO.h"

@implementation HJJsonKit
+ (NSString *)stringFromDict:(NSDictionary *)aDict
{
    return [self stringFromDict:aDict options:0];
}

+ (NSString *)prettyStringFromDict:(NSDictionary *)aDict
{
    return [self stringFromDict:aDict options:NSJSONWritingPrettyPrinted];
}

+ (NSString *)stringFromDict:(NSDictionary *)aDict options:(NSJSONWritingOptions)option
{
    return [self stringFromJSONObject:aDict options:option];
}

+ (NSString *)stringFromJSONObject:(id)aObj options:(NSJSONWritingOptions)option
{
    NSString *json = nil;
    if ([NSJSONSerialization isValidJSONObject:aObj]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aObj options:option error:&error];
        if (!error) {
            json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        else {
            NSLog(@"error convert to json,%@,%@",error,aObj);
        }
    }
    
    return json;
}

+ (NSDictionary *)dictFromString:(NSString *)aString
{
    if (aString == nil) {
        return nil;
    }
    
    NSData *theData = [aString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSError *error = nil;
    
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
    
    if (error) {
        NSLog(@"error convert json string to dict,%@,%@", aString, error);
        return nil;
    }
    else {
        return resultDict;
    }
}

@end
