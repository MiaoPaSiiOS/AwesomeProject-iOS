/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2020 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  DSUIButton.m
//  qmui
//
//  Created by QMUI Team on 14-7-7.
//

#import "DSUIButton.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@implementation CALayer (DSUIButton)


- (void)nrbtn_removeDefaultAnimations {
    NSMutableDictionary<NSString *, id<CAAction>> *actions = @{NSStringFromSelector(@selector(bounds)): [NSNull null],
                                                               NSStringFromSelector(@selector(position)): [NSNull null],
                                                               NSStringFromSelector(@selector(zPosition)): [NSNull null],
                                                               NSStringFromSelector(@selector(anchorPoint)): [NSNull null],
                                                               NSStringFromSelector(@selector(anchorPointZ)): [NSNull null],
                                                               NSStringFromSelector(@selector(transform)): [NSNull null],
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                                               NSStringFromSelector(@selector(hidden)): [NSNull null],
                                                               NSStringFromSelector(@selector(doubleSided)): [NSNull null],
#pragma clang diagnostic pop
                                                               NSStringFromSelector(@selector(sublayerTransform)): [NSNull null],
                                                               NSStringFromSelector(@selector(masksToBounds)): [NSNull null],
                                                               NSStringFromSelector(@selector(contents)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsRect)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsScale)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsCenter)): [NSNull null],
                                                               NSStringFromSelector(@selector(minificationFilterBias)): [NSNull null],
                                                               NSStringFromSelector(@selector(backgroundColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(cornerRadius)): [NSNull null],
                                                               NSStringFromSelector(@selector(borderWidth)): [NSNull null],
                                                               NSStringFromSelector(@selector(borderColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(opacity)): [NSNull null],
                                                               NSStringFromSelector(@selector(compositingFilter)): [NSNull null],
                                                               NSStringFromSelector(@selector(filters)): [NSNull null],
                                                               NSStringFromSelector(@selector(backgroundFilters)): [NSNull null],
                                                               NSStringFromSelector(@selector(shouldRasterize)): [NSNull null],
                                                               NSStringFromSelector(@selector(rasterizationScale)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowOpacity)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowOffset)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowRadius)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowPath)): [NSNull null]}.mutableCopy;
    
    if ([self isKindOfClass:[CAShapeLayer class]]) {
        [actions addEntriesFromDictionary:@{NSStringFromSelector(@selector(path)): [NSNull null],
                                            NSStringFromSelector(@selector(fillColor)): [NSNull null],
                                            NSStringFromSelector(@selector(strokeColor)): [NSNull null],
                                            NSStringFromSelector(@selector(strokeStart)): [NSNull null],
                                            NSStringFromSelector(@selector(strokeEnd)): [NSNull null],
                                            NSStringFromSelector(@selector(lineWidth)): [NSNull null],
                                            NSStringFromSelector(@selector(miterLimit)): [NSNull null],
                                            NSStringFromSelector(@selector(lineDashPhase)): [NSNull null]}];
    }
    
    if ([self isKindOfClass:[CAGradientLayer class]]) {
        [actions addEntriesFromDictionary:@{NSStringFromSelector(@selector(colors)): [NSNull null],
                                            NSStringFromSelector(@selector(locations)): [NSNull null],
                                            NSStringFromSelector(@selector(startPoint)): [NSNull null],
                                            NSStringFromSelector(@selector(endPoint)): [NSNull null]}];
    }
    
    self.actions = actions;
}
@end










@interface DSUIButton ()

@property(nonatomic, strong) CALayer *highlightedBackgroundLayer;
@property(nonatomic, strong) UIColor *originBorderColor;
@end

@implementation DSUIButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self didInitialize];
        self.tintColor = [DSCommonMethods RGBA:49 green:189 blue:243];
        if (!self.adjustsTitleTintColorAutomatically) {
            [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        }
        
        // iOS7以后的button，sizeToFit后默认会自带一个上下的contentInsets，为了保证按钮大小即为内容大小，这里直接去掉，改为一个最小的值。
        self.contentEdgeInsets = UIEdgeInsetsMake(CGFLOAT_MIN, 0, CGFLOAT_MIN, 0);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.adjustsTitleTintColorAutomatically = NO;
    self.adjustsImageTintColorAutomatically = NO;
    
    // 默认接管highlighted和disabled的表现，去掉系统默认的表现
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    self.adjustsButtonWhenHighlighted = YES;
    self.adjustsButtonWhenDisabled = YES;
    
    // 图片默认在按钮左边，与系统UIButton保持一致
    self.imagePosition = DSUIButtonImagePositionLeft;
}

