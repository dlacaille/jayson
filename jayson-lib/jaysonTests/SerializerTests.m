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
#import "TestClass.h"
#import "RecursiveTestClass.h"

@interface PrimitivesTests : XCTestCase

@end

@implementation PrimitivesTests

- (void)testNull {
    XCTAssertEqualObjects(@"null", [JYJayson serializeObject:[NSNull null]]);
}

- (void)testString {
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
    XCTAssertEqualObjects(@"test", [JYJayson deserializeObject:@"\"test\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(@"\r\n", [JYJayson deserializeObject:@"\"\\r\\n\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(@"\r\n\f\b\t\u5404", [JYJayson deserializeObject:@"\"\\r\\n\\f\\b\\t\\u5404\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(@"\"\"", [JYJayson serializeObject:@""]);
}

- (void)testNumber {
    XCTAssertEqualObjects(@"12.12", [JYJayson serializeObject:[NSNumber numberWithDouble:12.12]]);
    XCTAssertEqualObjects(@"0.45", [JYJayson serializeObject:[NSNumber numberWithFloat:0.45f]]);
    XCTAssertEqualObjects(@"1", [JYJayson serializeObject:[NSNumber numberWithBool:true]]);
    XCTAssertEqualObjects(@"12", [JYJayson serializeObject:[NSNumber numberWithInt:12]]);
    XCTAssertEqualObjects(@"0", [JYJayson serializeObject:[NSNumber numberWithInt:0x0]]);
    XCTAssertEqualObjects(@"500", [JYJayson serializeObject:[NSNumber numberWithLong:500]]);
    XCTAssertEqualObjects(@"1", [JYJayson serializeObject:@(1)]);
}
    
- (void)testDate {
    XCTAssertEqualObjects(@"\"1969-12-31T19:00:00-05:00\"", [JYJayson serializeObject:[NSDate dateWithTimeIntervalSince1970:0]]);
}

- (void)testArray {
    XCTAssertEqualObjects(@"[1,2,3,4,5]", [JYJayson serializeObject:(@[@1,@2,@3,@4,@5])]);
    XCTAssertEqualObjects(@"[\"test\",\"test2\",\"test3\"]", [JYJayson serializeObject:(@[@"test",@"test2",@"test3"])]);
}

- (void)testDictionary {
    XCTAssertEqualObjects(@"{\"test2\":\"test\",\"test\":1}", [JYJayson serializeObject:(@{@"test":@1,@"test2":@"test"})]);
    XCTAssertEqualObjects(@"{\"test2\":\"1969-12-31T19:00:00-05:00\",\"test\":1}", [JYJayson serializeObject:(@{@"test":@1,@"test2":[NSDate dateWithTimeIntervalSince1970:0]})]);
}

- (void)testData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]];
    NSString *encoded = [data base64EncodedString];
    NSString *dataJson = [NSString stringWithFormat:@"\"%@\"", encoded];
    XCTAssertEqualObjects(dataJson, [JYJayson serializeObject:data]);
}

- (void)testObject {
    TestClass *testClass = [TestClass new];
    testClass.test = @1;
    NSString *testJson = @"{\"test\":1}";
    XCTAssertEqualObjects(testJson, [JYJayson serializeObject:testClass]);
    // Test if the objects can be parsed recursively.
    RecursiveTestClass *recursiveTestClass = [RecursiveTestClass new];
    recursiveTestClass.test = testClass;
    NSString *recursiveTestJson = @"{\"test\":{\"test\":1}}";
    XCTAssertEqualObjects(recursiveTestJson, [JYJayson serializeObject:recursiveTestClass]);
}

- (void)testIndented {
    JYJsonSerializer *serializer = [JYJsonSerializer new];
    serializer.jsonFormatter.indented = YES;
    XCTAssertEqualObjects(@"{\n\t\"test2\":\"test\",\n\t\"test\":1\n}", [serializer serializeObject:(@{@"test":@1,@"test2":@"test"})]);
}

@end
