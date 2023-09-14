//
//  REMerchantModel.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REMerchantModel : NSObject
@property(nonatomic, copy) NSString *logoUrl;
@property(nonatomic, copy) NSString *storeName;
@property(nonatomic, copy) NSString *storeId;
@property(nonatomic, copy) NSString *storeOnlineType;
@end

NS_ASSUME_NONNULL_END
/*
 {
     "code": "0",
     "data": {
         "listObj": [{
             "businessState": 1,
             "channelCodes": ["120001"],
             "channelInfoList": [{
                 "channelCode": "120001",
                 "channelMode": "POS",
                 "channelName": "自建POS",
                 "orgId": 2012140000002366
             }],
             "cityName": "苏州市",
             "contactName": "唐文君",
             "detailAddress": "东大街181号",
             "logoUrl": "https://wuliangye-jxc.obs.cn-south-1.myhuaweicloud.com/prod/back-product/1609828038169_20.3235583603263_5a4859e2-6610-479c-b82a-07360c87e97f.png",
             "merchantCode": "4000650700",
             "merchantId": 2012140000002348,
             "merchantName": "苏州富森源企业管理有限公司",
             "mobile": "13584810244",
             "provinceName": "江苏省",
             "regionName": "姑苏区",
             "storeCode": "4000650701",
             "storeId": 2012140000002366,
             "storeName": "五粮液专卖店（东大街店）",
             "storeOnlineType": "1",
             "storeType": "1",
             "storeTypeName": "加盟"
         }, {
             "businessState": 1,
             "channelCodes": ["120001"],
             "channelInfoList": [{
                 "channelCode": "120001",
                 "channelMode": "POS",
                 "channelName": "自建POS",
                 "orgId": 2209270000004916
             }],
             "cityName": "苏州市",
             "contactName": "唐文君",
             "detailAddress": "东大街181号",
             "logoUrl": "https://wuliangye-jxc.obs.cn-south-1.myhuaweicloud.com/prod/back-product/1664278070151_76.17323158522179_53a2ffac-c95b-4e9b-ba6e-6420aae83729.png",
             "merchantCode": "S4002068998",
             "merchantId": 2209270000004355,
             "merchantName": "苏州利柯尔酒类销售有限公司",
             "mobile": "13584810244",
             "provinceName": "江苏省",
             "regionName": "姑苏区",
             "storeCode": "4002068998",
             "storeId": 2209270000004916,
             "storeName": "五粮液专卖店（东大街店）（新）",
             "storeOnlineType": "1",
             "storeType": "1",
             "storeTypeName": "加盟"
         }],
         "total": 25
     },
     "gitVersion": {
         "git.branch": "origin/ouser-wly-1.0.0",
         "git.commit.id": "c76970f8f87d943b1e3c37739baef0eca84f585e"
     },
     "trace": "01d46d24d3dd1754"
 }
 */
