//
//  PrimitivesTests.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JYJayson.h"

@interface PrimitivesTests : XCTestCase

@end

@implementation PrimitivesTests


- (void)testExample {
    XCTAssertEqualObjects(@"test", [JYJayson serializeObject:@"test"]);
    
    
    /* TEST NUMBER */
    XCTAssertEqualObjects(@"12.12", [JYJayson serializeObject:[NSNumber numberWithDouble:12.12]]);
    XCTAssertEqualObjects(@"0.45", [JYJayson serializeObject:[NSNumber numberWithFloat:0.45f]]);
    XCTAssertEqualObjects(@"1", [JYJayson serializeObject:[NSNumber numberWithBool:true]]);
    XCTAssertEqualObjects(@"12", [JYJayson serializeObject:[NSNumber numberWithInt:12]]);
    XCTAssertEqualObjects(@"1", [JYJayson serializeObject:@(1)]);
}

@end
