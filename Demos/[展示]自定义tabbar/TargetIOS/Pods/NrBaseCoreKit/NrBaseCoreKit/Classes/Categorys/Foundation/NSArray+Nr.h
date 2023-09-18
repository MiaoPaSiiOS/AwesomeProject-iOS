

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Nr)

/// 获取数据
/// @param index index description
- (nullable id)nr_objectWithIndex:(NSUInteger)index;

/// 返回数组任意位置对象
- (nullable id)nr_randomObject;

/// 排序对象是NSIndex的数组
- (NSArray *)nr_sortNSIndexArray;

/// 分割数组
/// @param subSize 子长度
- (NSArray *)nr_splitArrayWithSubSize:(NSInteger)subSize;
@end


@interface NSMutableArray (Nr)

/// 添加数据
/// @param obj obj description
-(void)nr_addObj:(nullable id)obj;

/// 删除数组中索引值最低的对象。
- (void)nr_removeFirstObject;

/// 删除并返回数组中索引值最低的对象。如果数组为空，则仅返回nil。
- (nullable id)nr_popFirstObject;

/// 删除并返回数组中索引值最高的对象。如果数组为空，则仅返回nil。
- (nullable id)nr_popLastObject;

/// 数组反转
- (void)nr_reverse;

/// 随机排序
- (void)nr_shuffle;

@end
NS_ASSUME_NONNULL_END
