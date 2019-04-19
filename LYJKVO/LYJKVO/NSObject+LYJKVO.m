//
//  NSObject+LYJKVO.m
//  LYJKVO
//
//  Created by Liyanjun on 2019/4/18.
//  Copyright © 2019 hand. All rights reserved.
//

#import "NSObject+LYJKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "LYJKVOError.h"

//fixed prefix of kVO Class
NSString *const LYJKVOClassPrefix = @"LYJKVOClass_";

//观察者的key
static const char LYJObservers;

@implementation NSObject (LYJKVO)
// MARK:  - public apis
- (void)lyj_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(LYJKVOBlock)block{
    //error: no observer
    if (!observer) {
        NSLog(@"%@",[LYJKVOError errorNoObervingObject]);
        return;
    }
    //error: no specific key
    if (key.length == 0) {
        NSLog(@"%@",[LYJKVOError errorNoObervingKey]);
    }
    //1.判断当前被观察的类是否存在与传入key对应的setter方法：
    SEL setterSelector = NSSelectorFromString(setterFromGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSLog(@"%@",[LYJKVOError errorNoMatchingSetterForKey:key]);
        return;
    }
    //2. 如果有，判断当前被观察到类是否已经是KVO 如果不是创建带有前缀的kvo类
      Class kvoClass = object_getClass(self);
    NSString *orginClassName =  NSStringFromClass(kvoClass);
    if (![orginClassName hasPrefix:LYJKVOClassPrefix]) {
         kvoClass = [self createKVOClassFromOriginalClassName:orginClassName];
        object_setClass(self, kvoClass);
    }
    
//3.判断新的观察是否会与已经保存的观察项重复（当观察对象和key一致的时候），如果重复，则不添加新的观察：
    NSMutableSet *observers = objc_getAssociatedObject(self, &LYJObservers);
   __block BOOL findSameObserverAndKey = NO;
    if (observers.count>0) {
        [observers enumerateObjectsUsingBlock:^(LYJKVOObserverItem *  _Nonnull item, BOOL * _Nonnull stop) {
            if ( (item.observer == observer) && [item.key isEqualToString:key]) {
                findSameObserverAndKey = YES;
                *stop = YES;
            }
        }];
    }
    
    
    if (!findSameObserverAndKey) {
        [self KVOConfigurationWithObserver:observer key:key block:block kvoClass:kvoClass setterSelector:setterSelector setterMethod:setterMethod];
    }
    
}



- (void)lyj_addObserver:(NSObject *)observer
               forKeys:(NSArray <NSString *>*)keys
             withBlock:(LYJKVOBlock)block
{
    //error: 数组为空
    if (keys.count == 0) {
        NSLog(@"%@",[LYJKVOError errorInvalidInputObservingKeys]);
        return;
    }
    //循环添加
    [keys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
        [self lyj_addObserver:observer forKey:key withBlock:block];
    }];
}

- (void)lyj_removeObserver:(NSObject *)observer
                  forKeys:(NSArray <NSString *>*)keys
{
    NSMutableSet *observers = objc_getAssociatedObject(self, &LYJObservers);
//    NSMutableSet *removingItems = [[NSMutableSet alloc] init];
    
    for (NSString *key in keys) {
        [observers filterUsingPredicate:[NSPredicate predicateWithFormat:@"key != %@",key]];
    }
    
}

- (void)lyj_removeObserver:(NSObject *)observer
                   forKey:(NSString *)key
{
    NSMutableSet* observers = objc_getAssociatedObject(self, &LYJObservers);
    
    [observers filterUsingPredicate:[NSPredicate predicateWithFormat:@"key != %@",key]];
}


- (void)lyj_removeObserver:(NSObject *)observer
{
    NSMutableSet* observers = objc_getAssociatedObject(self, &LYJObservers);
   
    [observers filterUsingPredicate:[NSPredicate predicateWithFormat:@"observer != %@",observer]];
   
}


