

#import "NSArray+DarkStar.h"

@implementation NSArray (DarkStar)
- (nullable id)ds_objectWithIndex:(NSUInteger)index {
    if (index <self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (nullable id)ds_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (NSArray *)ds_sortNSIndexArray {
    if (self.count == 0) { return nil; }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSSortDescriptor *sorter1 = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:YES];
    NSArray *arr = [self sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter,sorter1,nil]];
    return arr;
}


- (NSArray *)ds_splitArrayWithSubSize:(NSInteger)subSize {
    //  数组将被拆分成指定长度数组的个数
    NSInteger count = self.count % subSize == 0 ? (self.count / subSize) : (self.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (NSInteger i = 0; i < count; i ++) {
        //数组下标
        NSInteger index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        NSInteger j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < self.count) {
            [arr1 addObject:[self objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    return [arr copy];
}


@end


@implementation NSMutableArray (DarkStar)

-(void)ds_addObj:(nullable id)obj
{
    if (obj!=nil) {
        [self addObject:obj];
    }
}

- (void)ds_removeFirstObject
{
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (id)ds_popFirstObject
{
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self ds_removeFirstObject];
    }
    return obj;
}

- (id)ds_popLastObject
{
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

- (void)ds_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)ds_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}


@end
