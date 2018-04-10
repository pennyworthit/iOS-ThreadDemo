//
//  main.m
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/9.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessProtocol.h"
#import "BusinessSyncWithLock.h"
#import "BusinessSyncWithCondition.h"
#import "BusinessOperation.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
//        id<BusinessProtocol> business = [[BusinessSyncWithLock alloc] init];
//        id<BusinessProtocol> business = [[BusinessSyncWithCondition alloc] init];
        id<BusinessProtocol> business = [[BusinessOperation alloc] init];
        [business runBusiness];
        
        while (YES) {};
    }
    return 0;
}
