//
//  DeserializerTests.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-15.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JYJayson.h"
#import "NSData+Base64.h"
#import "TestClass.h"
#import "RecursiveTestClass.h"

@interface DeserializerTests : XCTestCase

@end

@implementation DeserializerTests

- (void)testNull {
    XCTAssertEqualObjects([NSNull null], [JYJayson deserializeObject:@"null"]);
}

- (void)testString {
    XCTAssertEqualObjects(@"\"\"", [JYJayson serializeObject:@""]);
    XCTAssertEqualObjects(@"", [JYJayson deserializeObject:@"\"\"" withClass:[NSString class]]);
    XCTAssertThrows([JYJayson deserializeObject:@"\"" withClass:[NSString class]]);
    XCTAssertThrows([JYJayson deserializeObject:@"test" withClass:[NSString class]]);
    XCTAssertThrows([JYJayson deserializeObject:@"\"test" withClass:[NSString class]]);
}

- (void)testNumber {
    XCTAssertEqualObjects(@(12), [JYJayson deserializeObject:@"12" withClass:[NSNumber class]]);
}

- (void)testDate {
    XCTAssertEqualObjects([NSDate dateWithTimeIntervalSince1970:0], [JYJayson deserializeObject:@"\"1969-12-31T19:00:00-05:00\"" withClass:[NSDate class]]);
}

- (void)testArray {
    XCTAssertEqualObjects((@[@1,@2,@3,@4,@5]), [JYJayson deserializeObject:@"[1,2,3,4,5]" withClass:[NSArray class]]);
    XCTAssertEqualObjects((@[@[@1,@"2"],@"[2]",@[@3,@4],@4,@5]), [JYJayson deserializeObject:@"[[1,\"2\"],\"[2]\",[3,4],4,5]" withClass:[NSArray class]]);
}

- (void)testDictionary {
    XCTAssertEqualObjects((@{@"test":@1,@"test2":@"test"}), [JYJayson deserializeObject:@"{\"test2\":\"test\",\"test\":1}" withClass:[NSDictionary class]]);
    XCTAssertEqualObjects((@{@"test":@1,@"test2":@{@"test":@1,@"test2":@"test"}}),
                          [JYJayson deserializeObject:@"{\"test2\":{\"test2\":\"test\",\"test\":1},\"test\":1}" withClass:[NSDictionary class]]);
}

- (void)testData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]];
    NSString *encoded = [data base64EncodedString];
    NSString *dataJson = [NSString stringWithFormat:@"\"%@\"", encoded];
    XCTAssertEqualObjects(data, [JYJayson deserializeObject:dataJson withClass:[NSData class]]);
}

- (void)testObject {
    TestClass *testClass = [TestClass new];
    testClass.test = @1;
    NSString *testJson = @"{\"test\":1}";
    TestClass *deserialized = [JYJayson deserializeObject:testJson withClass:[TestClass class]];
    XCTAssertTrue([testClass.test isEqual:deserialized.test]);
    // Test if the objects can be parsed recursively.
    RecursiveTestClass *recursiveTestClass = [RecursiveTestClass new];
    recursiveTestClass.test = testClass;
    NSString *recursiveTestJson = @"{\"test\":{\"test\":1}}";
    RecursiveTestClass *recursiveDeserialized = [JYJayson deserializeObject:recursiveTestJson withClass:[RecursiveTestClass class]];
    XCTAssertTrue([recursiveTestClass.test.test isEqual:recursiveDeserialized.test.test]);
}

@end
