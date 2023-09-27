//
//  FeedappChildWeiboViewScreen.m
//  AmenHome
//
//  Created by zhuyuhui on 2021/6/17.
//

#import "FeedappChildWeiboViewScreen.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>


#import "WBModel.h"
#import "WBStatusLayout.h"
#import "WBStatusCell.h"
#import "AmenFeedTool.h"
#import "WBStatusComposeViewController.h"
#import "YYPhotoGroupView.h"
#import "YYFPSLabel.h"
#import "AULoadErrorView.h"
#import "AUMoreFailedView.h"

#import "FeedappNetRequest.h"

//#import "WBStatusComposeViewController.h"

@interface FeedappChildWeiboViewScreen ()<WBStatusCellDelegate>
//列表数据数组
@property(nonatomic, strong) NSMutableArray *dataArray;
//当前页，从0开始
@property(nonatomic, assign) NSInteger currentCount;
//正在请求，防止重复请求
@property(nonatomic, assign) BOOL isRequesting;
//是否没有更多
@property(nonatomic, assign) BOOL isNoMore;
//请求错误页面
@property(nonatomic, strong) AULoadErrorView *errorView;
//列表为空页面
@property(nonatomic, strong) AULoadErrorView *emptyView;
//加载更多失败页面
@property(nonatomic, strong) AUMoreFailedView *moreFailedView;
//帧率检测
@property(nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation FeedappChildWeiboViewScreen

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appBar.hidden = YES;
    self.enableRefresh = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    [self.dsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
    }];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.fpsLabel];
    
    [self initialRequest];
}



- (void)initialRequest {
    self.currentCount = 0;
    self.isRequesting = NO;
    self.isNoMore = NO;
    self.errorView.hidden = YES;
    self.emptyView.hidden = YES;
    self.recylerView.mj_footer.hidden = YES;
    self.recylerView.tableFooterView = [UIView new];
    
    [self.recylerView.mj_header beginRefreshing];
}

- (void)headerRefreshAction {
    [self requestData];
}

- (void)footerRefreshAction {
    [self requestData];
}

#pragma mark 请求数据
- (void)requestData {
    if (self.isRequesting) {
        return;
    }
    kWeakSelf
    self.isRequesting = YES;
    
    NSString *path = [NSString stringWithFormat:@"json/result_%ld.json",self.currentCount];
    [FeedappNetRequest achieveJSONDataWithPath:path branch:@"WeiBo" completeHandler:^(BOOL success, NSDictionary *responseObject) {
        kStrongSelf
        if (strongSelf.currentCount == 0) {
            [strongSelf.dataArray removeAllObjects];
        }
        if (!success) {
            if (strongSelf.currentCount == 0) {//第一页加载失败
                strongSelf.errorView.hidden = NO;
                strongSelf.emptyView.hidden = YES;
            }
            else{
                strongSelf.recylerView.mj_footer.hidden = YES;
                strongSelf.recylerView.tableFooterView = self.moreFailedView;
            }
            [strongSelf.recylerView reloadData];
            [strongSelf stopRefresh];
        }else{
            WBTimelineItem *item = [WBTimelineItem yy_modelWithJSON:responseObject];

            if (item.statuses != nil) {
                NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:item.statuses.count];
                for (WBStatus *status in item.statuses) {
                    WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
                    [muArray addObject:layout];
                }

                if (muArray.count == 0 && strongSelf.currentCount == 0) {
                    //空页面
                    strongSelf.isNoMore = YES;
                    strongSelf.errorView.hidden = YES;
                    strongSelf.emptyView.hidden = NO;
                    strongSelf.recylerView.mj_footer.hidden = YES;
                    [strongSelf.recylerView reloadData];
                }else{
                    //正常页面显示
                    strongSelf.errorView.hidden = YES;
                    strongSelf.emptyView.hidden = YES;

                    if (muArray.count > 0) {
                        strongSelf.isNoMore = NO;
                        [strongSelf.dataArray addObjectsFromArray:muArray];
                        strongSelf.currentCount += 1;
                        strongSelf.recylerView.mj_footer.hidden = NO;
                        [strongSelf.recylerView reloadData];
                    }
                    else{
                        //没有更多
                        [strongSelf.dataArray addObjectsFromArray:muArray];
                        strongSelf.isNoMore = YES;
                        strongSelf.currentCount += 1;
                        strongSelf.recylerView.mj_footer.hidden = YES;
                        [strongSelf setMoreFooterView];
                        [strongSelf.recylerView reloadData];
                    }
                }
                [strongSelf stopRefresh];
            }
            else{
                if (strongSelf.currentCount == 0) {
                    //空页面
                    strongSelf.errorView.hidden = YES;
                    strongSelf.emptyView.hidden = NO;
                }
                else{
                    //没有更多
                    strongSelf.isNoMore = YES;
                    strongSelf.recylerView.mj_footer.hidden = YES;
                    [strongSelf setMoreFooterView];
                }
                [strongSelf.recylerView reloadData];
                [strongSelf stopRefresh];
            }
        }
        strongSelf.isRequesting = NO;

    }];
}

