//
//  JYIntJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYIntJsonConverter.h"

@implementation JYIntJsonConverter

- (NSString *)toString:(id)obj {
    return [(int)obj stringValue];
}

- (id)fromString:(NSString *)string {
    @try {
        return [string intValue];
    }
    @catch (NSException *exception) {
        [NSException raise:@"Json Converter Error" format:@"%s is not a valid value for a BOOL", string];
    }
}

- (BOOL)canConvert:(Class *)objectClass {
    return objectClass == [int class];
}

@end
