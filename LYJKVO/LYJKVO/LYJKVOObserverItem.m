//
//  LYJKVOObserverItem.m
//  LYJKVO
//
//  Created by Liyanjun on 2019/4/18.
//  Copyright © 2019 hand. All rights reserved.
//

#import "LYJKVOObserverItem.h"

@implementation LYJKVOObserverItem


- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key setterSelector:(SEL)setterSelector setterMethod:(Method)setterMethod block:(LYJKVOBlock)block

{
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _setterSelector = setterSelector;
        _setterMethod = setterMethod;
        _block = block;
    }
    return self;
}

- (instancetype)init{
    
    NSAssert(NO, @"LYJKVOLog:must use ‘initWithObserver:key:setterSelector:setterMethod:block:’ initializer");
    return nil;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"LYJKVOLog:observer item:{observer: %@ | key: %@ | setter: %@}",_observer,_key,NSStringFromSelector(_setterSelector)];
}

@end
