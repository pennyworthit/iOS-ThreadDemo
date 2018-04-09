//
//  Customer.m
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/9.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import "Customer.h"

@interface Customer()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *consumed;

@end

@implementation Customer

- (void)consumeNumber:(NSNumber *)aNumber {
    [self.consumed addObject: aNumber];
}

- (void)consumeInteger:(NSInteger)anInt {
    [self.consumed addObject: @(anInt)];
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@", self.consumed];
}

- (NSMutableArray<NSNumber *> *)consumed {
    if (!_consumed) {
        _consumed = [NSMutableArray array];
    }
    
    return _consumed;
}

@end
