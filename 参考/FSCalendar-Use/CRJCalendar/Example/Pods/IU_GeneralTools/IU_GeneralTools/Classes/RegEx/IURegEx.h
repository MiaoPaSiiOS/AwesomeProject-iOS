//
//  IURegEx.h
//  CRJGeneralTools
//
//  Created by zhuyuhui on 2020/9/22.
//

#import <Foundation/Foundation.h>
#import "IUValidateUtils.h"
NS_ASSUME_NONNULL_BEGIN

@interface IURegEx : NSObject
/*
 //只能输入数字
 NSString* regex = @"^[0-9]*$";
 NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
 return [pred evaluateWithObject:object];
 */

/*
//只能输入n位的数字
NSString* regex = @"^\\d{n}$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入至少n位的数字
NSString* regex = @"^\\d{n,}$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入m~n位的数字
NSString* regex = @"^\\d{m,n}$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入零和非零开头的数字
NSString* regex = @"^(0|[1-9][0-9]*)$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入有两位小数的正实数
NSString* regex = @"^[0-9]+(.[0-9]{2})?$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入有1~3位小数的正实数
NSString* regex = @"^[0-9]+(\.[0-9]{1,3})?$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入非零的正整数
NSString* regex = @"^\+?[1-9][0-9]*$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//匹配不是0开头的任意数字
NSString* regex = @"^(?!0)\\d+$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入非零的负整数
表达式含义解析：http://deerchao.net/tutorials/regex/regex.htm
======
 ^匹配你要用来查找的字符串的开头，$匹配结尾。
 \d+匹配1个或更多连续的数字
 (?!exp)  匹配后面跟的不是exp的位置
    (?!0)  匹配后面跟的不是0的
=======
NSString* regex = @"^-(?!0)\\d+$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入长度为3的字符
NSString* regex = @"^.{3}$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入由26个英文字母组成的字符串
NSString* regex = @"^[A-Za-z]+$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入由26个大写英文字母组成的字符串
NSString* regex = @"^[A-Z]+$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入由26个小写英文字母组成的字符串
NSString* regex = @"^[a-z]+$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//只能输入汉字
NSString* regex = @"^[\u4e00-\u9fa5]{0,}$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/

/*
//验证URL
NSString* regex = @"^http://([\\w-]+\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
return [pred evaluateWithObject:object];
*/



@end

NS_ASSUME_NONNULL_END

/*
 正则表达式
 https://www.runoob.com/regexp/regexp-tutorial.html
 
 正则表达式在线测试
 http://c.runoob.com/front-end/854
 
 
 常用元字符
 元字符     描述
 ^     匹配输入字符串开始位置
 $     匹配输入字符串结束为止
 .     匹配除换行意外的任意字符
 |     或
 ,     分割
 []     包含，默认一个字符长度
 [0-9]     匹配0~9的数字
 [a-z]     匹配小写英文字母
 [A-Z]     匹配大写英文字母
 [a-zA-Z]     匹配英文字母
 [a-zA-Z0-9]     匹配英文字母数字
 [^]     不包含，默认一个字符长度
 {n}     重复n次
 {n,}     重复>= n次
 {n,m}     n<= 重复次数 <= m
 *     重复次数 >= 0
 +     重复次数 >=1
 ?     重复次数0次或1次
 \     转义字符
 \d     匹配数字
 \w     匹配字母、数字或下划线
 \s     匹配空白字符:空格、制表符、换页符等
 \D     匹配非数字字符
 \W     匹配所有与非字母、非数字、非下划线字符
 \S     匹配非空白字符

 */



/*
 typedef NS_OPTIONS(NSUInteger, NSMatchingOptions) {
    NSMatchingReportProgress         = 1 << 0, //找到最长的匹配字符串后调用block回调
    NSMatchingReportCompletion       = 1 << 1, //找到任何一个匹配串后都回调一次block
    NSMatchingAnchored               = 1 << 2, //从匹配范围的开始处进行匹配
    NSMatchingWithTransparentBounds  = 1 << 3, //允许匹配的范围超出设置的范围
    NSMatchingWithoutAnchoringBounds = 1 << 4  //禁止^和$自动匹配行还是和结束
 };


 typedef NS_OPTIONS(NSUInteger, NSMatchingFlags) {
    NSMatchingProgress               = 1 << 0, //匹配到最长串后被设置
    NSMatchingCompleted              = 1 << 1, //全部分配完成后被设置
    NSMatchingHitEnd                 = 1 << 2, //匹配到设置范围的末尾时被设置
    NSMatchingRequiredEnd            = 1 << 3, //当前匹配到的字符串在匹配范围的末尾时被设置
    NSMatchingInternalError          = 1 << 4  //由于错误导致的匹配失败时被设置
 };
 */