- (CGSize)sizeThatFits:(CGSize)size {
    // 如果调用 sizeToFit，那么传进来的 size 就是当前按钮的 size，此时的计算不要去限制宽高
    if (CGSizeEqualToSize(self.bounds.size, size)) {
        size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    
    BOOL isImageViewShowing = !!self.currentImage;
    BOOL isTitleLabelShowing = !!self.currentTitle || self.currentAttributedTitle;
    CGSize imageTotalSize = CGSizeZero;// 包含 imageEdgeInsets 那些空间
    CGSize titleTotalSize = CGSizeZero;// 包含 titleEdgeInsets 那些空间
    CGFloat spacingBetweenImageAndTitle = [DSComputer flat:isImageViewShowing && isTitleLabelShowing ? self.spacingBetweenImageAndTitle : 0];// 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
    UIEdgeInsets contentEdgeInsets = [DSComputer UIEdgeInsetsRemoveFloatMin:(self.contentEdgeInsets)];
    CGSize resultSize = CGSizeZero;
    CGSize contentLimitSize = CGSizeMake(size.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(contentEdgeInsets)], size.height - [DSComputer UIEdgeInsetsGetVerticalValue:(contentEdgeInsets)]);
    
    switch (self.imagePosition) {
        case DSUIButtonImagePositionTop:
        case DSUIButtonImagePositionBottom: {
            // 图片和文字上下排版时，宽度以文字或图片的最大宽度为最终宽度
            if (isImageViewShowing) {
                CGFloat imageLimitWidth = contentLimitSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.imageEdgeInsets)];
                CGSize imageSize = self.imageView.image ? [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)] : self.currentImage.size;
                imageSize.width = fmin(imageSize.width, imageLimitWidth);
                imageTotalSize = CGSizeMake(imageSize.width + [DSComputer UIEdgeInsetsGetHorizontalValue:(self.imageEdgeInsets)], imageSize.height + [DSComputer UIEdgeInsetsGetVerticalValue:(self.imageEdgeInsets)]);
            }
            
            if (isTitleLabelShowing) {
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)], contentLimitSize.height - imageTotalSize.height - spacingBetweenImageAndTitle - [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]);
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = fmin(titleSize.height, titleLimitSize.height);
                titleTotalSize = CGSizeMake(titleSize.width + [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)], titleSize.height + [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]);
            }
            
            resultSize.width = [DSComputer UIEdgeInsetsGetHorizontalValue:(contentEdgeInsets)];
            resultSize.width += fmax(imageTotalSize.width, titleTotalSize.width);
            resultSize.height = [DSComputer UIEdgeInsetsGetVerticalValue:(contentEdgeInsets)] + imageTotalSize.height + spacingBetweenImageAndTitle + titleTotalSize.height;
        }
            break;
            
        case DSUIButtonImagePositionLeft:
        case DSUIButtonImagePositionRight: {
            // 图片和文字水平排版时，高度以文字或图片的最大高度为最终高度
            // 注意这里有一个和系统不一致的行为：当 titleLabel 为多行时，系统的 sizeThatFits: 计算结果固定是单行的，所以当 DSUIButtonImagePositionLeft 并且titleLabel 多行的情况下，DSUIButton 计算的结果与系统不一致
            
            if (isImageViewShowing) {
                CGFloat imageLimitHeight = contentLimitSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.imageEdgeInsets)];
                CGSize imageSize = self.imageView.image ? [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)] : self.currentImage.size;
                imageSize.height = fmin(imageSize.height, imageLimitHeight);
                imageTotalSize = CGSizeMake(imageSize.width + [DSComputer UIEdgeInsetsGetHorizontalValue:(self.imageEdgeInsets)], imageSize.height + [DSComputer UIEdgeInsetsGetVerticalValue:(self.imageEdgeInsets)]);
            }
            
            if (isTitleLabelShowing) {
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)] - imageTotalSize.width - spacingBetweenImageAndTitle, contentLimitSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]);
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = fmin(titleSize.height, titleLimitSize.height);
                titleTotalSize = CGSizeMake(titleSize.width + [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)], titleSize.height + [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]);
            }
            
            resultSize.width = [DSComputer UIEdgeInsetsGetHorizontalValue:(contentEdgeInsets)] + imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
            resultSize.height = [DSComputer UIEdgeInsetsGetVerticalValue:(contentEdgeInsets)];
            resultSize.height += fmax(imageTotalSize.height, titleTotalSize.height);
        }
            break;
    }
    return resultSize;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    BOOL isImageViewShowing = !!self.currentImage;
    BOOL isTitleLabelShowing = !!self.currentTitle || !!self.currentAttributedTitle;
    CGSize imageLimitSize = CGSizeZero;
    CGSize titleLimitSize = CGSizeZero;
    CGSize imageTotalSize = CGSizeZero;// 包含 imageEdgeInsets 那些空间
    CGSize titleTotalSize = CGSizeZero;// 包含 titleEdgeInsets 那些空间
    CGFloat spacingBetweenImageAndTitle = [DSComputer flat:(isImageViewShowing && isTitleLabelShowing ? self.spacingBetweenImageAndTitle : 0)];// 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
    CGRect imageFrame = CGRectZero;
    CGRect titleFrame = CGRectZero;
    UIEdgeInsets contentEdgeInsets = [DSComputer UIEdgeInsetsRemoveFloatMin:(self.contentEdgeInsets)];
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - [DSComputer UIEdgeInsetsGetHorizontalValue:(contentEdgeInsets)], CGRectGetHeight(self.bounds) - [DSComputer UIEdgeInsetsGetVerticalValue:(contentEdgeInsets)]);
    
    // 图片的布局原则都是尽量完整展示，所以不管 imagePosition 的值是什么，这个计算过程都是相同的
    if (isImageViewShowing) {
        imageLimitSize = CGSizeMake(contentSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.imageEdgeInsets)], contentSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.imageEdgeInsets)]);
        CGSize imageSize = self.imageView.image ? [self.imageView sizeThatFits:imageLimitSize] : self.currentImage.size;
        imageSize.width = fmin(imageLimitSize.width, imageSize.width);
        imageSize.height = fmin(imageLimitSize.height, imageSize.height);
        imageFrame = [DSComputer CGRectMakeWithSize:(imageSize)];
        imageTotalSize = CGSizeMake(imageSize.width + [DSComputer UIEdgeInsetsGetHorizontalValue:(self.imageEdgeInsets)], imageSize.height + [DSComputer UIEdgeInsetsGetVerticalValue:(self.imageEdgeInsets)]);
    }
    
    if (self.imagePosition == DSUIButtonImagePositionTop || self.imagePosition == DSUIButtonImagePositionBottom) {
        
        if (isTitleLabelShowing) {
            titleLimitSize = CGSizeMake(contentSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)], contentSize.height - imageTotalSize.height - spacingBetweenImageAndTitle - [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]);
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.width = fmin(titleLimitSize.width, titleSize.width);
            titleSize.height = fmin(titleLimitSize.height, titleSize.height);
            titleFrame = [DSComputer CGRectMakeWithSize:(titleSize)];
            titleTotalSize = CGSizeMake(titleSize.width + [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)], titleSize.height + [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]);
        }
        
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
                imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x:contentEdgeInsets.left + self.imageEdgeInsets.left] : imageFrame;
                titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x:contentEdgeInsets.left + self.titleEdgeInsets.left] : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x:contentEdgeInsets.left + self.imageEdgeInsets.left + [DSComputer CGFloatGetCenter:imageLimitSize.width child:CGRectGetWidth(imageFrame)]] : imageFrame;
                titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x:contentEdgeInsets.left + self.titleEdgeInsets.left + [DSComputer CGFloatGetCenter:titleLimitSize.width child:CGRectGetWidth(titleFrame)]] : titleFrame;
                
                break;
            case UIControlContentHorizontalAlignmentRight:
                imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x:CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)] : imageFrame;
                titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x:CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)] : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentFill:
                if (isImageViewShowing) {
                    imageFrame = [DSComputer CGRectSetX:imageFrame x:contentEdgeInsets.left + self.imageEdgeInsets.left];
                    imageFrame = [DSComputer CGRectSetWidth:imageFrame width:imageLimitSize.width];
                }
                if (isTitleLabelShowing) {
                    titleFrame = [DSComputer CGRectSetX:titleFrame x:contentEdgeInsets.left + self.titleEdgeInsets.left];
                    titleFrame = [DSComputer CGRectSetWidth:titleFrame width:titleLimitSize.width];
                }
                break;
            default:
                break;
        }
        
        if (self.imagePosition == DSUIButtonImagePositionTop) {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y:contentEdgeInsets.top + self.imageEdgeInsets.top] : imageFrame;
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y:contentEdgeInsets.top + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top] : titleFrame;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = imageTotalSize.height + spacingBetweenImageAndTitle + titleTotalSize.height;
                    CGFloat minY = [DSComputer CGFloatGetCenter:contentSize.height child:contentHeight] + contentEdgeInsets.top;
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y: minY + self.imageEdgeInsets.top] : imageFrame;
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y: minY + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top] : titleFrame;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y: CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)] : titleFrame;
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y: CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - titleTotalSize.height - spacingBetweenImageAndTitle - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)] : imageFrame;
                    break;
                case UIControlContentVerticalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y:contentEdgeInsets.top + self.imageEdgeInsets.top] : imageFrame;
                        titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y:contentEdgeInsets.top + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top] : titleFrame;
                        titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetHeight:titleFrame height:CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame)] : titleFrame;
                        
                    } else if (isImageViewShowing) {
                        imageFrame = [DSComputer CGRectSetY:imageFrame y:contentEdgeInsets.top + self.imageEdgeInsets.top];
                        imageFrame = [DSComputer CGRectSetHeight:imageFrame height: contentSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.imageEdgeInsets)]];
                    } else {
                        titleFrame = [DSComputer CGRectSetY:titleFrame y: contentEdgeInsets.top + self.titleEdgeInsets.top];
                        titleFrame = [DSComputer CGRectSetHeight:titleFrame height:contentSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]];
                    }
                }
                    break;
            }
        } else {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y: contentEdgeInsets.top + self.titleEdgeInsets.top] : titleFrame;
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y: contentEdgeInsets.top + titleTotalSize.height + spacingBetweenImageAndTitle + self.imageEdgeInsets.top] : imageFrame;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = imageTotalSize.height + titleTotalSize.height + spacingBetweenImageAndTitle;
                    CGFloat minY = [DSComputer CGFloatGetCenter:contentSize.height child: contentHeight] + contentEdgeInsets.top;
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y: minY + self.titleEdgeInsets.top] : titleFrame;
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y:minY + titleTotalSize.height + spacingBetweenImageAndTitle + self.imageEdgeInsets.top] : imageFrame;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y: CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)] : imageFrame;
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y: CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - imageTotalSize.height - spacingBetweenImageAndTitle - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)] : titleFrame;
                    break;
                case UIControlContentVerticalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = [DSComputer CGRectSetY:imageFrame y: CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)];
                        titleFrame = [DSComputer CGRectSetY:titleFrame y: contentEdgeInsets.top + self.titleEdgeInsets.top];
                        titleFrame = [DSComputer CGRectSetHeight:titleFrame height: CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - imageTotalSize.height - spacingBetweenImageAndTitle - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame)];
                        
                    } else if (isImageViewShowing) {
                        imageFrame = [DSComputer CGRectSetY:imageFrame y: contentEdgeInsets.top + self.imageEdgeInsets.top];
                        imageFrame = [DSComputer CGRectSetHeight:imageFrame height: contentSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.imageEdgeInsets)]];
                    } else {
                        titleFrame = [DSComputer CGRectSetY:titleFrame y:contentEdgeInsets.top + self.titleEdgeInsets.top];
                        titleFrame = [DSComputer CGRectSetHeight:titleFrame height:contentSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]];
                    }
                }
                    break;
            }
        }
        
        if (isImageViewShowing) {
            self.imageView.frame = [DSComputer CGRectFlatted:(imageFrame)];
        }
        if (isTitleLabelShowing) {
            self.titleLabel.frame = [DSComputer CGRectFlatted:(titleFrame)];
        }
        
    } else if (self.imagePosition == DSUIButtonImagePositionLeft || self.imagePosition == DSUIButtonImagePositionRight) {
        
        if (isTitleLabelShowing) {
            titleLimitSize = CGSizeMake(contentSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)] - imageTotalSize.width - spacingBetweenImageAndTitle, contentSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]);
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.width = fmin(titleLimitSize.width, titleSize.width);
            titleSize.height = fmin(titleLimitSize.height, titleSize.height);
            titleFrame = [DSComputer CGRectMakeWithSize:(titleSize)];
            titleTotalSize = CGSizeMake(titleSize.width + [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)], titleSize.height + [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]);
        }
        
        switch (self.contentVerticalAlignment) {
            case UIControlContentVerticalAlignmentTop:
                imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y: contentEdgeInsets.top + self.imageEdgeInsets.top] : imageFrame;
                titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y: contentEdgeInsets.top + self.titleEdgeInsets.top] : titleFrame;
                
                break;
            case UIControlContentVerticalAlignmentCenter:
                imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y:contentEdgeInsets.top + [DSComputer CGFloatGetCenter:contentSize.height child:CGRectGetHeight(imageFrame)] + self.imageEdgeInsets.top]: imageFrame;
                titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y:contentEdgeInsets.top + [DSComputer CGFloatGetCenter:contentSize.height child:CGRectGetHeight(titleFrame)] + self.titleEdgeInsets.top] : titleFrame;
                break;
            case UIControlContentVerticalAlignmentBottom:
                imageFrame = isImageViewShowing ? [DSComputer CGRectSetY:imageFrame y: CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)] : imageFrame;
                titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetY:titleFrame y: CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)] : titleFrame;
                break;
            case UIControlContentVerticalAlignmentFill:
                if (isImageViewShowing) {
                    imageFrame = [DSComputer CGRectSetY:imageFrame y: contentEdgeInsets.top + self.imageEdgeInsets.top];
                    imageFrame = [DSComputer CGRectSetHeight:imageFrame height: contentSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.imageEdgeInsets)]];
                }
                if (isTitleLabelShowing) {
                    titleFrame = [DSComputer CGRectSetY:titleFrame y: contentEdgeInsets.top + self.titleEdgeInsets.top];
                    titleFrame = [DSComputer CGRectSetHeight:titleFrame height:contentSize.height - [DSComputer UIEdgeInsetsGetVerticalValue:(self.titleEdgeInsets)]];
                }
                break;
        }
        
        if (self.imagePosition == DSUIButtonImagePositionLeft) {
            switch (self.contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentLeft:
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x: contentEdgeInsets.left + self.imageEdgeInsets.left] : imageFrame;
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x: contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left] : titleFrame;
                    break;
                case UIControlContentHorizontalAlignmentCenter: {
                    CGFloat contentWidth = imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
                    CGFloat minX = contentEdgeInsets.left + [DSComputer CGFloatGetCenter:contentSize.width child: contentWidth];
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x: minX + self.imageEdgeInsets.left] : imageFrame;
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x: minX + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left] : titleFrame;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight: {
                    if (imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width > contentSize.width) {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x: contentEdgeInsets.left + self.imageEdgeInsets.left] : imageFrame;
                        titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x: contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left] : titleFrame;
                    } else {
                        // 内容不超过按钮宽度，则靠右布局即可
                        titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x: CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)] : titleFrame;
                        imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x: CGRectGetWidth(self.bounds) - contentEdgeInsets.right - titleTotalSize.width - spacingBetweenImageAndTitle - imageTotalSize.width + self.imageEdgeInsets.left] : imageFrame;
                    }
                }
                    break;
                case UIControlContentHorizontalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        // 同时显示图片和 label 的情况下，图片按本身宽度显示，剩余空间留给 label
                        imageFrame = [DSComputer CGRectSetX:imageFrame x: contentEdgeInsets.left + self.imageEdgeInsets.left];
                        titleFrame = [DSComputer CGRectSetX:titleFrame x: contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left];
                        titleFrame = [DSComputer CGRectSetWidth:titleFrame width: CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame)];
                    } else if (isImageViewShowing) {
                        imageFrame = [DSComputer CGRectSetX:imageFrame x: contentEdgeInsets.left + self.imageEdgeInsets.left];
                        imageFrame = [DSComputer CGRectSetWidth:imageFrame width: contentSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.imageEdgeInsets)]];
                    } else {
                        titleFrame = [DSComputer CGRectSetX:titleFrame x: contentEdgeInsets.left + self.titleEdgeInsets.left];
                        titleFrame = [DSComputer CGRectSetWidth:titleFrame width: contentSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)]];
                    }
                }
                    break;
                default:
                    break;
            }
        } else {
            switch (self.contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentLeft: {
                    if (imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width > contentSize.width) {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x: CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)] : imageFrame;
                        titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x: CGRectGetWidth(self.bounds) - contentEdgeInsets.right - imageTotalSize.width - spacingBetweenImageAndTitle - titleTotalSize.width + self.titleEdgeInsets.left] : titleFrame;
                    } else {
                        // 内容不超过按钮宽度，则靠左布局即可
                        titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x: contentEdgeInsets.left + self.titleEdgeInsets.left]: titleFrame;
                        imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x: contentEdgeInsets.left + titleTotalSize.width + spacingBetweenImageAndTitle + self.imageEdgeInsets.left] : imageFrame;
                    }
                }
                    break;
                case UIControlContentHorizontalAlignmentCenter: {
                    CGFloat contentWidth = imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
                    CGFloat minX = contentEdgeInsets.left + [DSComputer CGFloatGetCenter:contentSize.width child: contentWidth];
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x: minX + self.titleEdgeInsets.left] : titleFrame;
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x: minX + titleTotalSize.width + spacingBetweenImageAndTitle + self.imageEdgeInsets.left] : imageFrame;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight:
                    imageFrame = isImageViewShowing ? [DSComputer CGRectSetX:imageFrame x: CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)] : imageFrame;
                    titleFrame = isTitleLabelShowing ? [DSComputer CGRectSetX:titleFrame x: CGRectGetWidth(self.bounds) - contentEdgeInsets.right - imageTotalSize.width - spacingBetweenImageAndTitle - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)] : titleFrame;
                    break;
                case UIControlContentHorizontalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        // 图片按自身大小显示，剩余空间由标题占满
                        imageFrame = [DSComputer CGRectSetX:imageFrame x: CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)];
                        titleFrame = [DSComputer CGRectSetX:titleFrame x: contentEdgeInsets.left + self.titleEdgeInsets.left];
                        titleFrame = [DSComputer CGRectSetWidth:titleFrame width: CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - spacingBetweenImageAndTitle - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame)];
                        
                    } else if (isImageViewShowing) {
                        imageFrame = [DSComputer CGRectSetX:imageFrame x: contentEdgeInsets.left + self.imageEdgeInsets.left];
                        imageFrame = [DSComputer CGRectSetWidth:imageFrame width: contentSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.imageEdgeInsets)]];
                    } else {
                        titleFrame = [DSComputer CGRectSetX:titleFrame x: contentEdgeInsets.left + self.titleEdgeInsets.left];
                        titleFrame = [DSComputer CGRectSetWidth:titleFrame width: contentSize.width - [DSComputer UIEdgeInsetsGetHorizontalValue:(self.titleEdgeInsets)]];
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
        if (isImageViewShowing) {
            self.imageView.frame = [DSComputer CGRectFlatted:(imageFrame)];
        }
        if (isTitleLabelShowing) {
            self.titleLabel.frame = [DSComputer CGRectFlatted:(titleFrame)];
        }
    }
}

