
#import "NSString+HexUnicode.h"

@implementation NSString (HexUnicode)

+ (NSString *)unicodeWithHexString:(NSString *)hexString {
    
    unsigned int codeValue;
    [[NSScanner scannerWithString:hexString] scanHexInt:&codeValue];
    
    return [NSString stringWithFormat:@"%C", (unichar)codeValue];;
}

@end
