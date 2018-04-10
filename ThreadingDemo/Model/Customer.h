//
//  Customer.h
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/9.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *consumed;
@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithName:(NSString *)name;

- (void)consumeNumber:(NSNumber *)aNumber;
- (void)consumeInteger:(NSInteger)anInt;

@end
