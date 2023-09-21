//
//  IUValidateUtils.h
//  CRJGeneralTools
//
//  Created by 朱玉辉(EX-ZHUYUHUI002) on 2021/1/12.
//

#import <Foundation/Foundation.h>
#import "RegExCategories/RegExCategories.h"
@interface IUValidateUtils : NSObject
/**
 限制输入最大长度
 @param textField 输入前文本框
 @param string 输入字符
 @return 判断是否符合输入条件
 */
+ (BOOL)prepareForLimitMaxLengthWithTextField:(UITextField *)textField withRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSUInteger)maxLength;

/**
 对于价格类型，限制小数点前n位，小数点后两位
 @param textField 输入框
 @param range 输入字符位置
 @param string 输入字符
 @param digitsNumBeforePoint 小数点前位数
 @return 判断结果
 */
+ (BOOL)prepareForLimitRetainedSecondDecimalWithTextField:(UITextField *)textField withRange:(NSRange)range replacementString:(NSString *)string digitsNumBeforePoint:(NSUInteger)digitsNumBeforePoint;

@end
