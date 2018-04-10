//
//  BusinessOperation.m
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/10.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import "BusinessOperation.h"

static NSString *kQueueOperationsChanged = @"kQueueOperationsChanged";

@interface BusinessOperation()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *production;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation BusinessOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.production = [[Producer alloc] initWithAmount:100].production;
        self.lock = [[NSLock alloc] init];
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:2];
        [self.operationQueue addObserver:self forKeyPath:@"operations" options:0 context:&kQueueOperationsChanged];
    }
    
    return self;
}

- (void)dealloc {
    [self.operationQueue removeObserver:self forKeyPath:@"operations"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != &kQueueOperationsChanged || object != self.operationQueue || [keyPath isEqualToString:@"operations"] != YES) return;
    
    NSLog(@"%@", change);
    if (self.operationQueue.operations.count <= 0) {
        NSLog(@"operations complete!!!");
        return;
    }
}

- (void)runBusiness {
    Customer *customerA1 = [[Customer alloc] initWithName:@"CustomerA1"];
    Customer *customerA2 = [[Customer alloc] initWithName:@"CustomerA2"];
    Customer *customerA3 = [[Customer alloc] initWithName:@"CustomerA3"];
    
    Customer *customerB = [[Customer alloc] initWithName:@"CustomerB"];
    Customer *customerC = [[Customer alloc] initWithName:@"CustomerC"];
    
    NSInvocationOperation *operationA1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:customerA1];
    NSInvocationOperation *operationA2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:customerA2];
    NSInvocationOperation *operationA3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:customerA3];

    NSInvocationOperation *operationB = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:customerB];
    NSInvocationOperation *operationC = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:customerC];
    
    operationA1.queuePriority = NSOperationQueuePriorityNormal;
    operationA2.queuePriority = NSOperationQueuePriorityHigh;
    operationA3.queuePriority = NSOperationQueuePriorityVeryHigh;
    
    operationB.queuePriority = NSOperationQueuePriorityLow;
    operationC.queuePriority = NSOperationQueuePriorityLow;
    
    [operationB addDependency:operationA2];
    [operationC addDependency:operationA2];

    NSArray<NSOperation *> *operations = @[operationA1, operationA2, operationA3, operationB, operationC];
    [self.operationQueue addOperations:operations waitUntilFinished:NO];
}

- (void)run:(Customer *)aCustomer {
    while (YES) {
        if ([self.lock tryLock]) {
            if (self.production.count > 0) {
                if (([aCustomer.name isEqualToString:@"CustomerA1"] && aCustomer.consumed.count >= 6) ||
                    ([aCustomer.name isEqualToString:@"CustomerA2"] && aCustomer.consumed.count >= 8) ||
                    ([aCustomer.name isEqualToString:@"CustomerA3"] && aCustomer.consumed.count >= 10)) {
                    NSLog(@"%@ consumed %@", aCustomer.name, aCustomer.consumed);
                    [self.lock unlock];
                    break;
                } else {
                    NSNumber *aNumber = [self.production popObject];
                    [aCustomer consumeNumber:aNumber];
                    [self.lock unlock];
                }
            } else {
                [self.lock unlock];
                NSLog(@"%@ consumed %@", aCustomer.name, aCustomer.consumed);
                break;
            }
        }
    }
}

@end
