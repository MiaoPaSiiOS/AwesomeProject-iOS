
//
//  UIImagePickerController+Blocks.m
//  MobileMarketIpad
//
//  Created by GR on 15/10/12.
//  Copyright © 2015年 yitong. All rights reserved.
//

#import "UIImagePickerController+Blocks.h"
#import <objc/runtime.h>

static const void *UIImagePickerControllerCancelBlockKey      = &UIImagePickerControllerCancelBlockKey;
static const void *UIImagePickerControllerCompletionBlockKey  = &UIImagePickerControllerCompletionBlockKey;
static const void *UIImagePickerControllerOriginalDelegateKey = &UIImagePickerControllerOriginalDelegateKey;

@implementation UIImagePickerController (Blocks)
#pragma mark - Public
- (void)setCompletionBlock:(UIImagePickerControllerCompletionBlock)completionBlock
{
    [self p_checkAlertViewDelegate];
    objc_setAssociatedObject(self, UIImagePickerControllerCompletionBlockKey, completionBlock, OBJC_ASSOCIATION_COPY);
}

- (UIImagePickerControllerCompletionBlock)completionBlock
{
    return objc_getAssociatedObject(self, UIImagePickerControllerCompletionBlockKey);
}

- (void)setCancelBlock:(UIImagePickerControllerBlcok)cancelBlock
{
    [self p_checkAlertViewDelegate];
    objc_setAssociatedObject(self, UIImagePickerControllerCancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY);
}

- (UIImagePickerControllerBlcok)cancelBlock
{
    return objc_getAssociatedObject(self, UIImagePickerControllerCancelBlockKey);
}

#pragma mark - Private
- (void)p_checkAlertViewDelegate {
    if (self.delegate != (id<UIImagePickerControllerDelegate>)self) {
        objc_setAssociatedObject(self, UIImagePickerControllerOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)self;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImagePickerControllerCompletionBlock completionBlock = picker.completionBlock;
    if (completionBlock) {
        completionBlock(picker, info);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, UIImagePickerControllerOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [originalDelegate imagePickerController:picker didFinishPickingMediaWithInfo:info];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIImagePickerControllerBlcok cancelBlock = picker.cancelBlock;
    if (cancelBlock) {
        cancelBlock(picker);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, UIImagePickerControllerCancelBlockKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [originalDelegate imagePickerControllerDidCancel:picker];
    }
}
@end
