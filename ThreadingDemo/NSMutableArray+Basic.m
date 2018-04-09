//
//  NSMutableArray+Basic.m
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/9.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import "NSMutableArray+Basic.h"

@implementation NSMutableArray (Basic)

- (id)popObject {
    id object = self.lastObject;
    [self removeLastObject];
    return object;
}

@end
