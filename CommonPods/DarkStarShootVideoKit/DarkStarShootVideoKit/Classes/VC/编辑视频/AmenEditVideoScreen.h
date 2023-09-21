//
//  AmenEditVideoScreen.h
//  AmenShootVideo
//
//  Created by zhuyuhui on 2021/6/22.
//

#import <DarkStarUIKit/DarkStarUIKit.h>
#import "PostVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AmenEditVideoScreen : DSViewController
@property(nonatomic,strong)PostVideoModel * videoModel;//保存视频信息的模型
@end

NS_ASSUME_NONNULL_END
