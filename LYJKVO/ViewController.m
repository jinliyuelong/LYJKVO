//
//  ViewController.m
//  LYJKVO
//
//  Created by Liyanjun on 2019/4/18.
//  Copyright © 2019 hand. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "NSObject+LYJKVO.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) Model *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.model = [[Model alloc] init];
    
}

- (IBAction)updateNumber:(UIButton *)sender {
    
    //trigger KVO : number
    NSInteger newNumber = arc4random() % 100;
    self.model.number = [NSNumber numberWithInteger:newNumber];
    
    //trigger KVO : color
    NSArray *colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor]];
    NSInteger colorIndex = arc4random() % 3;
    self.model.color = colors[colorIndex];
}

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



@end
