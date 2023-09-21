//
//  AMENStartAdMgr.h
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMENStartAdMgr : NSObject

//发请求
- (void)sendRequestOfStartAd;

//读取缓存的图片
@property(nonatomic, strong) UIImage * imageOfAd;

@end

NS_ASSUME_NONNULL_END
