//
//  RETools.m
//  LJDemo
//
//  Created by LJ on 15/7/20.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "RETools.h"
//#import "sys/utsname.h"
//#import <AddressBook/AddressBook.h>
//#import <CommonCrypto/CommonDigest.h>
//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>
//#import <AVFoundation/AVFoundation.h>
//
//#include <sys/types.h>
//#include <sys/sysctl.h>
//#include <sys/socket.h>  // Per msqr
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>
//#import  <ifaddrs.h>
//#import  <arpa/inet.h>
//#import  <net/if.h>
//
//#define IOS_CELLULAR @"pdp_ip0"
//#define IOS_WIFI     @"en0"
//#define IOS_VPN      @"utun0"
//#define IP_ADDR_IPv4 @"ipv4"
//#define IP_ADDR_IPv6 @"ipv6"
//
//#define UDKREFollowLocationIP @"UDKREFollowLocationIP"


@implementation RETools
//#pragma Mark --------
//+ (UIImage *)launchImage{
//
//    UIImage *image = nil;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    if (height == 568) {
//        image = [UIImage imageNamed:@"LaunchImage-700-568h"];
//    }else if (height == 812) {
//        image = [UIImage imageNamed:@"LaunchImage-1100-2436h"];
//    }else if (height == 667) {
//        image = [UIImage imageNamed:@"LaunchImage-800-667h"];
//    }else if (height == 736) {
//        image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
//    }else {
//        image = [UIImage imageNamed:@"LaunchImage-700"];
//    }
//    return image;
//}
//+ (NSString *)getStringFromUrl:(NSString*)url needle:(NSString *)needle {
//    NSString * str = nil;
//    NSRange start = [url rangeOfString:needle];
//    if (start.location != NSNotFound) {
//        NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
//        NSUInteger offset = start.location+start.length;
//        str = end.location == NSNotFound ? [url substringFromIndex:offset]
//        : [url substringWithRange:NSMakeRange(offset, end.location)];
//        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
//    return (str == nil||[str isEqual:[NSNull null]])?@"":str;
//}
#pragma mark -----  屏幕分辨率 ----------
///**
// *  获取屏幕分辨率
// *
// *  @return 屏幕分辨率
// */
//+ (NSString *)getScreenScrale
//{
//    CGRect rect_screen = [[UIScreen mainScreen]bounds];
//
//    // 分辨率
//    NSString *scral = [NSString stringWithFormat:@"%.fx%.f",rect_screen.size.height * 2,rect_screen.size.width * 2];
//
//    return scral;
//}
//
///**
// *  获取屏幕高比例
// *
// *  @return 屏幕高比例
// */
//+(CGFloat)getScreenHightscale
//{
//    CGFloat scaleY;
//    float standard = 667.0;
//
//    if(IS_IPHONE_4)
//    {
//        scaleY = 480.0 / standard;
//    }
//    else if (IS_IPHONE_5)
//    {
//        scaleY = 568.0 / standard;
//    }
//    else  if (IS_IPHONE_6)
//    {
//        scaleY = 667.0 / standard;
//    }
//    else if (IS_IPHONE_6P)
//    {
//        scaleY = 736.0 / standard;
//    }
//    else if (IS_IPHONE_X)
//    {
//        scaleY = 812.0 / standard;
//    }
//
//    else if (IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
//    {
//        scaleY = 896.0 / standard;
//    }
//    else
//    {
//        scaleY = 1.0f;
//    }
//
//    return scaleY;
//}
//
///**
// *  获取屏幕宽比例
// *
// *  @return 屏幕宽比例
// */
//+(CGFloat)getScreenWidthscale
//{
//    CGFloat scaleX;
//    float standard = 375.0;
//    if (IS_IPHONE_4 || IS_IPHONE_5) {
//        scaleX = 320.0 / standard;
//    }
//    else if (IS_IPHONE_6 || IS_IPHONE_X)
//    {
//        scaleX = 375.0 / standard;
//    }
//    else if (IS_IPHONE_6P || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
//    {
//        scaleX = 414.0 / standard;
//    }
//    else
//    {
//        scaleX = 1.0f;
//    }
//
//    return scaleX;
//}

#pragma mark ------ 权限相关 ---------
////判断相机是否开启权限
//+ (BOOL)isCanUsePhotos {
//
//    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
//    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//        return NO;
//    }
//    return YES;
//}
////判断定位是否开启
//+ (BOOL)isLocationServiceOpen {
//    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//        return NO;
//    } else
//        return YES;
//}
#pragma mark ----  string  ---------------

/*
 * 判断是否为空
 */
+ (BOOL)iSNull:(id)obj
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]] || obj == NULL ) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        //避免model转化为空字符串情况
        NSString * str = [NSString stringWithFormat:@"%@",obj];
        return [self stringIsEmpty:str];
    }
    return NO;
}
+(BOOL)iSNotNull:(id)obj
{
    BOOL res = [self iSNull:obj];
    return !res;
}

