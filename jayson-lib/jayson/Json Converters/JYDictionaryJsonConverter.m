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

- (id)serialize:(id)obj errors:(NSArray **)errors {
    return obj;
}

- (id)deserialize:(NSString *)string errors:(NSArray **)errors {
    return [self deserialize:string withClass:[NSDictionary class] errors:errors];
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors {
    if ([string isEqual:@"null"])
        return nil;
    // These characters are whitespaces that we should ignore.
    char const IgnoredChars[] = {' ', '\r', '\n', '\t'};
    if (![self canConvertJson:string errors:errors])
        [NSException raise:@"Json Converter Error" format:@"Value '%@' is invalid for dictionary", string];
    BOOL escaped = NO;
    BOOL isKey = YES; // True if we are currently parsing the key.
    BOOL inString = NO; // True if the character is currently part of a string.
    int arrayCounter = 0; // Deals with nested arrays.
    int objCounter = 0; // Deals with nested objects.
    NSString *key = [NSMutableString new];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableString *builder = [NSMutableString new];
    for (int i=1; i<[string length] - 1; i++)
    {
        // TODO: parse strings with \n
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
        // If we find : and we are not in a string, save the key.
        if (!inString && isKey && c == ':')
        {
            // We are not parsing the key anymore.
            isKey = NO;
            // Deserialize string key.
            key = [self.jsonSerializer deserializeObject:[NSString stringWithString:builder] withClass:[NSString class]];
            builder = [NSMutableString new];
            continue;
        }
        // Reset escaped state.
        if (escaped)
            escaped = NO;
        // Escape characters with \ before them (eg: \" or \n)
        if (inString && c == '\\')
            escaped = YES;
        // If we are not in a string, we should escape whitespaces.
        if (!inString)
        {
            BOOL ignored = NO;
            for (int j=0; j<sizeof IgnoredChars; j++)
                if (IgnoredChars[j] == c)
                    ignored = YES;
            if (ignored)
                continue;
        }
        // If we are not in a string, an array or a dictionary, not parsing the key and we find a comma we deserialize the string and add it as value.
        if (!inString && !isKey && arrayCounter == 0 && objCounter == 0 && c == ',')
        {
            NSString *value = [self.jsonSerializer deserializeObject:[NSString stringWithString:builder]];
            [dict setObject:value forKey:key];
            builder = [NSMutableString new];
            isKey = YES;
            // We should not add the comma to the next object.
            continue;
        }
        // We add the current character to the string.
        [builder appendFormat:@"%c", c];
    }
    // In the end we are left with a string and no comma. We should add the deserialized string to the array.
    if ([builder length] > 0)
    {
        NSString *value = [self.jsonSerializer deserializeObject:[NSString stringWithString:builder]];
        [dict setObject:value forKey:key];
    }
    // Return the completed array.
    return dict;
}

- (id)deserializeArray:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors {
    return nil;
}

- (BOOL)canConvert:(Class)objectClass errors:(NSArray **)errors {
    return [objectClass isSubclassOfClass:[NSDictionary class]];
}

- (BOOL)canConvertJson:(NSString *)string errors:(NSArray **)errors {
    return [string hasPrefix:@"{"] && [string hasSuffix:@"}"];
}

@end
