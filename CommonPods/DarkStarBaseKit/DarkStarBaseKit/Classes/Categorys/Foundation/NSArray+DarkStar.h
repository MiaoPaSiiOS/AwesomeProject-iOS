

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (DarkStar)

/// 获取数据
/// @param index index description
- (nullable id)ds_objectWithIndex:(NSUInteger)index;

/// 返回数组任意位置对象
- (nullable id)ds_randomObject;

/// 排序对象是NSIndex的数组
- (NSArray *)ds_sortNSIndexArray;

/// 分割数组
/// @param subSize 子长度
- (NSArray *)ds_splitArrayWithSubSize:(NSInteger)subSize;
@end


@interface NSMutableArray (DarkStar)

/// 添加数据
/// @param obj obj description
-(void)ds_addObj:(nullable id)obj;

/// 删除数组中索引值最低的对象。
- (void)ds_removeFirstObject;

/// 删除并返回数组中索引值最低的对象。如果数组为空，则仅返回nil。
- (nullable id)ds_popFirstObject;

/// 删除并返回数组中索引值最高的对象。如果数组为空，则仅返回nil。
- (nullable id)ds_popLastObject;

/// 数组反转
- (void)ds_reverse;

/// 随机排序
- (void)ds_shuffle;

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
