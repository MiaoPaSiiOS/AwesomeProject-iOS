//
//  QMFrameThemeView.m
//  EnjoyCamera
//
//  Created by qinmin on 2017/9/19.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "QMFrameThemeView.h"
#import "QMFrameThemeViewCell.h"
#import "Constants.h"

#define kCropThemeCollectionViewCellID @"FrameThemeCollectionViewCellID"

@interface QMFrameThemeView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation QMFrameThemeView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildCollectionView];
        [self setTitle:@"相框"];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(10, 40, self.contentView.frame.size.width-20,self.contentView.frame.size.height - 40);
}
- (void)buildCollectionView
{
    // collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 5;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, self.frame.size.width-20,self.frame.size.height-50) collectionViewLayout:layout];
    collectionView.backgroundColor = self.contentView.backgroundColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollsToTop = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[AECResouce nibWithNibName:@"QMFrameThemeViewCell"] forCellWithReuseIdentifier:kCropThemeCollectionViewCellID];
    [self.contentView addSubview:collectionView];
    _collectionView = collectionView;
}

#pragma mark - PublicMethod
- (void)reloadData
{
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _frameModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QMFrameThemeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCropThemeCollectionViewCellID forIndexPath:indexPath];
    QMFrameModel *model = _frameModels[indexPath.row];
    [cell.imageView sd_setImageWithURL:[[AECResouce Frames] URLForResource:model.icon withExtension:nil]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    QMFrameModel *model = _frameModels[indexPath.row];
    if (self.frameClickBlock) {
        self.frameClickBlock(model);
    }
}


@end
