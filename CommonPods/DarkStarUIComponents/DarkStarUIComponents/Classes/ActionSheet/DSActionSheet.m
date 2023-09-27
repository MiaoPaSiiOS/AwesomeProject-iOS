
#import "DSActionSheet.h"

CGFloat const kActionCellHeight = 50.f;
CGFloat const kCancelActionHeight = 50.f;
NSString * const kActionCellIdentifier = @"kActionCellIdentifier";
NSInteger const AUActionSheetTag = 47691511;


@interface DSActionSheetCell : UITableViewCell

@property (nonatomic, copy) NSString *contentStr;

@property (nonatomic, assign) BOOL destructive;

@end

@implementation DSActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.f];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = kHexColor(0x3E73FF);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSCommonMethods.screenWidth, 0.5)];
    lineView.backgroundColor = kHexColor(0xE8E8E8);
    [self.contentView addSubview:lineView];
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    self.textLabel.text = contentStr;
}

- (void)setDestructive:(BOOL)destructive {
    _destructive = destructive;
    if (destructive) {
        self.textLabel.textColor = kHexColor(0xFF4D29);
    } else {
        self.textLabel.textColor = kHexColor(0x3E73FF);
    }
}

@end


@interface DSActionSheet () <UITableViewDelegate, UITableViewDataSource>

/// 点击的回调block
@property (nonatomic, copy) void(^clickIndexBlock)(NSInteger index);

@property (nonatomic, strong) UIView *bgView;
// 显示的view, 方便做动画
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) NSString *messageStr;

@property (nonatomic, assign) BOOL destructive;

@property (nonatomic, copy) NSArray<NSString *> * actionArray;

@property (nonatomic, copy) NSString * cancelTitleStr;

@property (nonatomic, strong) UIView *messageView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DSActionSheet

#pragma mark - publish methods
- (instancetype)initWithMessage:(NSString *)message destructive:(BOOL)destructive actionArray:(NSArray<NSString *>*)actionArray cancelTitle:(NSString *)cancelTitle clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, DSCommonMethods.screenWidth, DSCommonMethods.screenHeight);
        self.backgroundColor = kHexAColor(0x000000, 0.4);
        self.alpha = 0;
        _messageStr = message;
        _destructive = destructive;
        _actionArray = actionArray;
        _cancelTitleStr = cancelTitle;
        _clickIndexBlock = clickIndexBlock;
        self.tag = AUActionSheetTag;
        [self initSubviews];
    }
    return self;
}

#pragma mark - Public Methods
+ (void)actionSheetWithMessage:(NSString *)message actionArray:(NSArray<NSString *>*)actionArray cancelTitle:(NSString *)cancelTitle clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    DSActionSheet *actionSheet = [[UIApplication sharedApplication].keyWindow viewWithTag:AUActionSheetTag];
    if (!actionSheet || ![actionSheet isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        actionSheet = [[DSActionSheet alloc] initWithMessage:message destructive:NO actionArray:actionArray cancelTitle:cancelTitle clickIndex:clickIndexBlock];
        [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
    }
}

+ (void)actionSheetDestructiveWithMessage:(NSString *)message actionArray:(NSArray<NSString *>*)actionArray cancelTitle:(NSString *)cancelTitle clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    DSActionSheet *actionSheet = [[UIApplication sharedApplication].keyWindow viewWithTag:AUActionSheetTag];
    if (!actionSheet || ![actionSheet isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        actionSheet = [[DSActionSheet alloc] initWithMessage:message destructive:YES actionArray:actionArray cancelTitle:cancelTitle clickIndex:clickIndexBlock];
        [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
    }
}


+ (void)actionSheetWithActionArray:(NSArray<NSString *>*)actionArray cancelTitle:(NSString *)cancelTitle clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    [self actionSheetWithMessage:@"" actionArray:actionArray cancelTitle:cancelTitle clickIndex:clickIndexBlock];
}


+ (void)actionSheetDestructiveWithActionArray:(NSArray<NSString *>*)actionArray cancelTitle:(NSString *)cancelTitle clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    [self actionSheetDestructiveWithMessage:@"" actionArray:actionArray cancelTitle:cancelTitle clickIndex:clickIndexBlock];
}


+ (void)actionSheetWithMessage:(NSString *)message actionArray:(NSArray<NSString *>*)actionArray clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    [self actionSheetWithMessage:message actionArray:actionArray cancelTitle:@"取消" clickIndex:clickIndexBlock];
}

+ (void)actionSheetDestructiveWithMessage:(NSString *)message actionArray:(NSArray<NSString *>*)actionArray clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    [self actionSheetDestructiveWithMessage:message actionArray:actionArray cancelTitle:@"取消" clickIndex:clickIndexBlock];
}

