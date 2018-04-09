//
//  main.m
//  ThreadingDemo
//
//  Created by Christopher on 2018/4/9.
//  Copyright © 2018 wenyongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Business.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Business *business = [[Business alloc] init];
        [business runBusiness];
        
        while (YES) {};
    }
    return 0;
}
