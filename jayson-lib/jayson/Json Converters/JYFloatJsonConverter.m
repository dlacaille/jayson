//
//  JYFloatJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYFloatJsonConverter.h"

@implementation JYFloatJsonConverter

- (NSString *)toString:(id)obj {
    return [(float)obj stringValue];
}

- (id)fromString:(NSString *)string {
    @try {
        return [string floatValue];
    }
    @catch (NSException *exception) {
        [NSException raise:@"Json Converter Error" format:@"%s is not a valid value for a float", string];
    }
}

- (BOOL)canConvert:(Class *)objectClass {
    return objectClass == [float class];
}

@end
