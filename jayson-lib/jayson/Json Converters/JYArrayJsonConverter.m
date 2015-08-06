//
//  JYArrayJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYArrayJsonConverter.h"
#import <objc/runtime.h>
#import "JYError.h"

@implementation JYArrayJsonConverter


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
    return [self deserialize:string withClass:[NSArray class] errors:errors];
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors {
    return [self deserializeArray:string withClass:nil errors:errors];
}

- (id)deserializeArray:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors {
    int i = 0;
    if (![self expectAndSkip:'[' inString:string cursor:&i errors:errors])
        return nil;
    // Iterate through characters.
    NSMutableArray *array = [NSMutableArray new];
    while (i < [string length]) {
        // TODO: parse strings with \n
        char c = [string characterAtIndex:i];
        // Skip ignored characters
        if ([self isWhitespace:c]) {
            i++;
            continue;
        }
        // Check if the dictionary ended.
        if (c == ']')
            return array;
        // Capture comma.
        if ([array count] > 0 && c == ',') {
            if ([string length] > i + 1 && [string characterAtIndex:i+1] == ',') {
                [JYError errors:errors raiseError:JYErrorInvalidFormat withFormat:@"Unexpected ',' at index '%i'.", i + 1];
                return nil;
            }
            i++;
            continue;
        }
        // Capture first value.
        NSString *value = [self captureValue:string cursor:&i errors:errors];
        if (value == nil)
            return nil;
        NSObject *obj = [self.jsonSerializer deserializeObject:value withClass:objectClass errors:errors];
        if (obj == nil)
            return nil;
        [array addObject:obj];
    }
    [JYError errors:errors raiseError:JYErrorInvalidFormat withFormat:@"Unexpected end of array."];
    return nil;
}

- (BOOL)expectAndSkip:(char)expected inString:(NSString *)string cursor:(int*)i errors:(NSArray **)errors {
    BOOL result = [self expect:expected inString:string cursor:i errors:errors];
    if (result)
        (*i)++;
    return result;
}

- (BOOL)expect:(char)expected inString:(NSString *)string cursor:(int*)i errors:(NSArray **)errors {
    char c = [string characterAtIndex:*i];
    if (c == expected)
        return true;
    [JYError errors:errors raiseError:JYErrorInvalidFormat withFormat:@"Expected ':' but found '%c' at index '%i'.", c, *i];
    return false;
}

- (BOOL)isWhitespace:(char)c {
    // These characters are whitespaces that we should ignore.
    char const ignoredChars[] = {' ', '\r', '\n', '\t'};
    for (int j=0; j<sizeof ignoredChars; j++)
        if (ignoredChars[j] == c)
            return true;
    return false;
}

- (NSString *)captureValue:(NSString *)string cursor:(int*)i errors:(NSArray **)errors {
    NSString *result = nil;
    // Match strings.
    if ([self matches:@"^(\"[^\"\\\\]*(?:\\.[^\"\\\\]*)*\")" result:&result string:string cursor:i errors:errors])
        return result;
    // Match numbers.
    if ([self matches:@"^(-?(0|[1-9]\\d*)(\\.\\d+)?([eE][+-]?\\d+)?)" result:&result string:string cursor:i errors:errors])
        return result;
    // Match objects.
    if ([self matchesBracesWithOpen:'{' close:'}' result:&result string:string cursor:i errors:errors])
        return result;
    // Match arrays.
    if ([self matchesBracesWithOpen:'[' close:']' result:&result string:string cursor:i errors:errors])
        return result;
    // Match booleans and null.
    if ([self matches:@"^(true|false|null)" result:&result string:string cursor:i errors:errors])
        return result;
    [JYError errors:errors raiseError:JYErrorInvalidFormat withFormat:@"Unexpected end of value."];
    return nil;
}

- (BOOL)matchesBracesWithOpen:(char)open close:(char)close result:(NSString **)result string:(NSString *)string cursor:(int*)i errors:(NSArray **)errors {
    if ([string characterAtIndex:*i] != open)
        return false;
    int start = *i;
    int opened = 0;
    BOOL escaped = NO;
    BOOL inString = NO;
    for (; *i<[string length]; (*i)++) {
        char c = [string characterAtIndex:*i];
        if (escaped)
            escaped = NO;
        if (c == open)
            opened++;
        else if (inString && !escaped && c == '\\')
            escaped = true;
        else if (c == '"' && !escaped)
            inString = !inString;
        else if (c == close) {
            opened--;
            if (opened < 0)
                return false;
            if (opened == 0) {
                (*i)++;
                *result = [string substringWithRange:NSMakeRange(start, *i - start)];
                return true;
            }
        }
    }
    return false;
}

- (BOOL)matches:(NSString *)regexStr result:(NSString **)result string:(NSString *)string cursor:(int*)i errors:(NSArray **)errors {
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(*i, [string length] - *i)];
    if ([matches count] > 0) {
        // Advance cursor and return number.
        NSTextCheckingResult *check = matches[0];
        (*i) += check.range.length;
        *result = [string substringWithRange:check.range];
        return true;
    }
    return false;
}

- (BOOL)canConvert:(Class)objectClass errors:(NSArray **)errors {
    return [objectClass isSubclassOfClass:[NSArray class]];
}

- (BOOL)canConvertJson:(NSString *)string errors:(NSArray **)errors {
    return [string hasPrefix:@"["] && [string hasSuffix:@"]"];
}

@end
