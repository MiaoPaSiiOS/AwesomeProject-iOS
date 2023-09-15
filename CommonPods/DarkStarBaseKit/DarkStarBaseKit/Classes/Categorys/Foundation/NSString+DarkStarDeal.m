//
//  NSString+DarkStarDeal.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import "NSString+DarkStarDeal.h"
#import "NSString+DarkStarValid.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (DarkStarDeal)
#pragma mark - 空格处理
- (NSString *)ds_removeBothEndsWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)ds_removeBothEndsWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)ds_trimWhitespace {
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (NSString *)ds_trimAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - 字符串处理
//截取卡号最后六位
+ (NSString *)ds_getLastSixChar:(NSString *)string {
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
+ (NSString *)ds_getLastFourChar:(NSString *)string {
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
+ (NSString *)ds_getFirstFourChar:(NSString *)string {
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

+ (NSString *)ds_insertSpace:(NSString *)string {
    NSMutableString *tmpStr =[NSMutableString stringWithString:string];
    for (int i =0; i <string.length; i++) {
        if (i!=0 && i %4 ==0) {
            [tmpStr insertString:@" " atIndex:i+(i/4)-1];
        }
    }
    return [NSString stringWithString:tmpStr];
}

// 证件号显示处理320113198804118177
+ (NSString *)ds_replacedByStar:(NSString *)string end:(NSUInteger)end {
    return [NSString ds_replacedByStar:string begin:0 end:end];
}

// 证件号显示处理320113198804118177
+ (NSString *)ds_replacedByStar:(NSString *)string begin:(NSUInteger)begin end:(NSUInteger)end {
    if (string.length < begin+end) return string;
    NSMutableString *tempStr = [NSMutableString stringWithString:string];
    for (NSUInteger i = begin; i < string.length-end; i++) {
        [tempStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return [NSString stringWithString:tempStr];
}





#pragma mark - 字符串查找
- (NSArray <NSValue *> *)ds_rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range {
    NSMutableArray *array = [NSMutableArray array];
    [self ds_rangeOfString:searchString range:NSMakeRange(0, self.length) array:array options:mask];
    
    return array;
}

- (void)ds_rangeOfString:(NSString *)searchString
                range:(NSRange)searchRange
                array:(NSMutableArray *)array
              options:(NSStringCompareOptions)mask {

    NSRange range = [self rangeOfString:searchString options:mask range:searchRange];
    
    if (range.location != NSNotFound) {
        
        [array addObject:[NSValue valueWithRange:range]];
        [self ds_rangeOfString:searchString
                      range:NSMakeRange(range.location + range.length, self.length - (range.location + range.length))
                      array:array
                    options:mask];
    }
}


#pragma mark - 金额处理
- (NSString *)ds_transformToMoneyType {
    if (![NSString ds_isEmpty:self]) {
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
- (NSString *)ds_urlStringAppendParameters:(NSDictionary *)parameters {
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

+ (NSString *)ds_unicodeWithHexString:(NSString *)hexString {
    unsigned int codeValue;
    [[NSScanner scannerWithString:hexString] scanHexInt:&codeValue];
    return [NSString stringWithFormat:@"%C", (unichar)codeValue];;
}

- (NSString *)ds_md5 {
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




+ (NSString *)stringWithUTF32Char:(UTF32Char)char32 {
    char32 = NSSwapHostIntToLittle(char32);
    return [[NSString alloc] initWithBytes:&char32 length:4 encoding:NSUTF32LittleEndianStringEncoding];
}

+ (NSString *)stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length {
    return [[NSString alloc] initWithBytes:(const void *)char32
                                    length:length * 4
                                  encoding:NSUTF32LittleEndianStringEncoding];
}

- (void)enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block {
    NSString *str = self;
    if (range.location != 0 || range.length != self.length) {
        str = [self substringWithRange:range];
    }
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    UTF32Char *char32 = (UTF32Char *)[str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding];
    if (len == 0 || char32 == NULL) return;
    
    NSUInteger location = 0;
    BOOL stop = NO;
    NSRange subRange;
    UTF32Char oneChar;
    
    for (NSUInteger i = 0; i < len; i++) {
        oneChar = char32[i];
        subRange = NSMakeRange(location, oneChar > 0xFFFF ? 2 : 1);
        block(oneChar, subRange, &stop);
        if (stop) return;
        location += subRange.length;
    }
}

- (NSString *)stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
            - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
            - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
            - parameter string: The string to be percent-escaped.
            - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}


- (NSString *)stringByAppendingNameScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    return [self stringByAppendingFormat:@"@%@x", @(scale)];
}

- (NSString *)stringByAppendingPathScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

- (CGFloat)pathScale {
    if (self.length == 0 || [self hasSuffix:@"/"]) return 1;
    NSString *name = self.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    [name enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
        scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
    }];
    return scale;
}

- (void)enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

@end
