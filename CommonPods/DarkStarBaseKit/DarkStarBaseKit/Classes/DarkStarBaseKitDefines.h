//
//  DarkStarBaseKitDefines.h
//  Pods
//
//  Created by zhuyuhui on 2022/8/3.
//

#ifndef DarkStarBaseKitDefines_h
#define DarkStarBaseKitDefines_h


/// 弱引用
#ifndef kWeakSelf
#define kWeakSelf __weak typeof(self) weakSelf = self;
#endif


/// 强引用, 需要与 kWeakSelf 配合使用
#ifndef kStrongSelf
#define kStrongSelf __strong __typeof(&*weakSelf) strongSelf = weakSelf;
#endif

/**
 Synthsize a weak or strong reference.
 
 Example:
    @iUweakify(self)
    [self doSomething^{
        @iUstrongify(self)
        if (!self) return;
        ...
    }];

 */
#ifndef iUweakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define iUweakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define iUweakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define iUweakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define iUweakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef iUstrongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define iUstrongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define iUstrongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define iUstrongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define iUstrongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif




////////////////////////快速创建测试按钮
#define DS_BUTTON_WITH_ACTION(_title, _sel)  \
{   \
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
    button.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];\
    button.layer.cornerRadius = 4;\
    button.titleLabel.font = [UIFont systemFontOfSize:14];\
    [button setTitle:_title forState:UIControlStateNormal];\
    [button addTarget:self action:@selector(_sel) forControlEvents:UIControlEventTouchUpInside];\
    button.frame = CGRectMake(hMargin, vPadding + (index++) * (height + vMargin), width, height);   \
    [scrollView addSubview:button]; \
}

#define DS_CREATE_UI(_addButton, _superView)   \
{   \
    UIScrollView *scrollView = [[UIScrollView alloc] init];  \
    [_superView addSubview:scrollView];  \
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {    \
        make.edges.equalTo(scrollView.superview).insets(UIEdgeInsetsMake(0, 0, 44, 0));\
    }]; \
    CGFloat hMargin = 0.05 * _superView.frame.size.width, vMargin = 15; \
    CGFloat width = _superView.frame.size.width - 2 * hMargin, height = 44; \
    NSInteger index = 0;    \
    CGFloat vPadding = 12;  \
    _addButton  \
    CGFloat maxY = 2 * vPadding + (index - 1) * (height + vMargin) + height;    \
    if (maxY > scrollView.frame.size.height) { \
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, maxY);    \
    }   \
}





#endif /* DarkStarBaseKitDefines_h */
