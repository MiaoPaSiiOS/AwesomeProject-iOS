//
//  AmenChooseBgMusicScreen.h
//  AmenShootVideo
//
//  Created by zhuyuhui on 2021/6/22.
//

#import <DarkStarUIKit/DarkStarUIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ChooseBGMusicDelegate;
@interface AmenChooseBgMusicScreen : DSTableViewController
@property(nonatomic,weak)id <ChooseBGMusicDelegate> delegate;
@end

@protocol ChooseBGMusicDelegate <NSObject>

-(void)bgMusicChooseCallBack:(NSString *)choosedMusicName;

@end
NS_ASSUME_NONNULL_END
