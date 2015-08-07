//
//  JYObjectJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-12.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYObjectJsonConverter.h"
#import "JYClassDescriptor.h"
#import "JYPropertyDescriptor.h"
#import "JYJsonMappable.h"
#import "JYError.h"
#import "JYKeyValuePair.h"

@implementation JYObjectJsonConverter
{
    NSMutableDictionary *propertyMap;
}

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
    // This converter should not be used for deserializing when the Class is unknown.
    return nil;
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors {
    if ([string isEqual:@"null"])
        return nil;
    int i = 0;
    return [self captureObject:string atIndex:&i withClass:objectClass errors:errors];
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

- (id)captureObject:(NSString *)string atIndex:(int*)i withClass:(Class)objectClass errors:(NSArray **)errors {
    if (![self expectAndSkip:'{' inString:string cursor:i errors:errors])
        return nil;
    // Create an instance of the resulting object.
    id result = [[objectClass alloc] init];
    // Defines the property map to map json property names.
    if ([result respondsToSelector:@selector(jsonPropertyMap)]) {
        // Reverse property map. value -> key
        propertyMap = [NSMutableDictionary new];
        NSDictionary *propMap = [result jsonPropertyMap];
        for (NSString *key in [propMap allKeys])
            propertyMap[propMap[key]] = key;
    }
    // Iterate through characters.
    int capturedProps = 0;
    while (*i < [string length]) {
        [self skipWhitespaces:string cursor:i];
        // Check if the object ended.
        if ([string characterAtIndex:*i] == '}') {
            (*i)++;
            return result;
        }
        // Dictionary must start with a quote.
        if (capturedProps == 0)
            if(![self expect:'"' inString:string cursor:i errors:errors])
                return nil;
        // Capture commas.
        if (capturedProps > 0)
            if(![self expectAndSkip:',' inString:string cursor:i errors:errors])
                return nil;
        // Parse key value pair.
        [self skipWhitespaces:string cursor:i];
        // Capture key.
        NSString *key = [self captureString:string cursor:i errors:errors];
        // Skip the colon.
        [self skipWhitespaces:string cursor:i];
        if (![self expectAndSkip:':' inString:string cursor:i errors:errors])
            return nil;
        // Capture value.
        NSString *value = [self captureValue:string cursor:i errors:errors];
        [self setObjectProperty:result withProperty:key value:value];
        capturedProps++;
    }
    [JYError errors:errors raiseError:JYErrorInvalidFormat withFormat:@"Expected end of dictionary."];
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

- (void)setObjectProperty:(id)object withProperty:(NSString *)propertyName value:(NSString *)json {
    // Uses mapped property name or converted property name if it is not mapped.
    NSString *propName = [propertyMap objectForKey:propertyName] ?: [self.jsonSerializer.caseConverter convert:propertyName];
    JYClassDescriptor *classDesc = [[JYClassDescriptor alloc] initWithClass:[object class]];
    for (JYPropertyDescriptor *desc in [classDesc propertyDescriptors]) {
        if ([desc.protocolNames containsObject:@"JYIgnore"])
            continue; // Ignore the property.
        // Find the property with the same name.
        if ([propName isEqual:desc.name])
        {
            Class propClass = desc.propertyClass;
            NSArray *protocols = desc.protocolNames;
            if ([propClass isSubclassOfClass:[NSArray class]] && [protocols count] > 0) {
                Class arrayClass = desc.classFromProtocol;
                id newValue = [self.jsonSerializer deserializeObjectArray:json withClass:arrayClass];
                [object setValue:newValue forKey:propName];
                
            } else {
                // Deserialize with Class and set the property value.
                id newValue = [self.jsonSerializer deserializeObject:json withClass:propClass];
                [object setValue:newValue forKey:propName];
            }
        }
    }
}

- (id)deserializeArray:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors {
    return nil;
}

- (BOOL)canConvert:(Class)objectClass errors:(NSArray **)errors {
    return [objectClass isSubclassOfClass:[NSObject class]];
}

- (BOOL)canConvertJson:(NSString *)string errors:(NSArray **)errors {
    // This converter should not be used for deserializing when the Class is unknown.
    return false;
}

@end
