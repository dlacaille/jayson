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
#import "NSData+Base64.h"

@interface PrimitivesTests : XCTestCase

@end

@implementation PrimitivesTests

- (void)testExample {
    /* NSNULL */
    XCTAssertEqualObjects(@"null", [JYJayson serializeObject:[NSNull null]]);
    XCTAssertEqualObjects([NSNull null], [JYJayson deserializeObject:@"null"]);
    
    /* NSSTRING */
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
    XCTAssertEqualObjects(@"test", [JYJayson deserializeObject:@"\"test\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(@"te\r\nst", [JYJayson deserializeObject:@"\"te\\r\\nst\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(@"\"\"", [JYJayson serializeObject:@""]);
    XCTAssertEqualObjects(@"", [JYJayson deserializeObject:@"\"\"" withClass:[NSString class]]);
    XCTAssertThrows([JYJayson deserializeObject:@"\"" withClass:[NSString class]]);
    XCTAssertThrows([JYJayson deserializeObject:@"test" withClass:[NSString class]]);
    XCTAssertThrows([JYJayson deserializeObject:@"\"test" withClass:[NSString class]]);
    
    /* NSNUMBER */
    XCTAssertEqualObjects(@"12.12", [JYJayson serializeObject:[NSNumber numberWithDouble:12.12]]);
    XCTAssertEqualObjects(@"0.45", [JYJayson serializeObject:[NSNumber numberWithFloat:0.45f]]);
    XCTAssertEqualObjects(@"1", [JYJayson serializeObject:[NSNumber numberWithBool:true]]);
    XCTAssertEqualObjects(@"12", [JYJayson serializeObject:[NSNumber numberWithInt:12]]);
    XCTAssertEqualObjects(@"0", [JYJayson serializeObject:[NSNumber numberWithInt:0x0]]);
    XCTAssertEqualObjects(@"500", [JYJayson serializeObject:[NSNumber numberWithLong:500]]);
    XCTAssertEqualObjects(@"1", [JYJayson serializeObject:@(1)]);
    XCTAssertEqualObjects(@(12), [JYJayson deserializeObject:@"12" withClass:[NSNumber class]]);    
    
    /* NSARRAY */
    XCTAssertEqualObjects(@"[1,2,3,4,5]", [JYJayson serializeObject:(@[@1,@2,@3,@4,@5])]);
    XCTAssertEqualObjects(@"[\"test\",\"test2\",\"test3\"]", [JYJayson serializeObject:(@[@"test",@"test2",@"test3"])]);
    XCTAssertEqualObjects((@[@"test",@"test2",@"test3"]), [JYJayson deserializeObject:@"[\"test\",\"test2\",\"test3\"]" withClass:[NSArray class]]);
    XCTAssertEqualObjects((@[@1,@2,@3,@4,@5]), [JYJayson deserializeObject:@"[1,2,3,4,5]" withClass:[NSArray class]]);
    XCTAssertEqualObjects((@[@[@1,@"2"],@"[2]",@[@3,@4],@4,@5]), [JYJayson deserializeObject:@"[[1,\"2\"],\"[2]\",[3,4],4,5]" withClass:[NSArray class]]);
    
    /* NSDICTIONARY */
    XCTAssertEqualObjects(@"[\"test2\":\"test\",\"test\":1]", [JYJayson serializeObject:(@{@"test":@1,@"test2":@"test"})]);
    
    /* NSDATA */
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]];
    NSString *encoded = [data base64EncodedString];
    XCTAssertEqualObjects(encoded, [JYJayson serializeObject:data]);
    XCTAssertEqualObjects(data, [JYJayson deserializeObject:encoded withClass:[NSData class]]);
    
}

@end
