//
//  JYDictionaryJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYDictionaryJsonConverter.h"

@implementation JYDictionaryJsonConverter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (NSString *)toString:(id)obj {
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"["];
    for (int i = 0; i < [(NSDictionary *)obj count]; i++)
    {
        if (i > 0)
            [result appendString:@","];
        id key = [[(NSDictionary *)obj allKeys] objectAtIndex:i];
        id value = [[(NSDictionary *)obj allValues] objectAtIndex:i];
        [result appendString:[self.jsonSerializer serializeObject:key]];
        [result appendString:@":"];
        [result appendString:[self.jsonSerializer serializeObject:value]];
    }
    [result appendString:@"]"];
    return result;
}

- (id)fromString:(NSString *)string {
    return nil;
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSDictionary class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string hasPrefix:@"{"] && [string hasSuffix:@"}"];
}

@end
