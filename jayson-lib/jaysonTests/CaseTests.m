//
//  CaseTests.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-06-02.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JYCamelCaseConverter.h"
#import "JYPascalCaseConverter.h"
#import "JYSnakeCaseConverter.h"
#import "JYDashCaseConverter.h"
#import "JYAllCapsCaseConverter.h"

@interface CaseTests : XCTestCase

@end

@implementation CaseTests

- (void)testCamelCase {
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"PropertyName"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"propertyName"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"property_name"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"Property_Name"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"PROPERTY_NAME"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"property-name"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"Property-Name"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"PROPERTY-NAME"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"propertyNAME"], @"propertyName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"property50NAME"], @"property50Name");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"property50Name"], @"property50Name");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"property50name"], @"property50name");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"propertyTestName"], @"propertyTestName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"PropertyTestName"], @"propertyTestName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"PROPERTY_TEST_NAME"], @"propertyTestName");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"102"], @"102");
    XCTAssertEqualObjects([[JYCamelCaseConverter new] convert:@"102PropertyName"], @"102PropertyName");
}

- (void)testPascalCase {
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"PropertyName"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"propertyName"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"property_name"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"Property_Name"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"PROPERTY_NAME"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"property-name"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"Property-Name"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"PROPERTY-NAME"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"propertyNAME"], @"PropertyName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"property50NAME"], @"Property50Name");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"property50Name"], @"Property50Name");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"property50name"], @"Property50name");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"propertyTestName"], @"PropertyTestName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"PropertyTestName"], @"PropertyTestName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"PROPERTY_TEST_NAME"], @"PropertyTestName");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"102"], @"102");
    XCTAssertEqualObjects([[JYPascalCaseConverter new] convert:@"102PropertyName"], @"102PropertyName");
}

- (void)testSnakeCase {
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"PropertyName"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"propertyName"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"property_name"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"Property_Name"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"PROPERTY_NAME"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"property-name"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"Property-Name"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"PROPERTY-NAME"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"propertyNAME"], @"property_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"property50NAME"], @"property50_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"property50Name"], @"property50_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"property50name"], @"property50name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"propertyTestName"], @"property_test_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"PropertyTestName"], @"property_test_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"PROPERTY_TEST_NAME"], @"property_test_name");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"102"], @"102");
    XCTAssertEqualObjects([[JYSnakeCaseConverter new] convert:@"102PropertyName"], @"102_property_name");
}

- (void)testDashCase {
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"PropertyName"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"propertyName"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"property_name"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"Property_Name"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"PROPERTY_NAME"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"property-name"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"Property-Name"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"PROPERTY-NAME"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"propertyNAME"], @"property-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"property50NAME"], @"property50-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"property50Name"], @"property50-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"property50name"], @"property50name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"propertyTestName"], @"property-test-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"PropertyTestName"], @"property-test-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"PROPERTY_TEST_NAME"], @"property-test-name");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"102"], @"102");
    XCTAssertEqualObjects([[JYDashCaseConverter new] convert:@"102PropertyName"], @"102-property-name");
}

- (void)testAllCapsCase {
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"PropertyName"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"propertyName"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"property_name"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"Property_Name"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"PROPERTY_NAME"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"property-name"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"Property-Name"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"PROPERTY-NAME"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"propertyNAME"], @"PROPERTY_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"property50NAME"], @"PROPERTY50_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"property50Name"], @"PROPERTY50_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"property50name"], @"PROPERTY50NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"propertyTestName"], @"PROPERTY_TEST_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"PropertyTestName"], @"PROPERTY_TEST_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"PROPERTY_TEST_NAME"], @"PROPERTY_TEST_NAME");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"102"], @"102");
    XCTAssertEqualObjects([[JYAllCapsCaseConverter new] convert:@"102PropertyName"], @"102_PROPERTY_NAME");
}

@end
