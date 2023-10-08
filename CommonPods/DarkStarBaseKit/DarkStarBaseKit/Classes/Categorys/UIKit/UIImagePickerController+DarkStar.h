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
/*
 
 if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
     NSLog(@"不支持相机");
     return;
 }
 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
 picker.allowsEditing = YES;
 picker.sourceType = UIImagePickerControllerSourceTypeCamera;

 picker.completionBlock = ^(UIImagePickerController *pickerController, NSDictionary *info){
     UIImage *image;
     if (pickerController.allowsEditing == YES) {
         image = [info objectForKey:UIImagePickerControllerEditedImage];
     } else {
         image = [info objectForKey:UIImagePickerControllerOriginalImage];
     }
     
     // 生成一个唯一的文件名
     NSString *fileName = [NSString stringWithFormat:@"Image-%@.jpg", [NSUUID UUID].UUIDString];
     
     // 获取缓存路径
     // 拼接完整的文件路径
     NSString *imagePath = [[RESelectPictureUtil cacheDataFoldPath] stringByAppendingPathComponent:fileName];;
     
     // 将图片保存到指定路径
     NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
     [imageData writeToFile:imagePath atomically:YES];
     
     
     NSDictionary *dict = @{
         @"tempFilePaths":@[imagePath],
     };
     
     if(callback){
         callback(dict);
     }
     [pickerController dismissViewControllerAnimated:YES completion:NULL];
 };

 picker.cancelBlock = ^(UIImagePickerController *picker){
     [picker dismissViewControllerAnimated:YES completion:NULL];
 };
 picker.modalPresentationStyle = UIModalPresentationFullScreen;
 [[self nr_topViewController] presentViewController:picker animated:YES completion:NULL];

 
 */
