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
#import "ComplexTypeTestClass.h"
#import "RecursiveTestClass.h"
#import "TypedArrayTestClass.h"
#import "IgnoreTestClass.h"
#import "TestSubObjectClass.h"
#import "JYError.h"
#import "PropertyMapTestClass.h"

@interface DeserializerTests : XCTestCase

@end

@implementation DeserializerTests

- (void)testNull {
    XCTAssertEqualObjects([NSNull null], [JYJayson deserializeObject:@"null"]);
}

- (void)testString {
    XCTAssertEqualObjects(@"", [JYJayson deserializeObject:@"\"\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(@"test", [JYJayson deserializeObject:@"\"test\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(@"\r\n", [JYJayson deserializeObject:@"\"\\r\\n\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(@"\r\n\f\b\t\u5404", [JYJayson deserializeObject:@"\"\\r\\n\\f\\b\\t\\u5404\"" withClass:[NSString class]]);
    XCTAssertEqualObjects(nil, [JYJayson deserializeObject:@"null" withClass:[NSString class]]);
    // Test errors
    NSArray *errors = nil;
    [JYJayson deserializeObject:@"\"" withClass:[NSString class] errors:&errors];
    XCTAssertEqual(errors.count, 1);
    errors = nil;
    [JYJayson deserializeObject:@"" withClass:[NSString class] errors:&errors];
    XCTAssertEqual(errors.count, 1);
    errors = nil;
    [JYJayson deserializeObject:@"test" withClass:[NSString class] errors:&errors];
    XCTAssertEqual(errors.count, 1);
}

- (void)testNumber {
    XCTAssertEqualObjects(@(12), [JYJayson deserializeObject:@"12" withClass:[NSNumber class]]);
    XCTAssertEqualObjects(nil, [JYJayson deserializeObject:@"null" withClass:[NSNumber class]]);
}

- (void)testDate {
    XCTAssertEqualObjects([NSDate dateWithTimeIntervalSince1970:0], [JYJayson deserializeObject:@"\"1969-12-31T19:00:00-05:00\"" withClass:[NSDate class]]);
    XCTAssertEqualObjects(nil, [JYJayson deserializeObject:@"null" withClass:[NSDate class]]);
}

- (void)testArray {
    XCTAssertEqualObjects((@[@1,@2,@3,@4,@5]), [JYJayson deserializeObject:@"[1,2,3,4,5]" withClass:[NSArray class]]);
    XCTAssertEqualObjects((@[@[@1,@"2"],@"[2]",@[@3,@4],@4,@5]), [JYJayson deserializeObject:@"[[1,\"2\"],\"[2]\",[3,4],4,5]" withClass:[NSArray class]]);
    XCTAssertEqualObjects(nil, [JYJayson deserializeObject:@"null" withClass:[NSArray class]]);
}

- (void)testDictionary {
    XCTAssertEqualObjects((@{@"test":@1,@"test2":@"test"}), [JYJayson deserializeObject:@"{\"test2\":\"test\",\"test\":1}" withClass:[NSDictionary class]]);
    NSDictionary *recursive = [JYJayson deserializeObject:@"{\"test2\":{\"test2\":\"test\",\"test\":1},\"test\":1}" withClass:[NSDictionary class]];
    XCTAssertEqualObjects((@{@"test":@1,@"test2":@{@"test":@1,@"test2":@"test"}}), recursive);
    XCTAssertEqualObjects(nil, [JYJayson deserializeObject:@"null" withClass:[NSDictionary class]]);
    XCTAssertEqualObjects([NSDictionary new], [JYJayson deserializeObject:@"{}" withClass:[NSDictionary class]]);
    // Test errors.
    NSArray *errors = nil;
    [JYJayson deserializeObject:@"{\"test2\"a\"test\"}" withClass:[NSDictionary class] errors:&errors];
    XCTAssertEqual(errors.count, 1);
}

- (void)testData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]];
    NSString *encoded = [data base64EncodedString];
    NSString *dataJson = [NSString stringWithFormat:@"\"%@\"", encoded];
    XCTAssertEqualObjects(data, [JYJayson deserializeObject:dataJson withClass:[NSData class]]);
    XCTAssertEqualObjects(nil, [JYJayson deserializeObject:@"null" withClass:[NSData class]]);
}

- (void)testToDictionary {
    ComplexTypeTestClass *testClass = [ComplexTypeTestClass new];
    testClass.test = @1;
    NSString *testJson = @"{\"test\":1}";
    NSDictionary *dictionary =  [JYJayson toDictionary:testJson];
    XCTAssertEqualObjects(@(1), [dictionary objectForKey:@"test"]);
}

