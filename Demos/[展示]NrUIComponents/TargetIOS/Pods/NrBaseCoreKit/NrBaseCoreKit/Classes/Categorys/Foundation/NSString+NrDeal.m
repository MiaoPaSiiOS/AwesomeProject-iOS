//
//  NSString+NrDeal.m
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import "NSString+NrDeal.h"
#import "NSString+NrValid.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NrDeal)
#pragma mark - 空格处理
- (NSString *)nr_removeBothEndsWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)nr_removeBothEndsWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)nr_trimWhitespace {
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (NSString *)nr_trimAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - 字符串处理
//截取卡号最后六位
+ (NSString *)nr_getLastSixChar:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) return @"";
    if (string.length>0) {
        if (string.length>6) {
            return [string substringFromIndex:string.length - 6];
        } else {
            return string;
        }
    } else {
        return @"";
    }
}

//截取卡号最后四位
+ (NSString *)nr_getLastFourChar:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) return @"";
    if (string.length>0) {
        if (string.length>4) {
            return [string substringFromIndex:string.length - 4];
        } else {
            return string;
        }
    } else {
        return @"";
    }
}

/** 获取前4位 */
+ (NSString *)nr_getFirstFourChar:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) return @"";
    if (string.length > 0) {
        if (string.length >= 4) {
            return [string substringToIndex:4];
        } else {
            return string;
        }
    } else {
        return @"";
    }
}

+ (NSString *)nr_insertSpace:(NSString *)string {
    NSMutableString *tmpStr =[NSMutableString stringWithString:string];
    for (int i =0; i <string.length; i++) {
        if (i!=0 && i %4 ==0) {
            [tmpStr insertString:@" " atIndex:i+(i/4)-1];
        }
    }
    return [NSString stringWithString:tmpStr];
}

// 证件号显示处理320113198804118177
+ (NSString *)nr_replacedByStar:(NSString *)string end:(NSUInteger)end {
    return [NSString nr_replacedByStar:string begin:0 end:end];
}

// 证件号显示处理320113198804118177
+ (NSString *)nr_replacedByStar:(NSString *)string begin:(NSUInteger)begin end:(NSUInteger)end {
    if (string.length < begin+end) return string;
    NSMutableString *tempStr = [NSMutableString stringWithString:string];
    for (NSUInteger i = begin; i < string.length-end; i++) {
        [tempStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return [NSString stringWithString:tempStr];
}





#pragma mark - 字符串查找
- (NSArray <NSValue *> *)nr_rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range {
    NSMutableArray *array = [NSMutableArray array];
    [self nr_rangeOfString:searchString range:NSMakeRange(0, self.length) array:array options:mask];
    
    return array;
}

- (void)nr_rangeOfString:(NSString *)searchString
                range:(NSRange)searchRange
                array:(NSMutableArray *)array
              options:(NSStringCompareOptions)mask {

    NSRange range = [self rangeOfString:searchString options:mask range:searchRange];
    
    if (range.location != NSNotFound) {
        
        [array addObject:[NSValue valueWithRange:range]];
        [self nr_rangeOfString:searchString
                      range:NSMakeRange(range.location + range.length, self.length - (range.location + range.length))
                      array:array
                    options:mask];
    }
}


#pragma mark - 金额处理
- (NSString *)nr_transformToMoneyType {
    if (![NSString nr_isEmpty:self]) {
        NSString *string = (NSString *)self;
        if ([string containsString:@","]) {
            string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
        }
        if ([string regularExpression:@"^\\d+([/.]\\d+)?$"] || [string regularExpression:@"^[/.]\\d+?$"]) {
            double money = [string doubleValue];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            // 设置格式
            [numberFormatter setPositiveFormat:@"###,##0.00;"];
            NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
            return formattedNumberString;
        }
    }
    return self;
}

- (BOOL)regularExpression:(NSString *)patternStr{
    if ([self isKindOfClass:[NSString class]]) {
        NSString *objStr = [NSString stringWithFormat:@"%@", self];
        if (!objStr.length) return NO;
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternStr  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines error:&error];
        if (error) return NO;
        NSUInteger intNum = [regex numberOfMatchesInString:objStr options:0 range:NSMakeRange(0, objStr.length)];
        return intNum == 0 ? NO : YES;
    }
    return NO;
}



#pragma mark - 其他
- (NSString *)nr_urlStringAppendParameters:(NSDictionary *)parameters {
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:self];
    if ([parameters allKeys]) {
        [mutableUrl appendString:@"?"];
        for (id key in parameters) {
            NSString *value = [parameters objectForKey:key];
            [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    }
    NSString *urlStr = @"";
    if (mutableUrl.length > 1) {
        urlStr = [mutableUrl substringToIndex:mutableUrl.length - 1];
    }
    return urlStr;
}

+ (NSString *)nr_unicodeWithHexString:(NSString *)hexString {
    unsigned int codeValue;
    [[NSScanner scannerWithString:hexString] scanHexInt:&codeValue];
    return [NSString stringWithFormat:@"%C", (unichar)codeValue];;
}

- (NSString *)nr_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end
