//
//  UIImagePickerController+Blocks.h
//  MobileMarketIpad
//
//  Created by GR on 15/10/12.
//  Copyright © 2015年 yitong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIImagePickerControllerBlcok)(UIImagePickerController *imagePickerContoller);
typedef void (^UIImagePickerControllerCompletionBlock)(UIImagePickerController *imagePickerContoller, NSDictionary *info);

@interface UIImagePickerController (Blocks)
@property (nonatomic, copy) UIImagePickerControllerBlcok cancelBlock;
@property (nonatomic, copy) UIImagePickerControllerCompletionBlock completionBlock;
@end
