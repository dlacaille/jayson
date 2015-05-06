//
//  JYDoubleJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYDoubleJsonConverter.h"

@implementation JYDoubleJsonConverter

- (NSString *)toString:(id)obj {
    return [(double)obj stringValue];
}

- (id)fromString:(NSString *)string {
    @try {
        return [string doubleValue];
    }
    @catch (NSException *exception) {
        [NSException raise:@"Json Converter Error" format:@"%s is not a valid value for a double", string];
    }
}

- (BOOL)canConvert:(Class *)objectClass {
    return objectClass == [double class];
}

@end