- (void)setSpacingBetweenImageAndTitle:(CGFloat)spacingBetweenImageAndTitle {
    _spacingBetweenImageAndTitle = spacingBetweenImageAndTitle;
    
    [self setNeedsLayout];
}

- (void)setImagePosition:(DSUIButtonImagePosition)imagePosition {
    _imagePosition = imagePosition;
    
    [self setNeedsLayout];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    if (_highlightedBackgroundColor) {
        // 只要开启了highlightedBackgroundColor，就默认不需要alpha的高亮
        self.adjustsButtonWhenHighlighted = NO;
    }
}

- (void)setHighlightedBorderColor:(UIColor *)highlightedBorderColor {
    _highlightedBorderColor = highlightedBorderColor;
    if (_highlightedBorderColor) {
        // 只要开启了highlightedBorderColor，就默认不需要alpha的高亮
        self.adjustsButtonWhenHighlighted = NO;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted && !self.originBorderColor) {
        // 手指按在按钮上会不断触发setHighlighted:，所以这里做了保护，设置过一次就不用再设置了
        self.originBorderColor = [UIColor colorWithCGColor:self.layer.borderColor];
    }
    
    // 渲染背景色
    if (self.highlightedBackgroundColor || self.highlightedBorderColor) {
        [self adjustsButtonHighlighted];
    }
    // 如果此时是disabled，则disabled的样式优先
    if (!self.enabled) {
        return;
    }
    // 自定义highlighted样式
    if (self.adjustsButtonWhenHighlighted) {
        if (highlighted) {
            self.alpha = 0.5;
        } else {
            self.alpha = 1;
        }
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled && self.adjustsButtonWhenDisabled) {
        self.alpha = 0.5;
    } else {
        self.alpha = 1;
    }
}

