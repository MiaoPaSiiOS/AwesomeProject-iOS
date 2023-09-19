//
//  DSVocalLoginViewController.h
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <DarkStarUIKit/DarkStarUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSVocalLoginViewController : DSViewController
@property (nonatomic,copy) void (^vocalLoginBlock)(BOOL success, NSString *error);
@end

NS_ASSUME_NONNULL_END
