//
//  NrSingleChoiceDialogReusingView.h
//  Animations
//
//  Created by YouXianMing on 2017/11/29.
//  Copyright © 2017年 YouXianMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NrSingleChoiceDialogReusingView : UIView
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger component;
@property (nonatomic, strong) id data;

- (void)setup;
- (void)buildSubView;
- (void)loadContent;

@end


