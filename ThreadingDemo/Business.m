//
//  Business.m
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/9.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import "Business.h"
#import "Producer.h"
#import "Customer.h"
#import "NSMutableArray+Basic.h"

@interface Business()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *production;

@end

@implementation Business

- (instancetype)init {
    self = [super init];
    if (self) {
        self.production = [[Producer alloc] initWithAmount:20].production;
        self.lock = [[NSLock alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)runBusiness {
    Customer *customerA = [[Customer alloc] init];
    Customer *customerB = [[Customer alloc] init];
    
    NSThread *purchaseA = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:customerA];
    [purchaseA setName:@"A"];
    NSThread *purchaseB = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:customerB];
    [purchaseB setName:@"B"];
    
    [purchaseA start];
    [purchaseB start];
}

- (void)run:(Customer *)aCustomer {
    while (YES) {
        if ([self.lock tryLock]) {
            if (self.production.count > 0) {
                NSNumber *aNumber = [self.production popObject];
                [aCustomer consumeNumber:aNumber];
                NSLog(@"%@: %@", [NSThread currentThread].name, aCustomer);
                [self.lock unlock];
            } else {
                [self.lock unlock];
                [[NSThread currentThread] cancel];
            }
        }
    }
}

@end