- (void)lyj_removeAllObservers
{
    NSMutableSet* observers = objc_getAssociatedObject(self, &LYJObservers);
    
    if (observers.count > 0) {
        [observers removeAllObjects];
        NSLog(@"删除所所有了%@",self);
        
    }else{
        NSLog(@"没有可以删除的object:%@",self);
    }
}

- (void)lyj_listAllObservers
{
    NSMutableSet* observers = objc_getAssociatedObject(self, &LYJObservers);
    
    if (observers.count == 0) {
        NSLog(@"没有观察者:%@",self);
        return;
    }
    
    
    NSLog(@"==================== 开始列出观察者: ====================");
    for (LYJKVOObserverItem* item in observers) {
        NSLog(@"%@",item);
    }
}

// MARK:  - private apis

- (void)KVOConfigurationWithObserver:(NSObject *)observer key:(NSString *)key block:(LYJKVOBlock)block kvoClass:(Class)kvoClass setterSelector:(SEL)setterSelector setterMethod:(Method)setterMethod{

    if (![self hasSelector:setterSelector]) {
        class_addMethod(kvoClass, setterSelector, (IMP)kvo_setter_implementation, method_getTypeEncoding(setterMethod));
    }
    
    [self addObserverItem:observer key:key setterSelector:setterSelector setterMethod:setterMethod block:block];
}


- (void)addObserverItem:(NSObject *)observer
                    key:(NSString *)key
         setterSelector:(SEL)setterSelector
           setterMethod:(Method)setterMethod
                  block:(LYJKVOBlock)block
{
    
    NSMutableSet *observers = objc_getAssociatedObject(self, &LYJObservers);
    if (!observers) {
        observers = [[NSMutableSet alloc] init];
        objc_setAssociatedObject(self, &LYJObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    LYJKVOObserverItem *item = [[LYJKVOObserverItem alloc] initWithObserver:observer Key:key setterSelector:setterSelector setterMethod:setterMethod block:block];
    
    if (item) {
        [observers addObject:item];
    }
    
}

- (Class)createKVOClassFromOriginalClassName:(NSString *)originalClassName{
    NSString *kvoClassName = [LYJKVOClassPrefix stringByAppendingString:originalClassName];
    Class kvoClass = NSClassFromString(kvoClassName);
    if (kvoClass) {
       return  kvoClass;
    }
      Class originalClazz = object_getClass(self);
    kvoClass = objc_allocateClassPair(originalClazz, kvoClassName.UTF8String, 0);
    // grab class method's signature so we can borrow it
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    class_addMethod(kvoClass, @selector(class), (IMP)return_original_class, method_getTypeEncoding(clazzMethod));
    objc_registerClassPair(kvoClass);
    return kvoClass;
}


- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}

// MARK:  - c方法
//implementation of KVO setter method
void kvo_setter_implementation(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFromSetter(setterName);
    
    if (!getterName) {
        NSLog(@"%@",[LYJKVOError errorTransferSetterToGetterFaildedWithSetterName:setterName]);
        return;
    }
    
    // create a super class of a specific instance
    Class originclass = object_getClass(self);
    Class superclass = class_getSuperclass(originclass);
    
    struct objc_super superclass_to_call = {
        .super_class = superclass,  //super class
        .receiver = self,           //insatance of this class
    };
    
    // cast method pointer
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, the supper is the original class
    objc_msgSendSuperCasted(&superclass_to_call, _cmd, newValue);
    
    // look up observers and call the blocks
    NSMutableSet *observers = objc_getAssociatedObject(self,&LYJObservers);
    if (observers.count <= 0) {
        NSLog(@"%@",[LYJKVOError errorNoObserverOfObject:self]);
        return;
    }
    
    //get the old value
    id oldValue = [self valueForKey:getterName];
    
    for (LYJKVOObserverItem *item in observers) {
        if ([item.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //call block
                item.block(self, getterName, oldValue, newValue);
            });
        }
    }
}


static NSString * getterFromSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}


static NSString * setterFromGetter(NSString *getter){
    if (getter.length<=0) {
        return nil;
    }
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingPart = [getter substringFromIndex:1];
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingPart];
    
    return setter;
}

Class return_original_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));//because the original class is the super class of KVO class
}



@end
                                            
