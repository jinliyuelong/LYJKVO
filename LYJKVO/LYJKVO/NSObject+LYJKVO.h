//
//  NSObject+LYJKVO.h
//  LYJKVO
//
//  Created by Liyanjun on 2019/4/18.
//  Copyright © 2019 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYJKVOObserverItem.h"

NS_ASSUME_NONNULL_BEGIN


@interface NSObject (LYJKVO)

//============== add observer ===============//

- (void)lyj_addObserver:(NSObject *)observer forKeys:(NSArray <NSString *>*)keys withBlock:(LYJKVOBlock)block;
- (void)lyj_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(LYJKVOBlock)block;


//============= remove observer =============//

- (void)lyj_removeObserver:(NSObject *)observer forKeys:(NSArray <NSString *>*)keys;
- (void)lyj_removeObserver:(NSObject *)observer forKey:(NSString *)key;
- (void)lyj_removeObserver:(NSObject *)observer;
- (void)lyj_removeAllObservers;


//============= list observers ===============//

- (void)lyj_listAllObservers;


@end

NS_ASSUME_NONNULL_END
