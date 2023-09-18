//
//  AresJsbWKWebViewController+JSApplePay.m
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import "AreaJsbWKWebViewController+JSApplePay.h"
#import "QMUILab.h"
//Apple Pay 支付相关
#import <PassKit/PassKit.h>

@implementation AreaJsbWKWebViewController (JSApplePay)

QMUISynthesizeIdStrongProperty(applePayCallBack, setApplePayCallBack)
QMUISynthesizeIdStrongProperty(applePayResultUrl, setApplePayResultUrl)
QMUISynthesizeIdStrongProperty(applePayBindCard, setApplePayBindCard)


- (void)registerHandlerApplePay {
//    //iPhone 是否支持 applePay支付回调方法
//    [self registerWithCode:@"supportApplePay" action:@selector(supportApplePay:)];
//
//    //applePay支付回调方法
//    [self registerWithCode:@"applePay" action:@selector(applePay:)];
//
//    //iPhone 是否支持添加 applePay
//    [self registerWithCode:@"supportAddApplePay" action:@selector(supportAddApplePay:)];
//
//    //applePay绑卡
//    [self registerWithCode:@"ApplePayCard" action:@selector(applePayCard:)];
}

#pragma mark - 是否支持 ApplePay
//- (void)supportApplePay:(NSString *)eventName {
//    kWeakSelf
//    [self.baseWebView evaluateJavaScript:eventName completionHandler:^(id _Nullable strDic, NSError * _Nullable error) {
//        if (!error && [strDic isKindOfClass:[NSString class]] && !isStringEmptyOrNil(strDic)) {
//            NSDictionary *dict = [strDic qnm_JSONValue];
//            NSString *callBack = [dict objectForKey:@"callback"];
//            
//            NSString *supportStr = @"null";
//            //弹出Apple Pay控件
//            if (@available(iOS 9.2, *)) {
//                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.2 && [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]]) {
//                    supportStr = @"ApplePay";
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//            
//            NSString *strCallBack =[NSString stringWithFormat:@"%@('%@')",callBack,supportStr];
//            [weakSelf.baseWebView evaluateJavaScript:strCallBack completionHandler:nil];
//        }
//    }];
//}
//
//#pragma mark - applePay支付
//- (void)applePay:(NSString *)eventName {
//    kWeakSelf
//    [self.baseWebView evaluateJavaScript:eventName completionHandler:^(id _Nullable strDic, NSError * _Nullable error) {
//        kStrongSelf
//        if (!error && [strDic isKindOfClass:[NSString class]] && !isStringEmptyOrNil(strDic)) {
//            NSDictionary *dict = [strDic qnm_JSONValue];
//            self.applePayCallBack = [dict objectForKey:@"callback"];
//            NSString *tradeNO = [dict objectForKey:@"tradeNo"];
//            NSString *orderType = [dict objectForKey:@"orderType"];
//            self.applePayResultUrl = [dict objectForKey:@"payResultUrl"];
//            [strongSelf qPayForApplePay:orderType tradeNo:tradeNO];
//        }
//    }];
//}
//
//- (void)qPayForApplePay:(NSString *)orderType tradeNo:(NSString *)tradeNo {
//    //发起支付
//}
//
//#pragma mark - 是否支持绑 ApplePay
//- (void)supportAddApplePay:(NSString *)eventName {
//    kWeakSelf
//    [self.baseWebView evaluateJavaScript:eventName completionHandler:^(id _Nullable strDic, NSError * _Nullable error) {
//        kStrongSelf
//        if (!error && [strDic isKindOfClass:[NSString class]] && !isStringEmptyOrNil(strDic)) {
//            NSDictionary *dict = [strDic qnm_JSONValue];
//            NSString *callBack = [dict objectForKey:@"callback"];
//            
//            NSString *supportStatus = @"N";
//            
//            //检查当前设备是否可以添加 Apple Pay
//            if ([PKPaymentAuthorizationViewController class] && [PKAddPaymentPassViewController canAddPaymentPass]) {
//                supportStatus = @"Y";
//            }
//            
//            NSString *strCallBack = [NSString stringWithFormat:@"%@('%@')",callBack,supportStatus];
//            [strongSelf.baseWebView evaluateJavaScript:strCallBack completionHandler:nil];
//        }
//    }];
//}
//
//#pragma mark - applePay 绑卡
//- (void)applePayCard:(NSString *)eventName {
//    [self.baseWebView evaluateJavaScript:eventName completionHandler:^(id _Nullable strDic, NSError * _Nullable error) {
//        if (!error && [strDic isKindOfClass:[NSString class]] && !isStringEmptyOrNil(strDic)) {
//            NSDictionary *dict = [strDic qnm_JSONValue];
//            NSLog(@"%@",dict);
//        }
//    }];
//}

@end
