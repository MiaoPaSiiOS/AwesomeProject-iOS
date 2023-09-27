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



//  Frame
//////////////////////////////////////////////////

/**
 *    @brief    矩形框.
 */
#ifndef DSFrameAll
#define DSFrameAll(x,y,w,h) CGRectMake((x), (y), (w), (h))
#endif

/**
 *    @brief    坐标为(0, 0)的矩形框.
 */
#ifndef DSFrame
#define DSFrame(w,h) DSFrameAll(0,0,w,h)
#endif

/**
 *    @brief    完整填充frame的矩形框.
 */
#ifndef DSFrameAllInset
#define DSFrameAllInset(frame) DSFrame(frame.size.width,frame.size.height)
#endif
/**
 *    @brief    以inset填充矩形框.
 */
#ifndef DSFrameInset
#define DSFrameInset(frame,inset) CGRectMake(inset.left, inset.top, frame.size.width - inset.left - inset.right, frame.size.height - inset.top - inset.bottom)
#endif


/** 按比例适配的宽度 */
#define DSAutoScale(value) (kAdaptScreenScale(APP_WidthScale * (value)))

#define APP_WidthScale ((MIN(DSCommonMethods.screenWidth, DSCommonMethods.screenHeight))/375.f)

#define kAdaptScreenScale(number) \
({\
CGFloat result = number;\
CGFloat scale = [UIScreen mainScreen].scale;\
CGFloat delta = 1/(scale*2);\
result += delta;\
NSInteger intNumber = (NSInteger)(result);\
CGFloat decimalNumber = result - intNumber;\
NSUInteger count = (NSUInteger)(decimalNumber/delta);\
result = (CGFloat)(intNumber + (count/2)/scale);\
(result);})\


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
