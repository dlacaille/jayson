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
    XCTAssertEqual(@"test", [JYJayson serializeObject:@"test"]);
}

@end