- (void)adjustsButtonHighlighted {
    if (self.highlightedBackgroundColor) {
        if (!self.highlightedBackgroundLayer) {
            self.highlightedBackgroundLayer = [CALayer layer];
            [self.highlightedBackgroundLayer nrbtn_removeDefaultAnimations];
            [self.layer insertSublayer:self.highlightedBackgroundLayer atIndex:0];
        }
        self.highlightedBackgroundLayer.frame = self.bounds;
        self.highlightedBackgroundLayer.cornerRadius = self.layer.cornerRadius;
        self.highlightedBackgroundLayer.backgroundColor = self.highlighted ? self.highlightedBackgroundColor.CGColor : [UIColor clearColor].CGColor;
    }
    
    if (self.highlightedBorderColor) {
        self.layer.borderColor = self.highlighted ? self.highlightedBorderColor.CGColor : self.originBorderColor.CGColor;
    }
}

- (void)setAdjustsTitleTintColorAutomatically:(BOOL)adjustsTitleTintColorAutomatically {
    _adjustsTitleTintColorAutomatically = adjustsTitleTintColorAutomatically;
    [self updateTitleColorIfNeeded];
}

- (void)updateTitleColorIfNeeded {
    if (self.adjustsTitleTintColorAutomatically && self.currentTitleColor) {
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    }
    if (self.adjustsTitleTintColorAutomatically && self.currentAttributedTitle) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.currentAttributedTitle];
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.tintColor range:NSMakeRange(0, attributedString.length)];
        [self setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
}

