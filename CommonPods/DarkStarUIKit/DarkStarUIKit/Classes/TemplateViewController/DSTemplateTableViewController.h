//
//  DSTemplateTableViewController.h
//  DarkStarUIKit
//
//  Created by zhuyuhui on 2023/9/17.
//

#import <DarkStarUIKit/DarkStarUIKit.h>
#import "DSTemplateTableCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface DSTemplateTableViewController : DSTableViewController
@property(nonatomic, strong) NSArray <DSTemplate *>*templates;
@end

NS_ASSUME_NONNULL_END
