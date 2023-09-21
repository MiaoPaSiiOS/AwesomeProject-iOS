//
//  IUDeepLinkModel.m
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IUDeepLinkModel.h"

@interface IUDeepLinkModel ()

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSString     *scheme;
@property (nonatomic, strong) NSString     *host;
@property (nonatomic, strong) NSString     *paramsStr;
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation IUDeepLinkModel

+ (instancetype)deepLinkModelWithURLStr:(NSString *)urlString {

    IUDeepLinkModel *model = [IUDeepLinkModel new];
    model.url            = [NSURL URLWithString:urlString];
    [model accessDataWithURL:model.url];
    
    return model;
}

+ (instancetype)deepLinkModelWithURL:(NSURL *)url {
    
    IUDeepLinkModel *model = [IUDeepLinkModel new];
    model.url            = url;
    [model accessDataWithURL:model.url];
    
    return model;
}

- (void)accessDataWithURL:(NSURL *)url {
    
    self.scheme = url.scheme;
    
    self.host = [url.absoluteString componentsSeparatedByString:@"?"].firstObject.stringByRemovingPercentEncoding;
    
    self.paramsStr = url.query.stringByRemovingPercentEncoding;
    
    if (self.paramsStr.length) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [[self.paramsStr componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString * key_value, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSArray *tmp = [key_value componentsSeparatedByString:@"="];
            
            NSString *key   = tmp.firstObject;
            NSString *value = [key_value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@=", key] withString:@""];
            
            if (key.length && value.length) {
                
                dic[key] = value;
                
                // 有可能是json字符串,尝试解析,解析成功后就赋值
                if ([[value substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"{"] &&
                    [[value substringWithRange:NSMakeRange(value.length - 1, 1)] isEqualToString:@"}"]) {
                    
                    NSData *jsonData = [value dataUsingEncoding:NSUTF8StringEncoding];
                    id      data     = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
                    if (data) {
                        
                        dic[key] = data;
                    }
                }
            }
        }];
        
        if (dic.allKeys.count) {
            
            self.params = [NSDictionary dictionaryWithDictionary:dic];
        }
    }
}

@end

