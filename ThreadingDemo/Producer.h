//
//  Producer.h
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/9.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Producer : NSObject

- (instancetype)initWithAmount:(NSInteger)amount;
@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *production;

@end
