//
//  HXASCellNode.h
//  HongXun
//
//  Created by 张炯 on 2018/4/3.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class ASCellNode;
@class HXWCDynamic;

@interface HXASCellNode : ASCellNode

- (instancetype)initWithModel:(HXWCDynamic *)model;

@end