//没有更多了
- (void)setMoreFooterView{
    [self noMoreData];
}

#pragma mark - 没有更多页面
- (void)noMoreData{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSCommonMethods.screenWidth, (50))];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:view.frame];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"没有更多啦";
    titleLabel.textColor = kHexColor(0x999999);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [view addSubview:titleLabel];
    self.recylerView.tableFooterView = view;
}







- (void)sendStatus {
//    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
//    vc.type = WBStatusComposeViewTypeStatus;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    @weakify(nav);
//    vc.dismiss = ^{
//        @strongify(nav);
//        [nav dismissViewControllerAnimated:YES completion:NULL];
//    };
//    [self presentViewController:nav animated:YES completion:NULL];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    if (indexPath.row < self.dataArray.count) {
        [cell setLayout:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((WBStatusLayout *)self.dataArray[indexPath.row]).height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - WBStatusCellDelegate
// 此处应该用 Router 之类的东西。。。这里只是个Demo，直接全跳网页吧～

/// 点击了 Cell
- (void)cellDidClick:(WBStatusCell *)cell {
    
}

/// 点击了 Card
- (void)cellDidClickCard:(WBStatusCell *)cell {
    WBPageInfo *pageInfo = cell.statusView.layout.status.pageInfo;
    NSString *url = pageInfo.pageURL; // sinaweibo://... 会跳到 Weibo.app 的。。
}

/// 点击了转发内容
- (void)cellDidClickRetweet:(WBStatusCell *)cell {
    
}

/// 点击了 Cell 菜单
- (void)cellDidClickMenu:(WBStatusCell *)cell {
    
}

/// 点击了下方 Tag
- (void)cellDidClickTag:(WBStatusCell *)cell {
    WBTag *tag = cell.statusView.layout.status.tagStruct.firstObject;
    NSString *url = tag.tagScheme; // sinaweibo://... 会跳到 Weibo.app 的。。
}

/// 点击了关注
- (void)cellDidClickFollow:(WBStatusCell *)cell {
    
}

/// 点击了转发
- (void)cellDidClickRepost:(WBStatusCell *)cell {
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeComment;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    __weak __typeof(nav)weakSelfnav = nav;
    vc.dismiss = ^{
        __strong __typeof(weakSelfnav)strongSelfnav = weakSelfnav;
        [strongSelfnav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了评论
- (void)cellDidClickComment:(WBStatusCell *)cell {
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeComment;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    __weak __typeof(nav)weakSelfnav = nav;
    vc.dismiss = ^{
        __strong __typeof(weakSelfnav)strongSelfnav = weakSelfnav;
        [strongSelfnav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了赞
- (void)cellDidClickLike:(WBStatusCell *)cell {
    WBStatus *status = cell.statusView.layout.status;
    [cell.statusView.toolbarView setLiked:!status.attitudesStatus withAnimation:YES];
}

/// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBUser *)user {
    if (user.userID == 0) return;
    NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/u/%lld",user.userID];
}

/// 点击了图片
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    WBStatus *status = cell.statusView.layout.status;
    NSArray<WBPicture *> *pics = status.retweetedStatus ? status.retweetedStatus.pics : status.pics;

    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        WBPicture *pic = pics[i];
        WBPictureMetadata *meta = pic.largest.badgeType == WBPictureBadgeTypeGIF ? pic.largest : pic.large;
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = meta.url;
        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }

    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

/// 点击了 Label 的链接
- (void)cell:(WBStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;

    if (info[kWBLinkHrefName]) {
        NSString *url = info[kWBLinkHrefName];

        return;
    }

    if (info[kWBLinkURLName]) {
        WBURL *url = info[kWBLinkURLName];
        WBPicture *pic = url.pics.firstObject;
        if (pic) {
            // 点击了文本中的 "图片链接"
            YYTextAttachment *attachment = [label.textLayout.text yy_attribute:YYTextAttachmentAttributeName atIndex:textRange.location];
            if ([attachment.content isKindOfClass:[UIView class]]) {
                YYPhotoGroupItem *info = [YYPhotoGroupItem new];
                info.largeImageURL = pic.large.url;
                info.largeImageSize = CGSizeMake(pic.large.width, pic.large.height);
                
                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[info]];
                [v presentFromImageView:attachment.content toContainer:self.navigationController.view animated:YES completion:nil];
            }

        } else if (url.oriURL.length){

        }
        return;
    }

    if (info[kWBLinkTagName]) {
        WBTag *tag = info[kWBLinkTagName];
        NSLog(@"tag:%@",tag.tagScheme);
        return;
    }

    if (info[kWBLinkTopicName]) {
        WBTopic *topic = info[kWBLinkTopicName];
        NSString *topicStr = topic.topicTitle;
        topicStr = [topicStr stringByURLEncode];
        if (topicStr.length) {
            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@",topicStr];
        }
        return;
    }

    if (info[kWBLinkAtName]) {
        NSString *name = info[kWBLinkAtName];
        name = [name stringByURLEncode];
        if (name.length) {
            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name];
        }
        return;
    }
}

#pragma mark - 错误页面
- (AULoadErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[AULoadErrorView alloc] initWithFrame:self.recylerView.bounds];
        _errorView.type = AULoadServerError;
        kWeakSelf
        [_errorView setRefreshHandle:^(AULoadErrorView * _Nonnull loadErrorView) {
            kStrongSelf
            [strongSelf initialRequest];
        }];
        [self.dsView addSubview:_errorView];
    }
    return _errorView;
}
#pragma mark - 空页面
- (AULoadErrorView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[AULoadErrorView alloc] initWithFrame:self.recylerView.bounds];
        _emptyView.type = AULoadNoData;
        [self.dsView addSubview:_errorView];
    }
    return _emptyView;
}
#pragma mark - 加载更多失败
- (AUMoreFailedView *)moreFailedView{
    if (!_moreFailedView) {
        _moreFailedView = [[AUMoreFailedView alloc] initWithFrame:CGRectMake(0, 0, DSCommonMethods.screenWidth, 68)];
        kWeakSelf
        [_moreFailedView setRetryBlock:^{
            kStrongSelf
            [strongSelf.recylerView setTableFooterView:nil];
            strongSelf.recylerView.mj_footer.hidden = NO;
            [strongSelf.recylerView.mj_footer beginRefreshing];
        }];
    }
    return _moreFailedView;
}

- (YYFPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [YYFPSLabel new];
        [_fpsLabel sizeToFit];
        _fpsLabel.top = 12;
        _fpsLabel.left = 12;
        _fpsLabel.alpha = 0;
    }
    return _fpsLabel;
}
@end
