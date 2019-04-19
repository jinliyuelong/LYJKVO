##LYJKVO
参考 [ImplementKVO](https://github.com/okcomp/ImplementKVO) 写的demo

可以实现

1. 支持一次观察同一对象的多个属性。
2. 可以一次只观察一个对象的一个属性。
1. 可以移除对某个对象对多个属性的观察。
1. 可以移除对某个对象对某个属性的观察。
1. 可以移除某个观察自己的对象。
1. 可以移除所有观察自己的对象。
1. 打印出所有观察自己的对象的信息，包括对象本身，观察的属性，setter方法。

###用法
```objc 
- (IBAction)addObserverSeparatedly:(UIButton *)sender {
    
    [self.model lyj_addObserver:self forKey:@"number" withBlock:^(id observedObject, NSString *key, id oldValue, id newValue) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.numberLabel.text = [NSString stringWithFormat:@"%@",newValue];
        });
        
    }];
    
    [self.model lyj_addObserver:self forKey:@"color" withBlock:^(id observedObject, NSString *key, id oldValue, id newValue) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.numberLabel.backgroundColor = newValue;
        });
        
    }];
    
}

- (IBAction)addObserversTogether:(UIButton *)sender {
    
    NSArray *keys = @[@"number",@"color"];
    
    [self.model lyj_addObserver:self forKeys:keys withBlock:^(id observedObject, NSString *key, id oldValue, id newValue) {
        
        if ([key isEqualToString:@"number"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.numberLabel.text = [NSString stringWithFormat:@"%@",newValue];
            });
            
        }else if ([key isEqualToString:@"color"]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.numberLabel.backgroundColor = newValue;
            });
        }
        
    }];
}


- (IBAction)removeAllObservingItems:(UIButton *)sender {
    
    [self.model lyj_removeObserver:self forKeys:@[@"number",@"color"]];
//    [self.model lyj_removeObserver:self forKeys:@[@"number"]];
//    [self.model lyj_removeObserver:self forKey:@"color"];
//    [self.model lyj_removeObserver:self];
//    [self.model lyj_removeAllObservers];
    
}


- (IBAction)showAllObservingItems:(UIButton *)sender {
    
    [self.model lyj_listAllObservers];
}

```