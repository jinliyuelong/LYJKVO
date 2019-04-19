//
//  LYJKVOError.h
//  LYJKVO
//
//  Created by Liyanjun on 2019/4/18.
//  Copyright © 2019 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    
    LYJKVOErrorTypeNoObervingObject,
    LYJKVOErrorTypeNoObervingKey,
    LYJKVOErrorTypeNoObserverOfObject,
    LYJKVOErrorTypeNoMatchingSetterForKey,
    LYJKVOErrorTypeTransferSetterToGetterFailded,
    LYJKVOErrorTypeInvalidInputObservingKeys,
    
} LYJKVOErrorTypes;

@interface LYJKVOError : NSError

+ (id)errorNoObervingObject;
+ (id)errorNoObervingKey;
+ (id)errorNoMatchingSetterForKey:(NSString *)key;
+ (id)errorTransferSetterToGetterFaildedWithSetterName:(NSString *)setterName;
+ (id)errorNoObserverOfObject:(id)object;
+ (id)errorInvalidInputObservingKeys;


@end

NS_ASSUME_NONNULL_END
