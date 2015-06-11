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
#import "ComplexTypeTestClass.h"
#import "RecursiveTestClass.h"
#import "IgnoreTestClass.h"
#import "CircularRefTestClass.h"

@interface SerializerTests : XCTestCase

@end

@implementation SerializerTests

- (void)testNull {
    XCTAssertEqualObjects(@"null", [JYJayson serializeObject:[NSNull null]]);
    XCTAssertEqualObjects(@"null", [JYJayson serializeObject:nil]);
}

- (void)testString {
    XCTAssertEqualObjects(@"\"\"", [JYJayson serializeObject:@""]);
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
    XCTAssertEqualObjects(@"\"test\"", [JYJayson serializeObject:@"test"]);
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
    XCTAssertEqualObjects(@"[\n\t1,\n\t2,\n\t3,\n\t4,\n\t5\n]", [JYJayson serializeObject:(@[@1,@2,@3,@4,@5])]);
    XCTAssertEqualObjects(@"[\n\t\"test\",\n\t\"test2\",\n\t\"test3\"\n]", [JYJayson serializeObject:(@[@"test",@"test2",@"test3"])]);
}

- (void)testDictionary {
    XCTAssertEqualObjects(@"{\n\t\"test2\":\"test\",\n\t\"test\":1\n}", [JYJayson serializeObject:(@{@"test":@1,@"test2":@"test"})]);
    XCTAssertEqualObjects(@"{\n\t\"test2\":\"1969-12-31T19:00:00-05:00\",\n\t\"test\":1\n}", [JYJayson serializeObject:(@{@"test":@1,@"test2":[NSDate dateWithTimeIntervalSince1970:0]})]);
}

- (void)testData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]];
    NSString *encoded = [data base64EncodedString];
    NSString *dataJson = [NSString stringWithFormat:@"\"%@\"", encoded];
    XCTAssertEqualObjects(dataJson, [JYJayson serializeObject:data]);
}

- (void)testObject {
    ComplexTypeTestClass *testClass = [ComplexTypeTestClass new];
    testClass.test = @1;
    NSString *testJson = @"{\n\t\"test\":1\n}";
    XCTAssertEqualObjects(testJson, [JYJayson serializeObject:testClass]);
}

- (void)testRecursiveObject {
    ComplexTypeTestClass *testClass = [ComplexTypeTestClass new];
    testClass.test = @1;
    RecursiveTestClass *recursiveTestClass = [RecursiveTestClass new];
    recursiveTestClass.test = testClass;
    NSString *recursiveTestJson = @"{\n\t\"test\":\n\t{\n\t\t\"test\":1\n\t}\n}";
    XCTAssertEqualObjects(recursiveTestJson, [JYJayson serializeObject:recursiveTestClass]);
}

- (void)testIndented {
    JYJsonSerializer *serializer = [JYJsonSerializer new];
    serializer.jsonFormatter.indented = YES;
    XCTAssertEqualObjects(@"{\n\t\"test2\":\"test\",\n\t\"test\":1\n}", [serializer serializeObject:(@{@"test":@1,@"test2":@"test"})]);
}

- (void)testIgnore {
    IgnoreTestClass *testClass = [IgnoreTestClass new];
    testClass.test = @1;
    XCTAssertEqualObjects([JYJayson serializeObject:testClass], @"{\n}");
}

- (void)testCircularRef {
    CircularRefTestClass *testClass = [CircularRefTestClass new];
    testClass.test = @"test";
    testClass.ref = testClass;
    XCTAssertEqualObjects([JYJayson serializeObject:testClass], @"{\n\t\"test\":\"test\",\n\t\"ref\":null\n}");
}

@end
