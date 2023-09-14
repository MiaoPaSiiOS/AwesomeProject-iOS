//
//  UIViewController+RERouter.h
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import <UIKit/UIKit.h>

@class HJMappingVO;


@interface UIViewController (RERouter)

@property (nonatomic, strong) NSMutableDictionary *extraData; //for init

+ (instancetype)createWithMappingVOKey:(NSString *)aKey extraData:(NSDictionary *)aParam;

+ (instancetype)createWithMappingVO:(HJMappingVO *)aMappingVO extraData:(NSDictionary *)aParam;


@end
