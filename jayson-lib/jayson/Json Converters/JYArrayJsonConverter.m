//
//  JYArrayJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYArrayJsonConverter.h"

@implementation JYArrayJsonConverter

// These characters are whitespaces that we should ignore.
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
    BOOL inString = NO; // True if the character is currently part of a string.
    int arrayCounter = 0; // Deals with nested arrays.
    int objCounter = 0; // Deals with nested objects.
    NSMutableArray *array = [NSMutableArray new];
    NSMutableString *builder = [NSMutableString new];    
    for (int i=1; i<[string length] - 1; i++)
    {
        char c = [string characterAtIndex:i];
        // If we find an unescaped " we reverse inString. We should not escape " if we are not in a string.
        if ((!inString || !escaped) && c == '\"')
            inString = !inString;
        // If we find [ or ] and we are not in a string, update array counter.
        if (!inString && (c == '[' || c == ']'))
            arrayCounter += c == '[' ? 1 : -1;
        // If we find { or } and we are not in a string, update array counter.
        if (!inString && (c == '{' || c == '}'))
            objCounter += c == '{' ? 1 : -1;
        // Reset escaped state.
        if (escaped)
            escaped = NO;
        // Escape characters with \ before them (eg: \" or \n)
        if (inString && c == '\\')
            escaped = YES;
        // If we are not in a string, we should escape whitespaces.
        if (!inString)
        {
            for (int j=0; j<sizeof IgnoredChars; j++)
                if (IgnoredChars[j] == c)
                    continue;
        }
        // If we are not in a string, an array or a dictionary and we find a comma we deserialize the string and add it to the array.
        if (!inString && arrayCounter == 0 && objCounter == 0 && c == ',')
        {
            [array addObject:[self.jsonSerializer deserializeObject:[NSString stringWithString:builder]]];
            builder = [NSMutableString new];
            // We should not add the comma to the next object.
            continue;
        }
        // We add the current character to the string.
        [builder appendFormat:@"%c", c];
    }
    // In the end we are left with a string and no comma. We should add the deserialized string to the array.
    [array addObject:[self.jsonSerializer deserializeObject:[NSString stringWithString:builder]]];
    // Return the completed array.
    return array;
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSArray class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string hasPrefix:@"["] && [string hasSuffix:@"]"];
}

@end
