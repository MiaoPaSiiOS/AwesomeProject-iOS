//
//  SDMajletModel.h
//  DarkStarAwesomeKit
//
//  Created by zhuyuhui on 2023/10/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDMajletModel : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *code;
@property(nonatomic, strong) NSMutableArray *child;
@property(nonatomic, assign) BOOL edit;

@end

NS_ASSUME_NONNULL_END
/*
 {
     "code": "0",
     "data": [{
         "child": [{
             "code": "100100",
             "icon": "https://wuliangye-jxc.obs.png",
             "name": "开单收银",
         }, {
             "code": "100101",
             
             "icon": "https://wuliangye-jxc.obs.png",
             "name": "扫码收货",
         }, {
             "code": "100102",
             
             "icon": "https://wuliangye-jxc.obs.png",
             "name": "一键收货",
         }, {
             "code": "100105",
             "icon": "https://wuliangye-jxc.obs.png",
             "name": "库存盘点",
         }],
         "code": "100",
         "icon": "https://wuliangye-jxc.obs.png",
         "name": "门店销售",
     }],
     "message": "成功"
 }
 */
