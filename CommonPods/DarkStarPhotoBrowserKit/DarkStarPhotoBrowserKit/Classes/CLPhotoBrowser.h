//
//  CLPhotoBrowser.h
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPhotoBrowser : UIViewController

///小图位置
@property (nonatomic, assign, readonly) CGRect smallImageFrame;
///大图位置
@property (nonatomic, assign, readonly) CGRect bigImageFrame;
///当前图片URL
@property (nonatomic, strong, readonly, nullable) NSURL *currentImageUrl;
///当前图片
@property (nonatomic, strong, readonly, nullable) UIImage *currentImage;
///当前占位图片
@property (nonatomic, strong, readonly) UIImage *currentPlaceholderImage;



/**
 显示图片浏览器
 
 @param imageUrls 图片url地址数组
 @param placeholder 占位图片
 @param index 当前选中位置
 @param zoomView 动画View
 */
- (void)showPhotoBrowserWithImageUrls:(nonnull NSArray<NSURL *> *)imageUrls placeholder:(nonnull UIImage *)placeholder index:(NSInteger)index zoomView:(nonnull UIView *(^)(NSInteger index))zoomView;


/**
 显示图片浏览器

 @param imageUrls 图片url地址数组
 @param placeholderImages 占位图片数组
 @param index 当前选中位置
 @param zoomView 动画View
 */
- (void)showPhotoBrowserWithImageUrls:(nonnull NSArray<NSURL *> *)imageUrls placeholderImages:(nonnull NSArray<UIImage *> *)placeholderImages index:(NSInteger)index zoomView:(nonnull UIView *(^)(NSInteger index))zoomView;


/**
 显示图片浏览器
 
 @param images image数组
 @param index 当前选中位置
 @param zoomView 动画View
 */
- (void)showPhotoBrowserWithImages:(nonnull NSArray<UIImage *> *)images index:(NSInteger)index zoomView:(nonnull UIView *(^)(NSInteger index))zoomView;


@end

NS_ASSUME_NONNULL_END
/*
 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     __weak __typeof(self) weakSelf = self;
     if (self.isImgae) {
         [self.photoBrowser showPhotoBrowserWithImages:self.imageDataArray index:indexPath.row zoomView:^UIView * _Nonnull(NSInteger index) {
             __typeof(&*weakSelf) strongSelf = weakSelf;
             return [strongSelf zoomView:index];
         }];
     }else {
         [self.photoBrowser showPhotoBrowserWithImageUrls:self.urlDataArray placeholder:[UIImage imageNamed:@"placeholder"] index:indexPath.row zoomView:^UIView * _Nonnull(NSInteger index) {
             __typeof(&*weakSelf) strongSelf = weakSelf;
             return [strongSelf zoomView:index];
         }];
     }
 }

 - (UIView *)zoomView:(NSInteger)index {
     NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
     NSArray<NSIndexPath *> *indexPathArray = [self.collectionView indexPathsForVisibleItems];
     CLPhotoCollectionViewCell *cell;
     if (![indexPathArray containsObject:path]) {
         [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
         [self.collectionView layoutIfNeeded];
     }
     cell = (CLPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:path];
     return cell.imageView;
 }

 
 */