- (void)setAdjustsImageTintColorAutomatically:(BOOL)adjustsImageTintColorAutomatically {
    BOOL valueDifference = _adjustsImageTintColorAutomatically != adjustsImageTintColorAutomatically;
    _adjustsImageTintColorAutomatically = adjustsImageTintColorAutomatically;
    
    if (valueDifference) {
        [self updateImageRenderingModeIfNeeded];
    }
}

- (void)updateImageRenderingModeIfNeeded {
    if (self.currentImage) {
        NSArray<NSNumber *> *states = @[@(UIControlStateNormal), @(UIControlStateHighlighted), @(UIControlStateSelected), @(UIControlStateSelected|UIControlStateHighlighted), @(UIControlStateDisabled)];
        
        for (NSNumber *number in states) {
            UIImage *image = [self imageForState:number.unsignedIntegerValue];
            if (!image) {
                return;
            }
            
            if (self.adjustsImageTintColorAutomatically) {
                // 这里的 setImage: 操作不需要使用 renderingMode 对 image 重新处理，而是放到重写的 setImage:forState 里去做就行了
                [self setImage:image forState:[number unsignedIntegerValue]];
            } else {
                // 如果不需要用template的模式渲染，并且之前是使用template的，则把renderingMode改回Original
                [self setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:[number unsignedIntegerValue]];
            }
        }
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    if (self.adjustsImageTintColorAutomatically) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    [super setImage:image forState:state];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    [self updateTitleColorIfNeeded];
    
    if (self.adjustsImageTintColorAutomatically) {
        [self updateImageRenderingModeIfNeeded];
    }
}

- (void)setTintColorAdjustsTitleAndImage:(UIColor *)tintColorAdjustsTitleAndImage {
    _tintColorAdjustsTitleAndImage = tintColorAdjustsTitleAndImage;
    if (tintColorAdjustsTitleAndImage) {
        self.tintColor = tintColorAdjustsTitleAndImage;
        self.adjustsTitleTintColorAutomatically = YES;
        self.adjustsImageTintColorAutomatically = YES;
    }
}

@end





