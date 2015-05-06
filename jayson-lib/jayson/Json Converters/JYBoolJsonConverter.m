//
//  JYBoolJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYBoolJsonConverter.h"

@implementation JYBoolJsonConverter

- (NSString *)toString:(id)obj {
    return obj == true ? @"true" : @"false";
}

- (id)fromString:(NSString *)string {
    if (string == @"true")
        return @(true);
    if (string == @"false")
        return false;
    [NSException raise:@"Json Converter Error" format:@"%s is not a valid value for a BOOL", string];
}

- (BOOL)canConvert:(Class *)objectClass {
    return objectClass == [BOOL class];
}

@end
