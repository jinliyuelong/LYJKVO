//
//  LYJKVOError.m
//  LYJKVO
//
//  Created by Liyanjun on 2019/4/18.
//  Copyright © 2019 hand. All rights reserved.
//

#import "LYJKVOError.h"


NSString* const LYJKVOErrorDomain = @"LYJKVOErrorDomain";

@implementation LYJKVOError

+ (id)errorNoObervingObject
{
    NSString *message = [NSString stringWithFormat:@"LYJKVOError:没有观察者"];
    return [NSError errorWithDomain:LYJKVOErrorDomain code:LYJKVOErrorTypeNoObervingObject userInfo:@{NSLocalizedDescriptionKey:message}];
}

+ (id)errorNoObervingKey
{
    NSString *message = [NSString stringWithFormat:@"LYJKVOError:没有观察的key"];
    return [NSError errorWithDomain:LYJKVOErrorDomain code:LYJKVOErrorTypeNoObervingKey userInfo:@{NSLocalizedDescriptionKey:message}];
}

+ (id)errorNoObserverOfObject:(id)object
{
    NSString *message = [NSString stringWithFormat:@"LYJKVOError:没有观察者:%@",object];
    return [NSError errorWithDomain:LYJKVOErrorDomain code:LYJKVOErrorTypeNoObserverOfObject userInfo:@{NSLocalizedDescriptionKey:message}];
}

+ (id)errorNoMatchingSetterForKey:(NSString *)key
{
    NSString *message = [NSString stringWithFormat:@"没有观察的key:%@",key];
    return [NSError errorWithDomain:LYJKVOErrorDomain code:LYJKVOErrorTypeNoMatchingSetterForKey userInfo:@{NSLocalizedDescriptionKey:message}];
}

+ (id)errorTransferSetterToGetterFaildedWithSetterName:(NSString *)setterName
{
    NSString *message = [NSString stringWithFormat:@"LYJKVOError:setter转换getter错误:%@",setterName];
    return [NSError errorWithDomain:LYJKVOErrorDomain code:LYJKVOErrorTypeTransferSetterToGetterFailded userInfo:@{NSLocalizedDescriptionKey:message}];
}


+ (id)errorInvalidInputObservingKeys
{
    NSString *message = [NSString stringWithFormat:@"LYJKVOError:非法的观察者key"];
    return [NSError errorWithDomain:LYJKVOErrorDomain code:LYJKVOErrorTypeInvalidInputObservingKeys userInfo:@{NSLocalizedDescriptionKey:message}];
    
}
@end
