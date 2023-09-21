//
//  IUdZNEmptyView.m
//  IU_MobileFramework
//
//  Created by zhuyuhui on 2021/6/10.
//

#import "IUdZNEmptyView.h"

@interface IUdZNEmptyView ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@end

@implementation IUdZNEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self iuInitSubviews];
    }
    return self;
}

- (void)iuInitSubviews {
    if (!_recylerView) {
        UITableView *recylerView = [self preferredRecylerView];
        [recylerView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self addSubview:recylerView];
        [recylerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(recylerView.superview);
        }];
        self.recylerView = recylerView;
    }
}


#pragma mark - IUTableViewScreenProtocol
- (UITableView *)preferredRecylerView {
    UITableView *recylerView = [[UITableView alloc] initWithFrame:self.bounds style:[self preferredRecylerViewStyle]];
    recylerView.backgroundColor = [UIColor clearColor];
    recylerView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recylerView.delegate = self;
    recylerView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        recylerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        recylerView.estimatedRowHeight = 0;
        recylerView.estimatedSectionHeaderHeight = 0;
        recylerView.estimatedSectionFooterHeight = 0;
    }else{

    }
    return recylerView;
}

- (UITableViewStyle)preferredRecylerViewStyle {
    return UITableViewStylePlain;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


@end