- (void)testObject {
    ComplexTypeTestClass *testClass = [ComplexTypeTestClass new];
    testClass.test = @1;
    NSString *testJson = @"{\"test\":1}";
    ComplexTypeTestClass *deserialized = [JYJayson deserializeObject:testJson withClass:[ComplexTypeTestClass class]];
    XCTAssertTrue([testClass.test isEqual:deserialized.test]);
    // Test if the objects can be parsed recursively.
    RecursiveTestClass *recursiveTestClass = [RecursiveTestClass new];
    recursiveTestClass.test = testClass;
    NSString *recursiveTestJson = @"{\"test\":{\"test\":1}}";
    RecursiveTestClass *recursiveDeserialized = [JYJayson deserializeObject:recursiveTestJson withClass:[RecursiveTestClass class]];
    XCTAssertTrue([recursiveTestClass.test.test isEqual:recursiveDeserialized.test.test]);
    XCTAssertEqualObjects(nil, [JYJayson deserializeObject:@"null" withClass:[RecursiveTestClass class]]);
}

- (void)testTypedArray {
    ComplexTypeTestClass *testClass = [ComplexTypeTestClass new];
    testClass.test = @1;
    TypedArrayTestClass *typedArrayTestClass = [TypedArrayTestClass new];
    typedArrayTestClass.testArray = (NSArray<ComplexTypeTestClass> *)@[testClass];
    TypedArrayTestClass *deserialized = [JYJayson deserializeObject:@"{\"testArray\":[{\"test\":1}]}" withClass:[TypedArrayTestClass class]];
    XCTAssertEqualObjects([[typedArrayTestClass.testArray objectAtIndex:0] test], [[deserialized.testArray objectAtIndex:0] test]);
    TypedArrayTestClass *deserializedNull = [JYJayson deserializeObject:@"{\"testArray\":null}" withClass:[TypedArrayTestClass class]];
    XCTAssertEqualObjects(nil, deserializedNull.testArray);
}

- (void)testObjectArray {
    NSArray *deserialized = [JYJayson deserializeObjectArray:@"[{\"test\":1},{\"test\":2}]" withClass:[ComplexTypeTestClass class]];
    XCTAssertEqualObjects(@1, [[deserialized objectAtIndex:0] test]);
    XCTAssertEqualObjects(@2, [[deserialized objectAtIndex:1] test]);
    XCTAssertEqualObjects([NSArray new], [JYJayson deserializeObjectArray:@"[]" withClass:[ComplexTypeTestClass class]]);
    XCTAssertEqualObjects([NSArray new], [JYJayson deserializeObjectArray:@"[ ]" withClass:[ComplexTypeTestClass class]]);
}

- (void)testSubObject {
    TestSubObjectClass *deserialized = [JYJayson deserializeObject:@"{\"test\":{\"test\":1}}" withClass:[TestSubObjectClass class]];
    XCTAssertEqualObjects(@1, deserialized.test.test);
    
    ComplexTypeTestClass *testClass1 = [ComplexTypeTestClass new];
    testClass1.test = @1;
    
    ComplexTypeTestClass *testClass2 = [ComplexTypeTestClass new];
    testClass2.test = @2;
    
    TestSubObjectClass *arrayDeserialized = [JYJayson deserializeObject:@"{\"testArray\":[{\"test\":1},{\"test\":2}] }" withClass:[TestSubObjectClass class]];
    XCTAssertEqualObjects(@2, @(arrayDeserialized.testArray.count));
    
    
    TestSubObjectClass *nilDeserialized = [JYJayson deserializeObject:@"{\"test\":null }" withClass:[TestSubObjectClass class]];
    XCTAssertEqualObjects(nil, nilDeserialized.test);
}

- (void)testIgnore {
    IgnoreTestClass *testClass = [JYJayson deserializeObject:@"{\"test\":1}" withClass:[IgnoreTestClass class]];
    XCTAssertEqualObjects([testClass test], nil);
}

- (void)testPropertyMap {
    PropertyMapTestClass *testClass = [PropertyMapTestClass new];
    testClass.numId = @1;
    PropertyMapTestClass *deserialized = [JYJayson deserializeObject:@"{\"id\":1}" withClass:[PropertyMapTestClass class]];
    XCTAssertEqualObjects(testClass.numId, deserialized.numId);
}

- (void)testErrors {
    NSArray *errors = nil;
    [JYJayson deserializeObject:@"{\"test\"1}" withClass:[NSDictionary class] errors:&errors];
    XCTAssertTrue([errors count] > 0);
    errors = nil;
    [JYJayson deserializeObject:@"{\"test\"}" withClass:[NSDictionary class] errors:&errors];
    XCTAssertTrue([errors count] > 0);
    errors = nil;
    [JYJayson deserializeObject:@"{:1}" withClass:[NSDictionary class] errors:&errors];
    XCTAssertTrue([errors count] > 0);
    errors = nil;
    [JYJayson deserializeObject:@"{\"test\":1,}" withClass:[NSDictionary class] errors:&errors];
    XCTAssertTrue([errors count] > 0);
    errors = nil;
    [JYJayson deserializeObject:@"{,\"test\":1}" withClass:[NSDictionary class] errors:&errors];
    XCTAssertTrue([errors count] > 0);
}

@end