+ (BOOL)stringIsEmpty:(NSString*)str
{
    if ([str isKindOfClass:[NSString class]]) {
        
        if (str.length == 0) {
            return TRUE;
        }
        NSString *str1 = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([str1 isEqual:@""]) {
            return TRUE;
        }
        if ([str1 isEqualToString:@"null"]) {
            return YES;
        }
        if ([str1 isEqualToString:@"nil"]) {
            return YES;
        }
    }else
    {
        return [self iSNull:str];
    }
    return FALSE;
}
//
///**
// *  判断是非是无效的密码。
// *
// *  @param password 字符串
// *
// *  @return BOOL值
// *          YES: 无效密码。
// *           NO: 有效密码。
// */
//+ (BOOL)isInvalidPassword:(NSString *)password
//{
//    return [self isInvalidPassword:password min:6 max:16];
//}
//
//+ (BOOL)isInvalidPassword:(NSString *)password min:(int)min max:(int)max
//{
//    if ([self stringIsEmpty:password])
//    {
//        //        [self showError:@"密码不能为空"];
//        return YES;
//    }
//
//    // NSString * regex = @"(^[A-Za-z0-9]{6,20}$)";
//    NSString *regex =
//    @"(^[\\d+[a-zA-Z]+[-`=\\\[\\];',./"
//    @"~!@#$%^&*()_+|{}:\"<>?]*)|([a-zA-Z]+\\d+[-`=\\\[\\];',./"
//    @"~!@#$%^&*()_+|{}:\"<>?]*)|(\\d+[-`=\\\[\\];',./"
//    @"~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+)|([a-zA-Z]+[-`=\\\[\\];',./"
//    @"~!@#$%^&*()_+|{}:\"<>?]*\\d+)|([-`=\\\[\\];',./"
//    @"~!@#$%^&*()_+|{}:\"<>?]*\\d+[a-zA-Z]+)|([-`=\\\[\\];',./"
//    @"~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+\\d+]";
//    regex = [NSString stringWithFormat:@"%@{%d,%d}$)", regex, min, max];
//
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if ([pred evaluateWithObject:password])
//    {
//        return NO;
//    }
//    else if (password.length < min || password.length > max)
//    {
//    }
//    else
//    {
//    }
//    return YES;
//}
//
////至少八个字符，至少一个大写字母，一个小写字母，一个数字和一个特殊字符：
////"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}"
//+ (BOOL)isEffectivePassword:(NSString *)password{
//
//    if ([self stringIsEmpty:password])
//    {
//        return NO;
//    }
//
////    NSString *regex = @"^(?=.*?[0-9])(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[;:=*@])[0-9A-Za-z;:=*@)]{6,18}$";
//
//    NSString *regex = @"^(?=.*?[0-9])(?=.*?[A-Za-z])(?=.*?[;:=*@])[0-9A-Za-z]{6,18}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if ([pred evaluateWithObject:password])
//    {
//        return YES;
//    }
//    return NO;
//}
//
//// 扁平json字串。
//+ (NSString *)flatJsonString:(id)obj
//{
//    @try
//    {
//        NSData *jsonData = [NSJSONSerialization  //
//                            dataWithJSONObject:obj
//                            options:0
//                            error:nil];
//        if (nil == jsonData || jsonData.length <= 0)
//        {
//            return @"";
//        }
//
//        NSString *jsonString = [[NSString alloc]  //
//                                initWithData:jsonData
//                                encoding:NSUTF8StringEncoding];
//        return [self forceString:jsonString];
//    }
//    @catch (NSException *exception)
//    {
//        return @"";
//    }
//}
///**
// *  验证固定电话格式。
// */
//+ (BOOL)isValidateTelephone:(NSString *)telephone
//{
//    if ([self iSNull:telephone])
//    {
//        return NO;
//    }
//
//    //形如： 0511-12345678-1234
//    NSString *phoneRegex = @"^(\\d{3,4}|\\d{3,4}-)?\\d{7,8}(-\\d{1,4})?$";
//    NSPredicate *phoneTest =
//    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//
//    if (![phoneTest evaluateWithObject:telephone])
//    {
//        //        [self showError:@"电话号码格式错误"];
//        return NO;
//    }
//
//    return YES;
//}
//
//
///**
// *  检测 输入中是否含有特殊字符
// *
// *  @param str 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)hasSpecialCharacter:(NSString *)str
//{
//    if (![str isKindOfClass:[NSString class]])
//    {
//        return YES;
//    }
//
//    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
//    NSRange urgentRange = [str rangeOfCharacterFromSet:[NSCharacterSet
//                                                        characterSetWithCharactersInString:
//                                                        @"~￥#&*<>《》()[]{}【】^@/"
//                                                        @"￡¤￥|§¨「」『』￠￢￣~@#"
//                                                        @"￥&*（）——+|《》$_€。"]];
//    return urgentRange.location != NSNotFound &&
//    urgentRange.length != NSNotFound && urgentRange.length != 0;
//}
//
+ (NSURL *)urlFromString:(NSString *)string
{
    if ([self iSNull:string])
    {
        return [NSURL URLWithString:@""];
    }

    NSURL *url = nil;
    if ([string isKindOfClass:[NSURL class]])
    {
        url = (NSURL *)string;
    }
    else if ([string isKindOfClass:[NSString class]])
    {
        if ([[string substringToIndex:2] isEqualToString:@"//"]) {
            NSString * subString = @"http:";
            if ([H5HOST containsString:@"https:"]) {
                subString = @"https:";
            }
            string = [subString stringByAppendingString:string];
        }
        url = [NSURL URLWithString:string];
        if (nil == url)
        {
            NSString *encoding = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [NSURL URLWithString:encoding];
        }
    }

    if (nil == url)
    {
        url = [NSURL URLWithString:@""];
    }

    return url;
}
//
///**
// *  删除请求图片字符串中的空格并压缩比例
// *
// *  @param spaceStr 传入的字符串
// *
// *  @param scale 传入的比例参数
// *
// *  @return 返回的没有空格的url
// */
//+ (NSURL *)removeSpace:(NSString *)spaceStr scale:(NSInteger)scale
//{
//    NSURL *url;
//    NSString *escape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
//    if ([spaceStr rangeOfString:@" "].location != NSNotFound)
//    {
//
//        NSCharacterSet *charac = [[NSCharacterSet characterSetWithCharactersInString:escape] invertedSet];
//        NSString *encodedUrl = [spaceStr stringByAddingPercentEncodingWithAllowedCharacters:charac];
//        url = [NSURL URLWithString:[self getTheImgWithScale:scale withUrlStr:encodedUrl]];
//    }
//    else
//    {
//        url = [NSURL URLWithString:[self getTheImgWithScale:scale withUrlStr:spaceStr]];
//    }
//    return url;
//}
//
///**
// *  删除请求图片字符串中的空格
// *
// *  @param spaceStr 传入的字符串
// *
// *  @return 返回的没有空格的url
// */
//+ (NSURL *)removeSpace:(NSString *)spaceStr
//{
//    NSString *escape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
//    NSURL *url;
//    if ([spaceStr rangeOfString:escape].location != NSNotFound)
//    {
//        NSCharacterSet *charac = [[NSCharacterSet characterSetWithCharactersInString:escape] invertedSet];
//        NSString *encodedUrl = [spaceStr stringByAddingPercentEncodingWithAllowedCharacters:charac];
//        url = [NSURL URLWithString:encodedUrl];
//    }
//    else
//    {
//        url = [NSURL URLWithString:spaceStr];
//    }
//    return url;
//}
//
///**
// *  从金山云获取指定比例的图片
// *  @return 大小
// */
//+ (NSString *)getTheImgWithScale:(NSInteger)scale withUrlStr:(NSString *)urlStr
//{
//    return [NSString stringWithFormat:@"%@@base@tag=imgScale&h=%ld&w=%ld&m=0",urlStr,100*scale,100*scale];
//}
//
//
//
//+ (id)safeString:(id)object
//{
//    if( [self iSNull:object])
//    {
//        return @"";
//    }
//    else
//    {
//        return object;
//    }
//}
//
+ (NSString*)forceString:(id)object
{
    if( [self iSNull:object])
    {
        return @"";
    }
    else
    {
        return [NSString stringWithFormat:@"%@", object];
    }
}
//
///**
// *  是否是纯数字判断
// *
// *  @param number 字符串
// *
// *  @return BOOL值
// */
//+(BOOL)checkNumber:(NSString *)number
//{
//    NSString *regex = @"^[1-9]\\d*|0$";
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:number];
//    return isMatch;
//}
///**
// *  用户名判断
// *
// *  @param nameStr 字符串
// *
// *  @return BOOl值
// */
//+ (BOOL)checkNameString:(NSString *)nameStr
//{
//    NSString * regex = @"^[a-zA-Z][a-zA-Z0-9_]{5,20}$";
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:nameStr];
//    return isMatch;
//}
//
///**
// *  密码判断
// *
// *  @param PassStr 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)checkPassString:(NSString *)PassStr
//{
//    NSString * regex = @"(^[\\d+[a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|([a-zA-Z]+\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|(\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+)|([a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+[a-zA-Z]+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+\\d+]{6,20}$)";
//
//    //    NSString * regex = @"(^[A-Za-z0-9]{6,20}$)";
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:PassStr];
//    return isMatch;
//}
//
///**
// *  手机号码验证
// *
// *  @param mobile 字符串
// *
// *  @return BOOL值
// */
+(BOOL)isValidateMobile:(NSString *)mobile
{
    if ([self iSNull:mobile]) {
        [self re_showError:@"手机号码不能为空"];
        return NO;
    }

    // @"^(1)\\d{10}$"
    //手机号以13， 15，18、14、17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|176|170)\\d{8}$";
    phoneRegex = @"^(1)\\d{10}$";  // 简化电话判断，11位纯数字即可。
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if (mobile.length != 11 || ![phoneTest evaluateWithObject:mobile])
    {
        [self re_showError:@"请输入正确的手机号码"];
        return NO;
    }
    return YES;
}
//
///**
// *  验证码验证
// *
// *  @param code 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)validateVCodeWithString:(NSString*)code
//{
//    return [code length]==6?YES:NO;
//}
//
///**
// *  邮箱验证
// *
// *  @param email 字符串
// *
// *  @return BOOL值
// */
//+(BOOL)isValidateEmail:(NSString *)email
//{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:email];
//}
//
////+ (BOOL)ishasPrefixForURL:(NSString *)string
////{
////    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
////    NSPredicate *url = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regulaStr];
////    return [url evaluateWithObject:string];
////}
//
///**
// *  身份证号验证
// *
// *
// *  @return BOOL值
// */
//+ (BOOL)validateIdentityCard:(NSString *)identityCard
//{
//    BOOL flag;
//    // 身份证号为15位或18位
//    if (identityCard.length != 15 || identityCard.length != 18)
//    {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:identityCard];
//}
//
///**
// *  车牌号验证
// *
// *  @param carNo 字符串
// *
// *  @return BOOL值
// */
//+(BOOL) validateCarNo:(NSString *)carNo
//{
//    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
//    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    NSLog(@"carTest is %@",carTest);
//    return [carTest evaluateWithObject:carNo];
//}
//
///**
// *  检测 输入中是否含有特殊字符
// *
// *  @param str 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)isIncludeSpecialCharact: (NSString *)str
//{
//    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
//    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。"]];
//    if (urgentRange.location == NSNotFound)
//    {
//        // 不含 特殊字符
//        return NO;
//    }
//    // 含有 特殊字符
//    return YES;
//}
//
///**
// *  判断 输入长度
// *
// *  @param inputStr 输入的字符串
// *  @param typeStr  提示类型字符串
// *
// *  @return BOOL值
// */
//+ (BOOL) stringlength:(NSString *)inputStr typeStr:(NSString *)typeStr
//{
//    if (inputStr.length > 16)
//    {
//        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@最多16个字符",typeStr] delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
//        [alter show];
//        return NO;
//    }
//    else if(inputStr.length < 6)
//    {
//        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"" message:typeStr delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
//        [alter show];
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}
//
///**
//*  url合法校验
//*
//*  @param identityUrl url
//*
//*  @return BOOL值
//*/
//+ (BOOL)validateUrl: (NSString *) identityUrl {
//    NSString *pattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
//    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
//    NSArray *regexArray = [regex matchesInString:identityUrl options:0 range:NSMakeRange(0, identityUrl.length)];
//    if (regexArray.count > 0) return YES; else return NO;
//}
//
//
//#pragma mark -- 提示框 --
//+(void)showMyMessage:(NSString*)aInfo
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:XPLocalizedString(@"提示", nil) message:aInfo delegate:self cancelButtonTitle:XPLocalizedString(@"确定", nil)  otherButtonTitles:nil, nil];
//    [alertView show];
//}
//
///**
// *  字符串拆分
// *
// *  @param dict 字符串
// *
// *  @return 字典
// */
//+ (NSDictionary *)getStringWithDict:(NSDictionary *)dict
//{
//    NSDictionary *dict1 = [NSDictionary dictionary];
//    NSArray *array = [NSArray arrayWithArray:[dict objectForKey:@"piclist"]];
//    for (int i = 0; i < array.count; i ++)
//    {
//        NSDictionary *dict2 = [array objectAtIndex:i];
//        // 文字数组
//        NSMutableArray *arr = [NSMutableArray array];
//        NSArray *wordAnimation = [[dict2 objectForKey:@"word_animation"] componentsSeparatedByString:@"|"];
//        NSArray *wordColor = [[dict2 objectForKey:@"word_color"] componentsSeparatedByString:@"|"];
//        NSArray *word_font = [[dict2 objectForKey:@"word_font"] componentsSeparatedByString:@"|"];
//        NSArray *word_size = [[dict2 objectForKey:@"word_size"] componentsSeparatedByString:@"|"];
//        NSArray *words = [[dict2 objectForKey:@"words"] componentsSeparatedByString:@"|"];
//        NSArray *pos1 = [[dict2 objectForKey:@"pos1"] componentsSeparatedByString:@"|"];
//        NSArray *pos2 = [[dict2 objectForKey:@"pos2"] componentsSeparatedByString:@"|"];
//
//
//        for (int i = 0; i < pos1.count; i ++)
//        {
//            [arr addObject:[pos1 objectAtIndex:i]];
//            [arr addObject:[pos2 objectAtIndex:i]];
//            [arr addObject:[words objectAtIndex:i]];
//            [arr addObject:[word_size objectAtIndex:i]];
//            [arr addObject:[word_font objectAtIndex:i]];
//            [arr addObject:[wordColor objectAtIndex:i]];
//            [arr addObject:[wordAnimation objectAtIndex:i]];
//        }
//        [dict2 setValue:arr forKey:@"words_arr"];
//    }
//
//    return dict1;
//}
//
///**
// *  动态改变图片大小
// *
// *  @param image 传进来的初始图片
// *  @param size  图片比例
// *
// *  @return 图片
// */
//+(UIImage *) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
//{
//    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
//
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    //    UIImage *scaledImage = [UIImage RLLibraryImageNamed];
//
//    UIGraphicsEndImageContext();
//    //返回的就是已经改变的图片
//    return scaledImage;
//}
//
///**
// *  改变图片 只拉伸中间点
// *
// *  @param size 拉伸尺寸
// *
// *  @return 拉伸尺寸
// */
//+(UIEdgeInsets)resizeDetail:(CGSize)size
//{
//
//    CGFloat top = 100; // 顶端盖高度
//    CGFloat bottom = size.height; // 底端盖高度
//    CGFloat left = 0; // 左端盖宽度
//    CGFloat right = 0; // 右端盖宽度
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//
//    //    self.detailBG.image = [[UIImage RLLibraryImageNamed:@"rl_warm_detail_bg.png"] resizableImageWithCapInsets:insets];
//    return insets;
//}
//
//
//
//
//
///**
// *  图片旋转
// *
// *  @param imageView 图片
// *
// *  @return 可旋转的图片
// */
//+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView
//{
//    CABasicAnimation *animation = [ CABasicAnimation
//                                   animationWithKeyPath: @"transform" ];
//    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//
//    //围绕Z轴旋转，垂直与屏幕
//    animation.toValue = [ NSValue valueWithCATransform3D:
//
//                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
//    animation.duration = 1;
//    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
//    animation.cumulative = YES;
//    animation.repeatCount = 100000000000000000;
//
//    //在图片边缘添加一个像素的透明区域，去图片锯齿
//    //    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
//    //    UIGraphicsBeginImageContext(imageRrect.size);
//    //    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
//    //    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    //    UIGraphicsEndImageContext();
//
//    [imageView.layer addAnimation:animation forKey:nil];
//    return imageView;
//}
//
//+ (void)stopRound:(UIView *)view
//{
//    //    NSTimeInterval
//
//    [view.layer removeAllAnimations];
//}
////animation.repeatCount = 1000;
////这个你要想一直旋转，设置一个无穷大就得了
////
////停止的话直接这样就停止了
////[self.view.layer removeAllAnimates];
//
///**
// *  字符串转 字典
// *
// *  @param str 字符串
// *
// *  @return 字典
// */
//+(NSDictionary *)stringToDict:(NSString *)str
//{
//
//    NSData *JSONData = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//    return responseJSON;
//}
//
///**
// *  清楚缓存
// */
//+(void)clearCache
//{
//    NSLog(@"清除缓存");
//    dispatch_async(
//                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//                   , ^{
//                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//
//                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//                       //                       NSLog(@"files :%lf",[files count]);
//                       for (NSString *p in files)
//                       {
//                           NSError *error;
//                           NSString *path = [cachPath stringByAppendingPathComponent:p];
//                           if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//                           {
//                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//                           }
//                       }
//                       //                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
//                   });
//
//}
//
///**
// *  缓存清除成功
// */
//+(void)clearCacheSuccess
//{
//    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:XPLocalizedString(@"清除成功", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alterView show];
//    [alterView dismissWithClickedButtonIndex:0 animated:YES];
//}
//
///**
// *  取消 模糊背景
// */
//+(void)removeGause:(UIView *)supperView
//{
//    //       UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    for (UIView *view in supperView.subviews)
//    {
//        if (view.tag == 999999)
//        {
//            [view removeFromSuperview];
//        }
//    }
//}
//
///**
// *  获取沙盒目录
// */
//+ (NSString *)applicationDocumentsDirectory
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//
//    return docDir;
//}
//
///**
// *  获得 文件的大小
// *
// *  @param filePath 文件夹路径字符串
// *
// *  @return 文件大小
// */
//+ (CGFloat) fileSizeAtPath:(NSString*) filePath
//{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath])
//    {
//        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize] / 1024 / 1024;
//    }
//    return 0;
//}
//
///**
// *   获得某个范围内的屏幕图像
// *
// *  @param view  截图的View
// *  @param frame 截图区域大小
// *
// *  @return 返回截取的图片
// */
//+ (UIImage *)imageFromView:(UIView *)view frame:(CGRect)frame
//{
//    CGFloat scale = 2.0;
//
//    UIGraphicsBeginImageContext(view.frame.size);
//    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    UIRectClip(frame);
//    [view.layer renderInContext:context];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
//
///**
// *   高斯模糊
// *
// *  @param image 需要模糊的图片
// *
// *  @return 模糊后的图片
// */
//+ (UIImage *)gauseImgWithImage:(UIImage *)image
//{
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *inputImage = [[CIImage alloc]initWithImage:image];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:inputImage forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    CGImageRef CGImage = [context createCGImage:result fromRect:[result extent]];
//    UIImage *retImage = [UIImage imageWithCGImage:CGImage];
//    CGImageRelease(CGImage);
//    return retImage;
//}
//
///**
// *  颜色转化
// *
// *
// *  @return uicolor
// */
//+(CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
//{
//    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
//    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
//    unsigned hexComponent;
//    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
//    return hexComponent / 255.0;
//}
//
//+(UIColor *)colorWithHexString:(NSString *)colorStr{
//    NSString *colorString = [[colorStr stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
//    CGFloat alpha, red, blue, green;
//    switch ([colorString length]) {
//        case 3: // #RGB
//            alpha = 1.0f;
//            red   = [self colorComponentFrom: colorString start: 0 length: 1];
//            green = [self colorComponentFrom: colorString start: 1 length: 1];
//            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
//            break;
//        case 4: // #ARGB
//            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
//            red   = [self colorComponentFrom: colorString start: 1 length: 1];
//            green = [self colorComponentFrom: colorString start: 2 length: 1];
//            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
//            break;
//        case 6: // #RRGGBB
//            alpha = 1.0f;
//            red   = [self colorComponentFrom: colorString start: 0 length: 2];
//            green = [self colorComponentFrom: colorString start: 2 length: 2];
//            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
//            break;
//        case 8: // #AARRGGBB
//            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
//            red   = [self colorComponentFrom: colorString start: 2 length: 2];
//            green = [self colorComponentFrom: colorString start: 4 length: 2];
//            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
//            break;
//        default:
//            return nil;
//    }
//    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
//}
//
///**
// *  获取设备型号
// *
// *  @return 设备型号
// */
//+ (NSString *)getDeviceName {
//
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//
//    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
//    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
//    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
//    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
//    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
//    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4 (CDMA)";
//    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
//    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
//    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5 (GSM+CDMA)";
//    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5C";
//    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5C";
//    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5S";
//    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5S";
//    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
//    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
//    ///////
//    if ([platform isEqualToString:@"iPhone9,1"]) return @"国行、日版、港行iPhone 7";
//    if ([platform isEqualToString:@"iPhone9,2"]) return @"港行、国行iPhone 7 Plus";
//    if ([platform isEqualToString:@"iPhone9,3"]) return @"美版、台版iPhone 7";
//    if ([platform isEqualToString:@"iPhone9,4"]) return @"美版、台版iPhone 7 Plus";
//    if ([platform isEqualToString:@"iPhone10,1"])return @"国行(A1863)、日行(A1906)iPhone 8";
//    if ([platform isEqualToString:@"iPhone10,4"])return @"美版(Global/A1905)iPhone 8";
//    if ([platform isEqualToString:@"iPhone10,2"])return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
//    if ([platform isEqualToString:@"iPhone10,5"])return @"美版(Global/A1897)iPhone 8 Plus";
//    if ([platform isEqualToString:@"iPhone10,3"])return @"国行(A1865)、日行(A1902)iPhone X";
//    if ([platform isEqualToString:@"iPhone10,6"])return @"美版(GlobaliPhone X";
//
//    if([platform isEqualToString:@"iPod1,1"])    return@"iPod Touch (1 Gen)";
//    if([platform isEqualToString:@"iPod2,1"])    return@"iPod Touch (2 Gen)";
//    if([platform isEqualToString:@"iPod3,1"])    return@"iPod Touch (3 Gen)";
//    if([platform isEqualToString:@"iPod4,1"])    return@"iPod Touch (4 Gen)";
//    if([platform isEqualToString:@"iPod5,1"])    return@"iPod Touch (5 Gen)";
//
//    if([platform isEqualToString:@"iPad1,1"])    return@"iPad";
//    if([platform isEqualToString:@"iPad1,2"])    return@"iPad 3G";
//    if([platform isEqualToString:@"iPad2,1"])    return@"iPad 2 (WiFi)";
//    if([platform isEqualToString:@"iPad2,2"])    return@"iPad 2";
//    if([platform isEqualToString:@"iPad2,3"])    return@"iPad 2 (CDMA)";
//    if([platform isEqualToString:@"iPad2,4"])    return@"iPad 2";
//    if([platform isEqualToString:@"iPad2,5"])    return@"iPad Mini (WiFi)";
//    if([platform isEqualToString:@"iPad2,6"])    return@"iPad Mini";
//    if([platform isEqualToString:@"iPad2,7"])    return@"iPad Mini (GSM+CDMA)";
//    if([platform isEqualToString:@"iPad3,1"])    return@"iPad 3 (WiFi)";
//    if([platform isEqualToString:@"iPad3,2"])    return@"iPad 3 (GSM+CDMA)";
//    if([platform isEqualToString:@"iPad3,3"])    return@"iPad 3";
//    if([platform isEqualToString:@"iPad3,4"])    return@"iPad 4 (WiFi)";
//    if([platform isEqualToString:@"iPad3,5"])    return@"iPad 4";
//    if([platform isEqualToString:@"iPad3,6"])    return@"iPad 4 (GSM+CDMA)";
//    if([platform isEqualToString:@"iPad4,1"])    return@"iPad Air";
//    if([platform isEqualToString:@"iPad4,2"])    return@"iPad Air";
//    if([platform isEqualToString:@"iPad4,4"])    return@"iPad Mini 2";
//    if([platform isEqualToString:@"iPad4,5"])    return@"iPad Mini 2";
//
//    if([platform isEqualToString:@"i386"])       return@"Simulator";
//    if([platform isEqualToString:@"x86_64"])     return@"Simulator";
//
//    return [[UIDevice currentDevice] model];
//}
////获取操作系统
//+ (NSString *)getLocalOS
//{
//    // 2  MAC
//    return @"4";
//}
//
////获取操作系统版本
//+ (NSString *)getDeviceVersion
//{
//    return [NSString stringWithFormat:@"%@", [UIDevice currentDevice].systemVersion];
//}
//
////获取app版本号
//+ (NSString *)getAppVersion
//{
//    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//}
//
//+ (NSString *)getCurrentTimeLong
//{
//    NSDate *datenow = [NSDate date];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    return timeSp;
//    //    //转换时间格式
//    //    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];//格式化
//    //
//    //
//    //    [df2 setDateFormat:@"yyyy-MM-dd"];
//    //
//    //    [df2 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//    //    [df2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    //
//    //    return [df2 stringFromDate:[NSDate date]];
//}
//
////获取频幕尺寸
//+ (NSString *)getScreenSize
//{
//    CGRect rect = [UIScreen mainScreen].bounds;
//    float width = rect.size.width;
//    float height = rect.size.height;
//    NSString *size = [NSString stringWithFormat:@"%.2f*%.2f", width, height];
//    return size;
//}
//
//
////获取设备唯一标识
//+ (NSString *)getAppGuid
//{
//    NSString *macaddress = [self macaddress];
//    NSString *appGuid = [macaddress stringFromMD5];
//
//    return [RETools forceString:appGuid];
//}
//
//+ (NSString *)uniqueDeviceIdentifier
//{
//    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//    NSString *deviceCode = [userdefault objectForKey:@"REFollowGuid"];
//
//    // 若keychain里面没有或者长度因为什么原因很短的话，重新获取一次再储存
//    if (deviceCode == nil || deviceCode.length < 10)
//    {
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        {
//            deviceCode = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        }
//        else
//        {
//            deviceCode = [self macaddress];
//        }
//
//        [userdefault setValue:deviceCode forKey:@"REFollowGuid"];
//    }
//
//    return [RETools forceString:deviceCode];
//}
//
//////获取网络连接类型
////+ (NSString *)getNetWorkType
////{
////    NSArray *children = @[];
////    UIApplication *app = [UIApplication sharedApplication];
////    id statusBar = [app valueForKeyPath:@"statusBar"];
////    if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar")])
////    {
////        children = [[statusBar valueForKeyPath:@"foregroundView"] subviews];
////    }
////    else if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")])
////    {
////        children = [[[statusBar valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
////    }
////
////    int type = 0;
////    NSString *status = @"--";
////    for (id child in children)
////    {
////        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
////        {
////            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
////            switch (type)
////            {
////                case 0:
////                    status = @"无网络";
////                    break;
////
////                case 1:
////                    status = @"2G";
////                    break;
////
////                case 2:
////                    status = @"3G";
////                    break;
////
////                case 3:
////                    status = @"4G";
////                    break;
////
////                case 5:
////                    status = @"WIFI";
////                    break;
////
////                default:
////                    break;
////            }
////        }
////    }
////
////    return [RETools forceString:status];
////}
//
//
//+ (NSString *)getNetWorkType
//{
//    UIApplication *app = [UIApplication sharedApplication];
//    id statusBar = nil;
////    判断是否是iOS 13
//    NSString *network = @"";
//    if (@available(iOS 13.0, *)) {
//        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
//            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
//            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
//                statusBar = [localStatusBar performSelector:@selector(statusBar)];
//            }
//        }
//#pragma clang diagnostic pop
//
//        if (statusBar) {
////            UIStatusBarDataCellularEntry
//            id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
//            id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
//            id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
//            if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
////                If wifiEntry is enabled, is WiFi.
//                network = @"WIFI";
//            } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
//                NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
//                if (type) {
//                    switch (type.integerValue) {
//                        case 0:
////                            无sim卡
//                            network = @"NONE";
//                            break;
//                        case 1:
//                            network = @"1G";
//                            break;
//                        case 4:
//                            network = @"3G";
//                            break;
//                        case 5:
//                            network = @"4G";
//                            break;
//                        default:
////                            默认WWAN类型
//                            network = @"WWAN";
//                            break;
//                            }
//                        }
//                    }
//                }
//    }else {
//        statusBar = [app valueForKeyPath:@"statusBar"];
//
//        if (IS_IPHONEX_SERIAL) {
////            刘海屏
//                id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
//                UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
//                NSArray *subviews = [[foregroundView subviews][2] subviews];
//
//                if (subviews.count == 0) {
////                    iOS 12
//                    id currentData = [statusBarView valueForKeyPath:@"currentData"];
//                    id wifiEntry = [currentData valueForKey:@"wifiEntry"];
//                    if ([[wifiEntry valueForKey:@"_enabled"] boolValue]) {
//                        network = @"WIFI";
//                    }else {
////                    卡1:
//                        id cellularEntry = [currentData valueForKey:@"cellularEntry"];
////                    卡2:
//                        id secondaryCellularEntry = [currentData valueForKey:@"secondaryCellularEntry"];
//
//                        if (([[cellularEntry valueForKey:@"_enabled"] boolValue]|[[secondaryCellularEntry valueForKey:@"_enabled"] boolValue]) == NO) {
////                            无卡情况
//                            network = @"NONE";
//                        }else {
////                            判断卡1还是卡2
//                            BOOL isCardOne = [[cellularEntry valueForKey:@"_enabled"] boolValue];
//                            int networkType = isCardOne ? [[cellularEntry valueForKey:@"type"] intValue] : [[secondaryCellularEntry valueForKey:@"type"] intValue];
//                            switch (networkType) {
//                                    case 0://无服务
//                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"NONE"];
//                                    break;
//                                    case 3:
//                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"2G/E"];
//                                    break;
//                                    case 4:
//                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"3G"];
//                                    break;
//                                    case 5:
//                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"4G"];
//                                    break;
//                                default:
//                                    break;
//                            }
//
//                        }
//                    }
//
//                }else {
//
//                    for (id subview in subviews) {
//                        if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
//                            network = @"WIFI";
//                        }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
//                            network = [subview valueForKeyPath:@"originalText"];
//                        }
//                    }
//                }
//
//            }else {
////                非刘海屏
//                UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
//                NSArray *subviews = [foregroundView subviews];
//
//                for (id subview in subviews) {
//                    if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//                        int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
//                        switch (networkType) {
//                            case 0:
//                                network = @"NONE";
//                                break;
//                            case 1:
//                                network = @"2G";
//                                break;
//                            case 2:
//                                network = @"3G";
//                                break;
//                            case 3:
//                                network = @"4G";
//                                break;
//                            case 5:
//                                network = @"WIFI";
//                                break;
//                            default:
//                                break;
//                        }
//                    }
//                }
//            }
//    }
//
//    if ([network isEqualToString:@""]) {
//        network = @"NO DISPLAY";
//    }
//    return [RETools forceString:network];
//}
//
//
////获取运营商code
//+ (NSString *)getNetWorkOperator
//{
//    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
//    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
//    NSString *str = [NSString stringWithFormat:@"%@%@", [carrier isoCountryCode],[carrier mobileCountryCode]];
//    return [RETools forceString:str];
//}
//
//#pragma mark - 获取设备当前网络IP地址
//+ (NSString *)getIPAddress
//{
//    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:UDKREFollowLocationIP];
//    if ([RETools iSNull:address]) {
//        address = @"0.0.0.0";
//    }
//    return address;
//}
//
////唯一标识
//+ (NSString *)stringFromMD5WithString:(NSString *)message
//{
//    if (self == nil || [message length] == 0)
//    {
//        return nil;
//    }
//
//    const char *value = [message UTF8String];
//
//    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
//
//    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++)
//    {
//        [outputString appendFormat:@"%02x", outputBuffer[count]];
//    }
//
//    return outputString;
//}
//
//// Return the local MAC addy
//// Courtesy of FreeBSD hackers email list
//// Accidentally munged during previous update. Fixed thanks to erica sadun &
//// mlamb.
//+ (NSString *)macaddress
//{
//    int                 mib[6];
//    size_t              len;
//    char                *buf;
//    unsigned char       *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl  *sdl;
//
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error\n");
//        return NULL;
//    }
//
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1\n");
//        return NULL;
//    }
//
//    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!\n");
//        return NULL;
//    }
//
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
//        free(buf);
//        return NULL;
//    }
//
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
//                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    free(buf);
//
//    return outstring;
//}
//
//
///**
// *  获取文字高度
// *  @param sizeWidth  文字需要展示的宽度
// *
// *  @return 大小
// */
//+ (CGSize)boundingRectWithStr:(NSString *)str font:(CGFloat)fontSize sizeWidth:(CGFloat)sizeWidth
//{
//    CGFloat sizeWIDTH = sizeWidth;
//
//    CGSize retSize = [str boundingRectWithSize:CGSizeMake(sizeWIDTH, MAXFLOAT)
//                                       options:\
//                      NSStringDrawingTruncatesLastVisibleLine |
//                      NSStringDrawingUsesLineFragmentOrigin |
//                      NSStringDrawingUsesFontLeading
//                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
//                                       context:nil].size;
//
//    return retSize;
//}
//
/////**
//// *
//// * 字体转化 像素 转化成 iOS 字号 鸡：px ==>> pt
//// *
//// */
////+ (CGFloat)changePxToPt:(CGFloat)px
////{
////    CGFloat pt = 0.0;
////    CGFloat dpi = 0.0;
////    if (iphone4)
////    {
////        dpi = 329;
////    }
////    else if (iphone5)
////    {
////        dpi = 329;
////    }
////    else if(iphone6)
////    {
////        dpi = 329;
////    }
////    else if(iphone6plus)
////    {
////        dpi = 329;
////    }
////
////    pt = px * 76 / dpi;
////    return pt;
////}
//
//
//
///**
// *  获取当前日期
// *
// *  @return 日期
// */
//+ (NSString *)getNowDate
//{
//    NSDate *timeDate = [NSDate date];
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
//    NSDateComponents *conponent = [cal components:unitFlags fromDate:timeDate];
//    NSInteger year  = [conponent year];
//    NSInteger month = [conponent month];
//    NSInteger day   = [conponent day];
//    NSString *nsDateString= [NSString stringWithFormat:@"%4ld年%2ld月%2ld日",(long)year,(long)month,(long)day];
//
//    return nsDateString;
//}
//
////获取当前时间
//+ (NSString *)getCurrentTime
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *time = [formatter stringFromDate:[NSDate date]];
//    return time;
//}
///**
// *  获取当前年份
// *
// *  @return 年份
// */
//+ (NSString *)getNowYear
//{
//    NSDate *timeDate = [NSDate date];
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
//    NSDateComponents *conponent = [cal components:unitFlags fromDate:timeDate];
//    NSInteger year  = [conponent year];
//    NSString *nsDateString = [NSString stringWithFormat:@"%4ld",(long)year];
//
//    return nsDateString;
//}
//
///**
// *  获取当前月份
// *
// *  @return 月份
// */
//+ (NSString *)getNowMonth
//{
//    NSDate *timeDate = [NSDate date];
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
//    NSDateComponents *conponent = [cal components:unitFlags fromDate:timeDate];
//    NSInteger month  = [conponent month];
//    NSString *nsDateString = [NSString stringWithFormat:@"%2ld",(long)month];
//
//    return nsDateString;
//}
//
///**
// *   获取当前应用版本号
// *
// *   return  当前版本号
// */
//+ (NSString *)getCFBundleVersion
//{
//    NSDictionary *infoDictionary =[[NSBundle mainBundle]infoDictionary];
//    NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
//    return version;
//}
//
///**
// *   获取字符串形式的文件大小
// *
// *   return  文件大小
// */
//+ (NSString *)getFile
//{
//    NSString *documentsStr = [RETools applicationDocumentsDirectory];
//    CGFloat file = [RETools fileSizeAtPath:documentsStr];
//    NSString *str2 = [NSString stringWithFormat:@"%f",file];
//    NSString *str3 = [NSString stringWithFormat:@"%ldM",[str2 integerValue]];
//    return str3;
//}
//
///**
// *   OC对象转json字符串
// *
// *   param  obj     OC对象(此对象可以是数组或者字典)
// */
//+ (NSString *)generateJsonString:(id)obj
//{
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
//    if ([jsonData length] > 0 && error == nil)
//    {
//        //NSData转换为String
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"JSON String = %@", jsonString);
//        return jsonString;
//    }
//    else if ([jsonData length] == 0 && error == nil)
//    {
//        NSLog(@"没有数据序列化之后返回");
//        return nil;
//    }
//    else if (error != nil)
//    {
//        NSLog(@"错误error = %@", error);
//        return nil;
//    }
//    return nil;
//}
//
///**
// *  json字符串转成对象
// */
//+ (id)objectWithJsonString:(NSString *)jsonString;
//{
//    if (jsonString == nil) {
//        return nil;
//    }
//
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
//                                             options:NSJSONReadingMutableContainers
//                                               error:&err];
//    if(err) {
//        return nil;
//    }
//    return obj;
//}
//
//
///**
// *  将相册中选中的图片，进行压缩 按图片比例压缩
// */
//+ (UIImage *)handlePhotoLibraryWithOriginalImage:(UIImage *)originalImage
//{
//    CGFloat imageWidth = SCREEN_WIDTH - 24 * WIDTH_SCALE;
//    CGFloat imageHeight = originalImage.size.height * (imageWidth / originalImage.size.width);
//    UIImage *compressImage = [RETools thumbnailWithImageWithoutScale:originalImage size:CGSizeMake(imageWidth, imageHeight)];
//    return compressImage;
//}
//
//
//
///**
// *  将图片压缩到指定比例
// */
////压缩图片
//+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
//
//{
//    UIImage *newimage;
//
//    if (nil == image)
//    {
//        newimage = nil;
//    }
//    else
//    {
//        CGSize oldsize = image.size;
//        CGRect rect;
//        if (asize.width/asize.height > oldsize.width/oldsize.height)
//        {
//            rect.size.width = asize.height*oldsize.width/oldsize.height;
//
//            rect.size.height = asize.height;
//
//            rect.origin.x = (asize.width - rect.size.width)/2;
//
//            rect.origin.y = 0;
//        }
//        else
//        {
//            rect.size.width = asize.width;
//
//            rect.size.height = asize.width*oldsize.height/oldsize.width;
//
//            rect.origin.x = 0;
//
//            rect.origin.y = (asize.height - rect.size.height)/2;
//        }
//
//        UIGraphicsBeginImageContext(asize);
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//
//        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//
//        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
//
//        [image drawInRect:rect];
//
//        newimage = UIGraphicsGetImageFromCurrentImageContext();
//
//        UIGraphicsEndImageContext();
//
//    }
//
//    return newimage;
//}
//
//
////裁剪图片
//+ (UIImage *)cutImage:(UIImage*)image headViewHeight:(CGFloat)headViewHeight
//{
//    //压缩图片
//    CGSize newSize;
//    CGImageRef imageRef = nil;
//
//    if ((image.size.width / image.size.height) < (SCREEN_WIDTH / headViewHeight)) {
//        newSize.width = image.size.width;
//        newSize.height = image.size.width * headViewHeight / SCREEN_WIDTH;
//
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//
//    } else {
//        newSize.height = image.size.height;
//        newSize.width = image.size.height * SCREEN_WIDTH / headViewHeight;
//
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//
//    }
//    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    return resultImage;
//}
//
//+ (void)showScaleAnimationInView:(UIView *)view ScaleValue:(CGFloat)scaleValue Repeat:(CGFloat)repeat Duration:(CGFloat)duration {
//
//    if (repeat == 0) {
//        repeat = MAXFLOAT;
//    }
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//
//    ///动画的起始状态值
//    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//    ///动画结束状态值
//    scaleAnimation.toValue = [NSNumber numberWithFloat:scaleValue];
//
//    ///循环动画执行方式，原路返回式(YES 注意：一去一回才算一个动画周期) 还是 再次从头开始(NO 注意：仅仅去一次就是一个动画周期)
//    scaleAnimation.autoreverses = YES;
//    ///动画结束后保持的状态：开始状态(kCAFillModeRemoved/kCAFillModeBackwards)、结束状态(kCAFillModeForwards/kCAFillModeBoth)
//    scaleAnimation.fillMode = kCAFillModeForwards;
//    scaleAnimation.removedOnCompletion = NO;
//
//    ///动画循环次数(MAXFLOAT 意味无穷)
//    scaleAnimation.repeatCount = repeat;
//    ///一个动画持续时间
//    scaleAnimation.duration = duration;
//
//    [view.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
//}
//
//+ (void)clearAnimationInView:(UIView *)view {
//    [view.layer removeAllAnimations];
//}
//
///**
// *  指定字符串的大小
// *
// *  @return 大小
// */
//
//+(NSMutableAttributedString *)settingAttributeString:(NSRange)rang
//                                            withText:(NSString *)text
//                                   withAttributeName:(NSString *)name
//                                               value:(id)value
//{
//    NSMutableAttributedString  *attrString = [[NSMutableAttributedString alloc] initWithString:text];
//    [attrString addAttribute:NSFontAttributeName value:value range:rang];
//    return attrString;
//}
//+(NSMutableAttributedString *)settingAttributeString:(NSRange)rang
//                                            withText:(NSString *)text
//                                   withAttributeName:(NSString *)name
//                                               value:(id)value
//                                          valueColor:(UIColor *)valueColor
//{
//    NSMutableAttributedString  *attrString = [[NSMutableAttributedString alloc] initWithString:text];
//    [attrString addAttribute:NSFontAttributeName value:value range:rang];
//    [attrString addAttribute:NSForegroundColorAttributeName value:valueColor range:rang];
//    return attrString;
//}
//
//+(NSMutableAttributedString *)settingAttributeString1:(NSRange)rang
//                                             withrang:(NSRange)rang1
//                                             withText:(NSString *)text
//                                    withAttributeName:(NSString *)name
//                                                value:(id)value
//{
//    NSMutableAttributedString  *attrString = [[NSMutableAttributedString alloc] initWithString:text];
//    [attrString addAttribute:NSFontAttributeName value:value range:rang];
//    [attrString addAttribute:NSFontAttributeName value:value range:rang1];
//    return attrString;
//}
//
/////**
//// *  获取通讯录权限
//// */
////+ (void)queryAddressBookAuthorization:(void (^)(bool isAuthorized))block
////{
////    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
////    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
////
////    if (authStatus != kABAuthorizationStatusAuthorized)
////    {
////        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
////                                                 {
////                                                     dispatch_async(dispatch_get_main_queue(), ^{
////                                                         if (error)
////                                                         {
////                                                             NSLog(@"Error: %@", (__bridge NSError *)error);
////                                                         }
////                                                         else if (!granted)
////                                                         {
////
////                                                             block(NO);
////                                                         }
////                                                         else
////                                                         {
////                                                             block(YES);
////                                                         }
////                                                         CFRelease(addressBook);
////                                                     });
////                                                 });
////    }
////    else
////    {
////        block(YES);
////        CFRelease(addressBook);
////    }
////}
//
//
//+ (CGSize)getImageSizeWithURL:(id)imageURL
//{
//    NSURL* URL = nil;
//    if([imageURL isKindOfClass:[NSURL class]]){
//        URL = imageURL;
//    }
//    if([imageURL isKindOfClass:[NSString class]]){
//        URL = [NSURL URLWithString:imageURL];
//    }
//    if(URL == nil)
//        return CGSizeZero;                  // url不正确返回CGSizeZero
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
//    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
//
//    CGSize size = CGSizeZero;
//    if([pathExtendsion isEqualToString:@"png"]){
//        size =  [RETools getPNGImageSizeWithRequest:request];
//    }
//    else if([pathExtendsion isEqual:@"gif"])
//    {
//        size =  [RETools getGIFImageSizeWithRequest:request];
//    }
//    else{
//        size = [RETools getJPGImageSizeWithRequest:request];
//    }
//    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
//    {
//        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
//        UIImage* image = [UIImage imageWithData:data];
//        if(image)
//        {
//            size = image.size;
//        }
//    }
//    return size;
//}
//
////  获取PNG图片的大小
//+ (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
//{
//    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if(data.length == 8)
//    {
//        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
//        [data getBytes:&w1 range:NSMakeRange(0, 1)];
//        [data getBytes:&w2 range:NSMakeRange(1, 1)];
//        [data getBytes:&w3 range:NSMakeRange(2, 1)];
//        [data getBytes:&w4 range:NSMakeRange(3, 1)];
//        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
//        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
//        [data getBytes:&h1 range:NSMakeRange(4, 1)];
//        [data getBytes:&h2 range:NSMakeRange(5, 1)];
//        [data getBytes:&h3 range:NSMakeRange(6, 1)];
//        [data getBytes:&h4 range:NSMakeRange(7, 1)];
//        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
//        return CGSizeMake(w, h);
//    }
//    return CGSizeZero;
//}
////  获取gif图片的大小
//+ (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
//{
//    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if(data.length == 4)
//    {
//        short w1 = 0, w2 = 0;
//        [data getBytes:&w1 range:NSMakeRange(0, 1)];
//        [data getBytes:&w2 range:NSMakeRange(1, 1)];
//        short w = w1 + (w2 << 8);
//        short h1 = 0, h2 = 0;
//        [data getBytes:&h1 range:NSMakeRange(2, 1)];
//        [data getBytes:&h2 range:NSMakeRange(3, 1)];
//        short h = h1 + (h2 << 8);
//        return CGSizeMake(w, h);
//    }
//    return CGSizeZero;
//}
////  获取jpg图片的大小
//+ (CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
//{
//    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//
//    if ([data length] <= 0x58) {
//        return CGSizeZero;
//    }
//
//    if ([data length] < 210) {// 肯定只有一个DQT字段
//        short w1 = 0, w2 = 0;
//        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
//        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
//        short w = (w1 << 8) + w2;
//        short h1 = 0, h2 = 0;
//        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
//        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
//        short h = (h1 << 8) + h2;
//        return CGSizeMake(w, h);
//    } else {
//        short word = 0x0;
//        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
//        if (word == 0xdb) {
//            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
//            if (word == 0xdb) {// 两个DQT字段
//                short w1 = 0, w2 = 0;
//                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
//                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
//                short w = (w1 << 8) + w2;
//                short h1 = 0, h2 = 0;
//                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
//                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
//                short h = (h1 << 8) + h2;
//                return CGSizeMake(w, h);
//            } else {// 一个DQT字段
//                short w1 = 0, w2 = 0;
//                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
//                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
//                short w = (w1 << 8) + w2;
//                short h1 = 0, h2 = 0;
//                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
//                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
//                short h = (h1 << 8) + h2;
//                return CGSizeMake(w, h);
//            }
//        } else {
//            return CGSizeZero;
//        }
//    }
//}
//
///**
// *  获取通讯录权限
// */
////+ (void)queryAddressBookAuthorization:(void (^)(bool isAuthorized))block
////{
////    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
////    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
////
////    if (authStatus != kABAuthorizationStatusAuthorized)
////    {
////        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
////                                                 {
////                                                     dispatch_async(dispatch_get_main_queue(), ^{
////                                                         if (error)
////                                                         {
////                                                             NSLog(@"Error: %@", (__bridge NSError *)error);
////                                                         }
////                                                         else if (!granted)
////                                                         {
////
////                                                             block(NO);
////                                                         }
////                                                         else
////                                                         {
////                                                             block(YES);
////                                                         }
////                                                     });
////                                                 });
////    }
////    else
////    {
////        block(YES);
////    }
////}
//
//+ (NSString *)getTimeStringWithSecond:(NSInteger)seconds
//{
//    NSString *ret=@"";
//
//    if (seconds>0) {
//        NSInteger d = seconds/60/60/24;
//        NSInteger h = seconds/60/60%24;
//        NSInteger  m = seconds/60%60;
//
//        NSString *_dStr = @"";
//        NSString *_hStr = @"";
//        NSString *_mStr = @"";
//
//        if (d > 0)
//        {
//            _dStr = [NSString stringWithFormat:@"%ld天",d];
//        }
//
//        if (h > 0)
//        {
//            _hStr = [NSString stringWithFormat:@"%ld小时",h];
//        }
//
//        if (m>0) {
//            _mStr = [NSString stringWithFormat:@"%ld分",m];
//        }
//
//        ret = [NSString stringWithFormat:@"%@%@%@",_dStr,_hStr,_mStr];
//    }
//
//    return ret;
//}
//////判断相机是否开启权限
////+ (BOOL)isCanUsePhotos {
////
////    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
////    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
////    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
////        return NO;
////    }
////    return YES;
////}
//////判断定位是否开启
////+ (BOOL)isLocationServiceOpen {
////    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
////        return NO;
////    } else
////        return YES;
////}
///**
// 传入需要的占位图尺寸 获取占位图
//
// @param size 需要的站位图尺寸
// @return 占位图
// */
//+ (UIImage *)placeholderImageWithSize:(CGSize)size {
//    if(size.width<=0 || size.height<= 0){
//        return nil;
//    }
//    return [UIImage imageNamed:Default_Icon];
//
////    NSString *bitStr = [NSString stringWithFormat:@"item_default_%.2f_%.2f",size.width,size.height];
////    NSURL *url = [NSURL URLWithString:bitStr];
////    NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
////    if (cacheKey != nil) {
////        UIImage *cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:cacheKey];
////        if (cacheImage) {
////            return cacheImage;
////        }
////    }
////
////    // 占位图的背景色
////    UIColor *backgroundColor = BACKGROUND_COLOR;
////    // 中间LOGO图片
////    UIImage *image = [UIImage imageNamed:@"item_default"];
////    // 根据占位图需要的尺寸 计算 中间LOGO的宽高
////    CGFloat logoWH = (size.width > size.height ? size.height : size.width) * 0.5;
////    CGSize logoSize = CGSizeMake(logoWH, logoWH);
////    // 打开上下文
////    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
////    // 绘图
////    [backgroundColor set];
////    UIRectFill(CGRectMake(0,0, size.width, size.height));
////    CGFloat imageX = (size.width / 2) - (logoSize.width / 2);
////    CGFloat imageY = (size.height / 2) - (logoSize.height / 2);
////    [image drawInRect:CGRectMake(imageX, imageY, logoSize.width, logoSize.height)];
////    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
////    // 关闭上下文
////    UIGraphicsEndImageContext();
////
////    //保存图片,避免多次创建
////    [[SDWebImageManager sharedManager] saveImageToCache:resImage forURL:url];
////
////    return resImage;
//
//}
//
//
///**
// *  剪切图片为正方形
// *
// *  @param image   原始图片比如size大小为(400x200)pixels
// *  @param newSize 正方形的size比如400pixels
// *
// *  @return 返回正方形图片(400x400)pixels
// */
//+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize
//{
//    CGAffineTransform scaleTransform;
//    CGPoint origin;
//
//    if (image.size.width > image.size.height) {
//        //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
//        CGFloat scaleRatio = newSize / image.size.height;
//        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
//        //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
//        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
//    } else {
//        CGFloat scaleRatio = newSize / image.size.width;
//        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
//
//        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
//    }
//
//    CGSize size = CGSizeMake(newSize, newSize);
//    //创建画板为(400x400)pixels
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
//    } else {
//        UIGraphicsBeginImageContext(size);
//    }
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //将image原始图片(400x200)pixels缩放为(800x400)pixels
//    CGContextConcatCTM(context, scaleTransform);
//    //origin也会从原始(-100, 0)缩放到(-200, 0)
//    [image drawAtPoint:origin];
//
//    //获取缩放后剪切的image图片
//    image = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return image;
//}
//
//
////递归清除内存中的视图
//+ (void)recursionView:(UIView *)view
//{
//    if (view.subviews.count == 0)
//    {
//        [view removeFromSuperview];
//        view = nil;
//    }
//    //递归所有子视图 并删除
//    for (UIView *child in view.subviews)
//    {
//        [self recursionView:child];
//    }
//}
//
////将十六进制的字符串转换成NSString则可使用如下方式:
//+ (NSString *)convertHexStrToString:(NSString *)str
//{
//    if (!str || [str length] == 0) {
//        return nil;
//    }
//
//    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
//    NSRange range;
//    if ([str length] % 2 == 0) {
//        range = NSMakeRange(0, 2);
//    } else {
//        range = NSMakeRange(0, 1);
//    }
//    for (NSInteger i = range.location; i < [str length]; i += 2) {
//        unsigned int anInt;
//        NSString *hexCharStr = [str substringWithRange:range];
//        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
//
//        [scanner scanHexInt:&anInt];
//        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
//        [hexData appendData:entity];
//
//        range.location += range.length;
//        range.length = 2;
//    }
//    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
//    return string;
//}
//
//
////将NSString转换成十六进制的字符串则可使用如下方式:
//+ (NSString *)convertStringToHexStr:(NSString *)str {
//    if (!str || [str length] == 0) {
//        return @"";
//    }
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
//
//    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
//        unsigned char *dataBytes = (unsigned char*)bytes;
//        for (NSInteger i = 0; i < byteRange.length; i++) {
//            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
//            if ([hexStr length] == 2) {
//                [string appendString:hexStr];
//            } else {
//                [string appendFormat:@"0%@", hexStr];
//            }
//        }
//    }];
//
//    return string;
//}
//
///**
// *  获取系统时间
// *
// *  @return 系统时间
// */
//+(NSString *)getSystemtime
//{
//    NSDate *  senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"HH:mm"];
//    //    NSString * locationString=[dateformatter stringFromDate:senddate];
//    [dateformatter setDateFormat:@"YYYYMMddHH"];
//    NSString * morelocationString=[dateformatter stringFromDate:senddate];
//
//    return morelocationString;
//}
//
///**
// 获取系统时间
//
// @return 时间戳
// */
//+ (NSString *)getSystemTimeStamp
//{
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//
//    NSTimeInterval a=[dat timeIntervalSince1970];
//
//    NSString*timeString = [NSString stringWithFormat:@"%0.f000", a];//转为字符型
//
//    return timeString;
//}
//
////当前时间戳(毫秒）
//+ (NSString *)getNowTimeTimestamp {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
//    formatter.locale = [NSLocale systemLocale];
//    //时区
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
//    NSDate *datenow = [NSDate date];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
//    return timeSp;
//}
//
//+ (NSString *)stringTransformToTimeTwo:(NSString *)timeStr
//{
//    double time = [timeStr doubleValue];
//
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd"]; //设定时间格式,这里可以设置成自己需要的格式
//
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
//
//    NSString* dateString = [formatter stringFromDate:date];
//
//    return dateString;
//}
//+ (NSString *)stringTransformToTimeTwo:(NSString *)timeStr withFormat:(NSString *)format
//{
//    double time = [timeStr doubleValue];
//
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:format == nil ? @"yyyy-MM-dd":format]; //设定时间格式,这里可以设置成自己需要的格式
//
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
//
//    NSString* dateString = [formatter stringFromDate:date];
//
//    return dateString;
//}
//
//+ (NSString *)stringTransformToTimeThree:(NSString *)timeStr
//{
//    double time = [timeStr doubleValue];
//
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; //设定时间格式,这里可以设置成自己需要的格式
//
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
//
//    NSString* dateString = [formatter stringFromDate:date];
//
//    return dateString;
//}
//+ (NSString *)stringTransformToTimeFour:(NSString *)timeStr
//{
//    double time = [timeStr doubleValue];
//
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"HH:mm"]; //设定时间格式,这里可以设置成自己需要的格式
//
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
//
//    NSString* dateString = [formatter stringFromDate:date];
//
//    return dateString;
//}
//
//
//
//
//+ (NSString *)timeString:(NSDate *)date
//{
//    //转换时间格式
//    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];//格式化
//
//    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//    [df2 setLocale:[NSLocale currentLocale]];
//
//    return [df2 stringFromDate:date];
//}
//
//+ (NSDate *)timeFromString:(NSString *)string{
//
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//
//    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//
//    NSDate *date = [format dateFromString:string];
//    return date;
//}
//
//
//
//#pragma mark -  时间戳转为不同的格式
//+(NSString *) dateToTime:(NSString *) timeStampString andforDate:(NSString  *) format
//{
//    long long timeStamp = [timeStampString longLongValue];
//    NSString * time = [NSString stringWithFormat:@"%lld",timeStamp/1000];//13位转10位
//    NSString *arg = time;
//    if (![time isKindOfClass:[NSString class]]) {
//        arg = [NSString stringWithFormat:@"%@", time];
//    }
//
//    NSTimeInterval timelong = ([arg doubleValue]);
//
//    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timelong];
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:format];
//
//    return [dateFormatter stringFromDate :date];
//}
///**
// *  获取通讯录权限
// */
//+ (void)queryAddressBookAuthorization:(void (^)(bool isAuthorized))block
//{
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
//    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
//
//    if (authStatus != kABAuthorizationStatusAuthorized)
//    {
//        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
//                                                 {
//                                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                                         if (error)
//                                                         {
//                                                             NSLog(@"Error: %@", (__bridge NSError *)error);
//                                                         }
//                                                         else if (!granted)
//                                                         {
//
//                                                             block(NO);
//                                                         }
//                                                         else
//                                                         {
//                                                             block(YES);
//                                                         }
//                                                     });
//                                                 });
//    }
//    else
//    {
//        CFRelease(addressBook);
//        block(YES);
//    }
//}
//
//
///**
// *  时间转字符串
// *
// *  @return 时间戳
// */
//+ (NSString *)timeTransformToString:(NSDate *)time
//{
//    //转换时间格式
//    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];  //格式化
//
//    [df2 setDateFormat:@"yyyy-MM-dd"];
//
//    [df2 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//    [df2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//
//    return [df2 stringFromDate:time];
//}
//
///**
// *  字符串转时间格式
// *
// *  @param timeStr 时间戳字符串
// *
// *  @return  格式化过的时间
// */
//+(NSString *)stringTransformToTime:(NSString *)timeStr
//{
//    double time = [timeStr doubleValue];
//
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //设定时间格式,这里可以设置成自己需要的格式
//
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
//
//    NSString* dateString = [formatter stringFromDate:date];
//
//    return dateString;
//}
//
///**
// *  根据传入时间格式将字符串转时间格式
// *
// *  @param timeStr 时间戳字符串
// *
// *  @return  格式化过的时间
// */
//+ (NSString *)stringTransformToTime:(NSString *)timeStr byFixFormatter:(NSDateFormatter *)formatter
//{
//    double time = [timeStr doubleValue];
//
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
//
//    NSString *dateString = [formatter stringFromDate:date];
//
//    return dateString;
//}
//
//#warning 白名单
////白名单
//+ (BOOL)whiteList:(NSString *)str {
//    NSArray *list = @[@"zhibo",@"RE"];
//
//    for (NSString *string in list)
//    {
//        if ([str containsString:string])
//        {
//            return YES;
//        }
//    }
//
//    return NO;
//}
//
///**
// 获取url中的参数并返回
// @param urlString 带参数的url
// @return NSDictionary:参数字典
// */
//
//+ (NSDictionary*)getParamsWithUrlString:(NSString*)urlString {
//
//    if(urlString.length==0) {
//        NSLog(@"链接为空！");
//        return @{};
//    }
//
//    //先截取问号
//    NSArray*allElements = [urlString componentsSeparatedByString:@"?"];
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];//待set的参数字典
//
//    if(allElements.count==2) {
//        //有参数或者?后面为空
//        NSString*paramsString = allElements[1];
//        //获取参数对
//        NSArray*paramsArray = [paramsString componentsSeparatedByString:@"&"];
//
//        if(paramsArray.count>=2) {
//
//            for(NSInteger i =0; i < paramsArray.count; i++) {
//
//                NSString *singleParamString = paramsArray[i];
//                NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
//
//                if(singleParamSet.count==2) {
//                    NSString*key = singleParamSet[0];
//                    NSString*value = singleParamSet[1];
//
//                    if(key.length>0|| value.length>0) {
//                        [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
//                    }
//                }
//            }
//        }else if(paramsArray.count==1) {
//            //无 &。url只有?后一个参数
//            NSString*singleParamString = paramsArray[0];
//            NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
//
//            if(singleParamSet.count==2) {
//                NSString*key = singleParamSet[0];
//                NSString*value = singleParamSet[1];
//
//                if(key.length>0|| value.length>0) {
//                    [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
//                }
//
//            }else{
//                //问号后面啥也没有 xxxx?  无需处理
//            }
//        }
//        //整合url及参数
//        return params;
//
//    }else if(allElements.count>2) {
//        NSLog(@"链接不合法！链接包含多个\"?\"");
//        return @{};
//    }else{
//        NSLog(@"链接不包含参数！");
//        return @{};
//    }
//}
//
//#pragma mark -- 对象转 NSDictionary
//+ (NSDictionary*)getObjectData:(id)obj
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    unsigned int propsCount;
//    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
//    for(int i = 0;i < propsCount; i++)
//    {
//        objc_property_t prop = props[i];
//
//        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
//        id value = [obj valueForKey:propName];//kvc读值
//        if(value == nil)
//        {
//            value = [NSNull null];
//        }
//        else
//        {
//            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
//        }
//        [dic setObject:value forKey:propName];
//    }
//    return dic;
//}
//
//+ (id)getObjectInternal:(id)obj
//{
//    if([obj isKindOfClass:[NSString class]]
//       || [obj isKindOfClass:[NSNumber class]]
//       || [obj isKindOfClass:[NSNull class]])
//    {
//        return obj;
//    }
//
//    if([obj isKindOfClass:[NSArray class]])
//    {
//        NSArray *objarr = obj;
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
//        for(int i = 0;i < objarr.count; i++)
//        {
//            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
//        }
//        return arr;
//    }
//
//    if([obj isKindOfClass:[NSDictionary class]])
//    {
//        NSDictionary *objdic = obj;
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
//        for(NSString *key in objdic.allKeys)
//        {
//            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
//        }
//        return dic;
//    }
//    return [self getObjectData:obj];
//}
//
////获取appIconName
//+(NSString*)getAppIconName{
//    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
//
//    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
//    if (!icon.length) {
//        icon = @"logo_default";
//    }
//    NSLog(@"GetAppIconName,icon:%@",icon);
//    return icon;
//}
//
//#pragma mark 判断字符串是否为浮点数
//+ (BOOL)isPureFloat:(NSString*)string{
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    float val;
//    return[scan scanFloat:&val] && [scan isAtEnd];
//}
//#pragma mark 判断是否为整形
//+ (BOOL)isPureInt:(NSString*)string{
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    int val;
//    return [scan scanInt:&val] && [scan isAtEnd];
//}
//
@end
