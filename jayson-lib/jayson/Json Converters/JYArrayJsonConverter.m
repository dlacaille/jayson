//
//  JYArrayJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYArrayJsonConverter.h"

@implementation JYArrayJsonConverter

char const IgnoredChars[] = {' ', '\r', '\n', '\t'};

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (NSString *)toString:(id)obj {
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"["];
    for (int i = 0; i < [(NSArray *)obj count]; i++)
    {
        if (i > 0)
            [result appendString:@","];
        id item = [(NSArray *)obj objectAtIndex:i];
        [result appendString:[self.jsonSerializer serializeObject:item]];
    }
    [result appendString:@"]"];
    return result;
}

- (id)fromString:(NSString *)string {
    if (![self canConvertJson:string])
        [NSException raise:@"Json Converter Error" format:@"value %@ is invalid for array", string];
    BOOL escaped = NO;
    BOOL inString = NO;
    NSMutableArray *array = [NSMutableArray new];
    NSMutableString *builder = [NSMutableString new];    
    for (int i=1; i<[string length] - 1; i++)
    {
        char c = [string characterAtIndex:i];
        if (!escaped && c == '\"')
        {
            inString = !inString;
        }
        if (escaped)
            escaped = NO;
        if (inString && c == '\\')
            escaped = YES;
        if (!inString)
        {
            // Skip ignored chars.
            for (int j=0; j<sizeof IgnoredChars; j++)
                if (IgnoredChars[j] == c)
                    continue;
        }
        if (!inString && c == ',')
        {
            [array addObject:[self.jsonSerializer deserializeObject:[NSString stringWithString:builder]]];
            builder = [NSMutableString new];
            continue;
        }
        [builder appendFormat:@"%c", c];
    }
    [array addObject:[self.jsonSerializer deserializeObject:[NSString stringWithString:builder]]];
    return array;
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSArray class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string hasPrefix:@"["] && [string hasSuffix:@"]"];
}

@end
