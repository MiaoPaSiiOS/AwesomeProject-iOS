//
//  IUValidateUtils.m
//  CRJGeneralTools
//
//  Created by 朱玉辉(EX-ZHUYUHUI002) on 2021/1/12.
//

#import "IUValidateUtils.h"

@implementation IUValidateUtils
/**
 限制输入最大长度
 @param textField 输入前文本框
 @param string 输入字符
 @return 判断是否符合输入条件
 */
+ (BOOL)prepareForLimitMaxLengthWithTextField:(UITextField *)textField withRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSUInteger)maxLength {
    // 小数点前最多能输入n位
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (aString.length > maxLength) {
        [self showMyMessage:[NSString stringWithFormat:@"限制输入最大长度 %lu 位",(unsigned long)maxLength]];
        return NO;
    }
    return YES;
}
/**
 对于价格类型，限制小数点前n位，小数点后两位
 @param textField 输入框
 @param range 输入字符位置
 @param string 输入字符
 @param digitsNumBeforePoint 小数点前位数
 @return 判断结果
 */
+ (BOOL)prepareForLimitRetainedSecondDecimalWithTextField:(UITextField *)textField withRange:(NSRange)range replacementString:(NSString *)string digitsNumBeforePoint:(NSUInteger)digitsNumBeforePoint {
    /*
    * 不能输入.0-9以外的字符。
    * 设置输入框输入的内容格式
    * 只能有一个小数点
    * 小数点后最多能输入两位
    * 如果第一位是.则前面加上0.
    * 如果第一位是0则后面必须输入点，否则不能输入。
    */
    BOOL isHaveDian;

    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    } else {
        isHaveDian = NO;
    }

    if (string.length > 0) {
        /*
        是否只含有[0123456.]
        */
        if ([RX(@"^[\\.\\d]*$") matches:string].count == 0) {
            [self showMyMessage:@"只能输入0123456."];
            NSLog(@"无效的金额 %@ [只能输入0123456.]",string);
            return NO;
        }

        /*
         格式是否正确
         */
        NSArray *components = [string componentsSeparatedByString:@"."];
        if (components.count == 2) {
            /*
             string = @"." components.count == 2
             
             string = @"12.33" components.count == 2
             
             string = @".33" components.count == 2
             */
        } else {
            if (components.count > 2) {
                NSLog(@"无效的金额 %@",string);
                return NO;
            }
        }
        
        // 只能有一个小数点
        if (isHaveDian && [string containsString:@"."]) {
            NSLog(@"最多只能输入一个小数点");
            return NO;
        }
        
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && ([string isEqualToString:@"."])) {
            textField.text = @"0";
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSArray *components = [aString componentsSeparatedByString:@"."];
            NSString *point = components.lastObject;
            if (point.length > 2) {
                [self showMyMessage:@"小数点后最多有两位小数"];
                return NO;
            }
        }
        
        // 小数点前最多能输入n位
        if (digitsNumBeforePoint != MAXFLOAT) {
            NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            if (isHaveDian) {
                if (aString.length > digitsNumBeforePoint + 3) {
                    [self showMyMessage:[NSString stringWithFormat:@"小数点前最多有 %lu 位小数",(unsigned long)digitsNumBeforePoint]];
                    return NO;
                }
            } else {
                if (aString.length > digitsNumBeforePoint) {
                    [self showMyMessage:[NSString stringWithFormat:@"小数点前最多有 %lu 位小数",(unsigned long)digitsNumBeforePoint]];
                    return NO;
                }
            }
        }
    }

    return YES;
}

+ (void)showMyMessage:(NSString *)aInfo {
    NSLog(@"%@",aInfo);
    return;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

    [alertView show];
}
@end
