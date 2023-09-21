//
//  PACalendarCell.h
//  pickDataDemo
//
//  Created by 朱玉辉(EX-ZHUYUHUI001) on 2020/9/15.
//  Copyright © 2020 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PACalendarDayModel.h"
@interface PACalendarCell : UICollectionViewCell
/**
 The day text label of the cell
 */
@property(nonatomic, strong) UILabel  *titleLabel;

/**
 The subtitle label of the cell
 */
@property(nonatomic, strong) UILabel  *subtitleLabel;


/**
 The shape layer of the cell
 */
@property(nonatomic, strong) CAShapeLayer *shapeLayer;


@property(nonatomic, strong) PACalendarDayModel *model;

- (void)configureAppearance;
//- (void)performSelecting;
@end


@interface PACalendarBlankCell : UICollectionViewCell

- (void)configureAppearance;

@end
