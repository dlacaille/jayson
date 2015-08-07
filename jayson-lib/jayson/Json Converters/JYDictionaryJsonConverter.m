//
//  JYDictionaryJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYDictionaryJsonConverter.h"
#import "JYKeyValuePair.h"
#import "JYError.h"

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
    // Verify that we can convert the json string.
    if (![self canConvertJson:string errors:errors]) {
        [JYError errors:errors raiseError:JYErrorInvalidFormat withFormat:@"String '%@' is not valid for NSDictionary.", string];
        return nil;
    }
    // Return the completed array.
    int i = 0;
    return [self captureDictionary:string cursor:&i errors:errors];
}

- (BOOL)isWhitespace:(char)c {
    // These characters are whitespaces that we should ignore.
    char const ignoredChars[] = {' ', '\r', '\n', '\t'};
    for (int j=0; j<sizeof ignoredChars; j++)
        if (ignoredChars[j] == c)
            return true;
    return false;
}

- (BOOL)isDigit:(char)c {
    return c >= '0' && c <= '9';
}

- (NSDictionary *)captureDictionary:(NSString *)string cursor:(int*)i errors:(NSArray **)errors {
    if (![self expectAndSkip:'{' inString:string cursor:i errors:errors])
        return nil;
    // Iterate through characters.
    NSMutableDictionary *dict = [NSMutableDictionary new];
    while (*i < [string length]) {
        [self skipWhitespaces:string cursor:i];
        // Check if the dictionary ended.
        if ([string characterAtIndex:*i] == '}') {
            (*i)++;
            return dict;
        }
        // Dictionary must start with a quote.
        if ([dict count] == 0)
            if(![self expect:'"' inString:string cursor:i errors:errors])
                return nil;
        // Capture commas.
        if ([dict count] > 0)
            if(![self expectAndSkip:',' inString:string cursor:i errors:errors])
                return nil;
        // Parse key value pair.
        JYKeyValuePair *kvp = [self captureKeyValuePair:string cursor:i errors:errors];
        if (kvp == nil)
            return nil;
        [dict setObject:kvp.value forKey:kvp.key];
    }
    [JYError errors:errors raiseError:JYErrorInvalidFormat withFormat:@"Unexpected end of dictionary."];
    return nil;
}

- (JYKeyValuePair *)captureKeyValuePair:(NSString *)string cursor:(int*)i errors:(NSArray **)errors {
    [self skipWhitespaces:string cursor:i];
    // Capture key.
    NSString *key = [self captureString:string cursor:i errors:errors];
    // Skip the colon.
    [self skipWhitespaces:string cursor:i];
    if (![self expectAndSkip:':' inString:string cursor:i errors:errors])
        return nil;
    // Capture value.
    NSString *value = [self captureValue:string cursor:i errors:errors];
    NSObject *obj = [self.jsonSerializer deserializeObject:value errors:errors];
    if (obj == nil)
        return nil;
    return [[JYKeyValuePair alloc] initWithKey:key value:obj];
}

- (NSString *)captureString:(NSString *)string cursor:(int*)i errors:(NSArray **)errors  {
    [self skipWhitespaces:string cursor:i];
    if (![self expectAndSkip:'"' inString:string cursor:i errors:errors])
        return nil;
    BOOL escaped = NO;
    int start = *i - 1;
    // Iterate through characters.
    for (; *i<[string length]; (*i)++) {
        char c = [string characterAtIndex:*i];
        // Check if the string ended.
        if (!escaped && c == '"') {
            (*i)++;
            NSString *captured = [string substringWithRange:NSMakeRange(start, *i - start)];
            return [self.jsonSerializer deserializeObject:captured withClass:[NSString class] errors:errors];
        }
        // Escape characters with \ before them (eg: \" or \n)
        escaped = c == '\\';
    }
    [JYError errors:errors raiseError:JYErrorInvalidFormat withFormat:@"Unexpected end of string."];
    return nil;
}

- (void)skipWhitespaces:(NSString *)string cursor:(int*)i {
    for (; *i<[string length]; (*i)++)
        if (![self isWhitespace:[string characterAtIndex:*i]])
            return;
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

- (NSString *)captureValue:(NSString *)string cursor:(int*)i errors:(NSArray **)errors {
    NSString *result = nil;
    // Match strings.
    if ([self matches:@"^(\"[^\"\\\\]*(?:\\\\.[^\"\\\\]*)*\")" result:&result string:string cursor:i errors:errors])
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
        // Braces have been opened.
        if (c == open)
            opened++;
        // Detect escaping backslash to escape future quotes.
        else if (inString && !escaped && c == '\\')
            escaped = true;
        // Unescaped quotes.
        else if (c == '"' && !escaped)
            inString = !inString;
        // Braces have been closed.
        else if (c == close) {
            opened--;
            // If braces have been closed, we return the whole braced substring.
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
