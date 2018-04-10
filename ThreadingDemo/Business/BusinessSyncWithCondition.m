//
//  BusinessWithCondition.m
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/10.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import "BusinessSyncWithCondition.h"

@interface BusinessSyncWithCondition()

@property (nonatomic, strong) NSCondition *condiction;

@property (nonatomic, strong) Producer *producer;
@property (nonatomic, strong) Customer *customerA;
@property (nonatomic, strong) Customer *customerB;
@property (nonatomic, strong) Customer *customerC;

@end

@implementation BusinessSyncWithCondition

- (instancetype)init {
    self = [super init];
    if (self) {
        self.condiction = [[NSCondition alloc] init];
        self.producer = [[Producer alloc] initWithAmount:100];
        self.customerA = [[Customer alloc] init];
        self.customerB = [[Customer alloc] init];
        self.customerC = [[Customer alloc] init];
    }
    
    return self;
}

- (void)runBusiness{
    NSThread *producerThread = [[NSThread alloc] initWithTarget:self selector:@selector(produce) object:nil];
    NSThread *customerAThread = [[NSThread alloc] initWithTarget:self selector:@selector(consume:) object:self.customerA];
    NSThread *customerBThread = [[NSThread alloc] initWithTarget:self selector:@selector(consume:) object:self.customerB];
    NSThread *customerCThread = [[NSThread alloc] initWithTarget:self selector:@selector(consume:) object:self.customerC];
    
    producerThread.name = @"Producer";
    customerAThread.name = @"CustomerA";
    customerBThread.name = @"CustomerB";
    customerCThread.name = @"CustomerC";
    
    [producerThread start];
    [customerAThread start];
    [customerBThread start];
    [customerCThread start];
}

- (void)produce {
    while (YES) {
        [self.condiction lock];
        while (self.producer.production.count < 5) {
            NSLog(@"producer: producing one...");
            [self.producer produceOne];
            NSLog(@"production count: %@", @(self.producer.production.count));
//            [self.condiction signal];
            [self.condiction broadcast];
            NSLog(@"producer: producing complete...");
        }
        NSLog(@"producer: enough numbers...");
        [self.condiction unlock];
        [NSThread sleepForTimeInterval:3];
    }
}

- (void)consume:(Customer *)customer {
    while (YES) {
        [self.condiction lock];
        while (self.producer.production.count <= 0) {
            NSLog(@"        %@: wating for numbers...", [NSThread currentThread].name);
            [self.condiction wait];
        }
        NSLog(@"        %@: consuming numbers...", [NSThread currentThread].name);
        NSNumber *aNumber = [self.producer.production popObject];
        [customer consumeNumber:aNumber];
        NSLog(@"        %@ consumed count: %@", [NSThread currentThread].name, @(customer.consumed.count));
        [self.condiction unlock];
        [NSThread sleepForTimeInterval:3];
    }
}

@end
