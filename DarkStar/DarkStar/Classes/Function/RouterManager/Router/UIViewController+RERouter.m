//
//  UIViewController+RERouter.m
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import "UIViewController+RERouter.h"
#import <objc/runtime.h>
#import "RERouter.h"
@implementation UIViewController (RERouter)
//定义常量 必须是C语言字符串
static char *ExtraDataKey = "ExtraDataKey";

- (void)setExtraData:(NSMutableDictionary *)extraData
{
    objc_setAssociatedObject(self, ExtraDataKey, extraData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableDictionary *)extraData
{
    return objc_getAssociatedObject(self, ExtraDataKey);
}

#pragma mark - 通过HJMappingVO创建VC

+ (instancetype)createWithMappingVOKey:(NSString *)aKey extraData:(NSDictionary *)aParam
{
    return [self createWithMappingVO:[RERouter singletonInstance].mapping[aKey] extraData:aParam];
}

+ (instancetype)createWithMappingVO:(HJMappingVO *)aMappingVO extraData:(NSDictionary *)aParam
{
    if (aMappingVO.className == nil) {
//        NSLog(@"HJMappingVO error %@, className is nil", aMappingVO.description);
        return nil;
    }

    Class class = NSClassFromString(aMappingVO.className);
    if (!class) {
        NSLog(@"HJMappingVO error %@, no such class", aMappingVO);
        return nil;
    }

    UIViewController *vc = nil;

    if (aMappingVO.createdType == HJMappingClassCreateByCode) {
        vc = [[class alloc] initWithNibName:nil bundle:nil];
    }
    else if (aMappingVO.createdType == HJMappingClassCreateByXib) {
        NSBundle *bundle = [NSBundle mainBundle];
        vc = [[class alloc] initWithNibName:aMappingVO.nibName bundle:bundle];
    }
    else if (aMappingVO.createdType == HJMappingClassCreateByStoryboard) {
        NSBundle *bundle = [NSBundle mainBundle];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:aMappingVO.storyboardName bundle:bundle];
        vc = [storyboard instantiateViewControllerWithIdentifier:aMappingVO.storyboardID];
    }
    
    aParam = aParam ?: @{};
    vc.extraData = aParam.mutableCopy;
//    if ([vc isKindOfClass:[BaseVC class]]) {
//        BaseVC *tempVC = (BaseVC *)vc;
//        [tempVC configVC];//hook到vc
//    }

    return vc;
}

@end
