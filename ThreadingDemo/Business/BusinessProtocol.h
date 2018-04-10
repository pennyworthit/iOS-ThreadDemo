//
//  BusinessProtocol.h
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/10.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSMutableArray+Basic.h"
#import "Producer.h"
#import "Customer.h"

@protocol BusinessProtocol <NSObject>

- (void)runBusiness;

@end