+ (void)actionSheetDestructiveWithActionArray:(NSArray<NSString *>*)actionArray clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    [self actionSheetDestructiveWithActionArray:actionArray cancelTitle:@"取消" clickIndex:clickIndexBlock];
}


+ (void)actionSheetWithActionArray:(NSArray<NSString *>*)actionArray clickIndex:(void(^)(NSInteger index))clickIndexBlock {
    [self actionSheetWithActionArray:actionArray cancelTitle:@"取消" clickIndex:clickIndexBlock];
}



- (void)dismissActionSheet {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self closeAnimation];
    });
}

#pragma mark - private methods

- (void)initSubviews {
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.leading.equalTo(self);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionDismiss)];
    [self.bgView addGestureRecognizer:tap];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).mas_equalTo(15);
        make.trailing.equalTo(self).mas_equalTo(-15);
        make.top.mas_equalTo(DSCommonMethods.screenHeight);
    }];
    
    if (self.messageStr.length) {
        self.messageView = [[UIView alloc] init];
        self.messageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.messageView];
        UILabel *messageLbl = [[UILabel alloc] init];
        messageLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.f];
        messageLbl.textColor = kHexColor(0x999999);
        messageLbl.text = self.messageStr;
        messageLbl.textAlignment = NSTextAlignmentCenter;
        messageLbl.numberOfLines = 0;
        [messageLbl sizeToFit];
        [self.messageView addSubview:messageLbl];
        [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.messageView).mas_equalTo(15);
            make.trailing.equalTo(self.messageView).mas_equalTo(-15);
            make.top.equalTo(self.messageView).mas_equalTo(17);
            make.bottom.equalTo(self.messageView).mas_equalTo(-17);
        }];
        [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self.contentView);
        }];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.contentView addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(kActionCellHeight*self.actionArray.count);
    }];
    
    if (self.messageStr.length) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageView.mas_bottom);
        }];
    } else {
        self.tableView.layer.cornerRadius = 7.f;
        self.tableView.layer.masksToBounds = YES;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
        }];
    }
    [self.tableView registerClass:[DSActionSheetCell class] forCellReuseIdentifier:kActionCellIdentifier];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.layer.cornerRadius = 7.f;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.f];
    [cancelBtn setTitle:self.cancelTitleStr forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kHexColor(0x4586FF) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(kCancelActionHeight);
        make.top.equalTo(self.tableView.mas_bottom).mas_offset(15);
        CGFloat bottom = 5;
        if(@available(iOS 11.0, *)){
            bottom += [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
        }
        make.bottom.equalTo(self.contentView ).mas_equalTo(-bottom);
    }];
    [self layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addAnimation];
    });
    
    if (self.messageStr.length) {
        
        UIBezierPath *messagePath = [UIBezierPath bezierPathWithRoundedRect:self.messageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7.f, 7.f)];
        //创建 layer
        CAShapeLayer *messageMaskLayer = [[CAShapeLayer alloc] init];
        messageMaskLayer.frame = self.messageView.bounds;
        //赋值
        messageMaskLayer.path = messagePath.CGPath;
        self.messageView.layer.mask = messageMaskLayer;
        
        UIBezierPath *tableViewPath = [UIBezierPath bezierPathWithRoundedRect:self.tableView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(7.f, 7.f)];
        //创建 layer
        CAShapeLayer *tableViewMaskLayer = [[CAShapeLayer alloc] init];
        tableViewMaskLayer.frame = self.tableView.bounds;
        //赋值
        tableViewMaskLayer.path = tableViewPath.CGPath;
        self.tableView.layer.mask = tableViewMaskLayer;
    }

}


- (void)cancelAction {
    if (self.clickIndexBlock) {
        self.clickIndexBlock(0);
    }
    
    [self dismissActionSheet];
}

- (void)tapActionDismiss {
    [self dismissActionSheet];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kActionCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:kActionCellIdentifier forIndexPath:indexPath];
    cell.contentStr = self.actionArray[indexPath.row<self.actionArray.count?indexPath.row:0];
    if (0 == indexPath.row) {
        cell.destructive = self.destructive;
    } else {
        cell.destructive = NO;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickIndexBlock) {
        self.clickIndexBlock(indexPath.row+1);
    }
    [self dismissActionSheet];
}


#pragma mark - 显示时的动画
- (void)addAnimation {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(DSCommonMethods.screenHeight-self.contentView.frame.size.height);
    }];
    [UIView animateWithDuration:.25f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

#pragma mark - 关闭时的动画
- (void)closeAnimation {
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(DSCommonMethods.screenHeight);
    }];
    [UIView animateWithDuration:.25f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
