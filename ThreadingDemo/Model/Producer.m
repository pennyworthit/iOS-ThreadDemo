//
//  Producer.m
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/9.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import "Producer.h"

@interface Producer()
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *production;
@property (nonatomic, assign) NSInteger nextInt;
@end

@implementation Producer

- (instancetype)initWithAmount:(NSInteger)amount {
    self = [super init];
    if (self) {
        self.amount = amount;
    }

    return self;
}

- (void)produceOne {
    if (self.nextInt > self.amount) {
        NSLog(@"Production exhausted");
        return;
    }
    
    [self.production addObject:@(self.nextInt++)];
}

- (NSMutableArray<NSNumber *> *)production {
    if (!_production) {
        _production = [NSMutableArray arrayWithCapacity:self.amount];
        for (int i = 0; i < 5; i++) {
            [_production addObject:@(i)];
        }
    }
    
    return _production;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.production];
}

@end
