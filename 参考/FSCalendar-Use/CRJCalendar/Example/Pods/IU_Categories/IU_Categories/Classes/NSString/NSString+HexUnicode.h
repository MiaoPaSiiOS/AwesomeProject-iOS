
#import <Foundation/Foundation.h>

@interface NSString (HexUnicode)

/**
 Transform hex string like '0xF181' to unicode '\u{F181}'.
 
 @param hexString The hex string like '0xF181'
 @return The unicode.
 */
+ (NSString *)unicodeWithHexString:(NSString *)hexString;

@end
