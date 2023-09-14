//
//  UIAlertAction+DSGray.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "UIAlertAction+DSGray.h"
#import "DSGrayUtil.h"

@implementation UIAlertAction (DSGray)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = object_getClass(self);
        
        Method setTextColorMethod = class_getClassMethod(class, @selector(actionWithTitle:style:handler:));
        Method setGrayTextColorMethod = class_getClassMethod(class, @selector(actionWithGrayTitle:style:handler:));
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(actionWithTitle:style:handler:) oriMethod:setTextColorMethod swizzledSel:@selector(actionWithGrayTitle:style:handler:) swizzledMethod:setGrayTextColorMethod oriClass:class];
    });
}

+ (UIAlertAction *)actionWithGrayTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler{
    UIAlertAction *action = [self actionWithGrayTitle:title style:style handler:handler];
    if ([DSGrayManager shared].grayViewEnabled) {
        [action setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    }
    return action;
}
@end
