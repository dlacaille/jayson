//
//  JYNullJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYNullJsonConverter.h"

@implementation JYNullJsonConverter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (NSString *)toString:(id)obj {
    return @"null";
}

- (id)fromString:(NSString *)string {
    if (![self canConvertJson:string])
        [NSException raise:@"Json Converter Error" format:@"value %@ is invalid for null", string];
    return [NSNull null];
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSNull class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string isEqual: @"null"];
}

@end
