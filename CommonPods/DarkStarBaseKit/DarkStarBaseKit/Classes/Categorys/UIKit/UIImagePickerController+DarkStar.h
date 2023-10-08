//
//  UIImagePickerController+DarkStar.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/10/8.
//

#import <UIKit/UIKit.h>

typedef void (^UIImagePickerControllerBlcok)(UIImagePickerController *imagePickerContoller);
typedef void (^UIImagePickerControllerCompletionBlock)(UIImagePickerController *imagePickerContoller, NSDictionary *info);

@interface UIImagePickerController (DarkStar)
@property (nonatomic, copy) UIImagePickerControllerBlcok cancelBlock;
@property (nonatomic, copy) UIImagePickerControllerCompletionBlock completionBlock;
@end
