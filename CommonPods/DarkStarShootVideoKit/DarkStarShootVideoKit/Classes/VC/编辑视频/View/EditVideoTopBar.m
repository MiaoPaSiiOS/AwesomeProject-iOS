//
//  EditVideoTopBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import "EditVideoTopBar.h"

@interface EditVideoTopBar ()

@property(nonatomic,strong)UIButton * back_Btn;//返回 按钮

@property(nonatomic,strong)DSUIButton * crapMusicItem;//剪音乐
@property(nonatomic,strong)DSUIButton * volumeItem;//音量
@property(nonatomic,strong)DSUIButton * chooseBGMItem;//选音乐

@end

@implementation EditVideoTopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self commit_subviews];
    }
    return self;
}
-(void)commit_subviews
{
    
    //返回按钮
    self.back_Btn = [UIButton buttonWithType:0];
    [self.back_Btn setImage:AmShViImage(@"common_back") forState:0];
    [self.back_Btn setImage:AmShViImage(@"common_back") forState:UIControlStateHighlighted];
    self.back_Btn.frame = CGRectMake((15), 0, (40), (40));
    [self.back_Btn addTarget:self action:@selector(back_item_click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.back_Btn];
    
    self.chooseBGMItem = [self creatItemTitle:@"选音乐" imgName:@"editVide_chooseBGM" index:0];
    [self addSubview:self.chooseBGMItem];
    
    self.volumeItem = [self creatItemTitle:@"音量" imgName:@"editVideo_volume" index:1];
    [self addSubview:self.volumeItem];
    
    self.crapMusicItem = [self creatItemTitle:@"剪音乐" imgName:@"editVideo_crapBGM" index:2];
    [self addSubview:self.crapMusicItem];
}
-(DSUIButton *)creatItemTitle:(NSString *)title imgName:(NSString *)imgName index:(NSInteger)index
{
    DSUIButton * item = [DSUIButton buttonWithType:0];
    item.imagePosition = DSUIButtonImagePositionTop;
    item.frame = CGRectMake(DSDeviceInfo.screenWidth - (15) - (60) - (60)*index, 0, (60), (60));
    [item setTitle:title forState:0];
    [item setTitleColor:[UIColor grayColor] forState:0];
    item.titleLabel.font = [UIFont systemFontOfSize:14];
    [item setImage:AmShViImage(imgName) forState:0];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    item.tag = 4000 + index;
    return item;
}
-(void)itemClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 4000;
    if (tag == 0) {
        //选音乐
        if (self.delegate && [self.delegate respondsToSelector:@selector(editVideoTopBarChooseBGMHandle)]) {
            [self.delegate editVideoTopBarChooseBGMHandle];
        }
    }else if (tag == 1) {
        //音量
        if (self.delegate && [self.delegate respondsToSelector:@selector(editVideoTopBarVolumeHandle)]) {
            [self.delegate editVideoTopBarVolumeHandle];
        }
    }else{
        //剪音乐
        if (self.delegate && [self.delegate respondsToSelector:@selector(editVideoTopBarCrapBGMHandle)]) {
            [self.delegate editVideoTopBarCrapBGMHandle];
        }
    }
}
- (void)updateCrapBGMItemCanUse:(BOOL)canUse
{
    self.crapMusicItem.enabled = canUse;
}
-(void)back_item_click
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editVideoTopBarBackItemHandle)]) {
        [self.delegate editVideoTopBarBackItemHandle];
    }
}
@end
