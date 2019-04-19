//
//  LYJKVOObserverItem.h
//  LYJKVO
//
//  Created by Liyanjun on 2019/4/18.
//  Copyright © 2019 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LYJKVOBlock)(id observedObject, NSString *key, id oldValue, id newValue);
@interface LYJKVOObserverItem : NSObject

@property (nonatomic, strong) NSObject *observer;
@property (nonatomic, copy)   NSString *key;
@property (nonatomic, assign) SEL setterSelector;
@property (nonatomic, assign) Method setterMethod;
@property (nonatomic, copy)   LYJKVOBlock block;


- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key setterSelector:(SEL)setterSelector setterMethod:(Method)setterMethod block:(LYJKVOBlock)block;
@end

NS_ASSUME_NONNULL_END
