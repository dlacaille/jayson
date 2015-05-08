//
//  JYStringJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYStringJsonConverter.h"

@implementation JYStringJsonConverter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (NSString *)toString:(id)obj {
    return [NSString stringWithFormat:@"\"%@\"", obj];
}

- (id)fromString:(NSString *)string {
    // "te\nst"
    // TODO: Parse escaped characters
    if (![self canConvertJson:string])
        [NSException raise:@"Json Converter Error" format:@"value %@ is invalid for string", string];
    return [string substringWithRange:NSMakeRange(1, [string length] - 2)];
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSString class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string length] > 1 && [string hasPrefix:@"\""] && [string hasSuffix:@"\""];
}

@end
