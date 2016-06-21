//
//  JYJsonFormatter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-12.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJsonFormatter.h"
#import "JYJsonSerializer.h"
#import "JYClassDescriptor.h"
#import "JYPropertyDescriptor.h"
#import "JYCamelCaseConverter.h"
#import "JYJsonMappable.h"

@interface JYJsonFormatter()

@property (nonatomic, strong, readwrite) id jsonSerializer;

@end

@implementation JYJsonFormatter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        self.caseConverter = [JYCamelCaseConverter new];
        return self;
    }
    return nil;
}

- (void)writeIndentsWithState:(JYFormatterState *)state  {
    if (![self serializerSettings].indented)
        return;
    if ([state.builder length] > 0)
        [self write:@"\n" withState:state];
    for (int i=0; i<[self levelWithState:state]; i++)
        [self write:@"\t" withState:state];
}

- (void)writeSpace:(JYFormatterState *)state  {
    if (![self serializerSettings].indented)
        return;
    [self write:@" " withState:state];
}

- (void)beginObjectWithState:(JYFormatterState *)state {
    [state.levelItemCount addObject:@0];
    [self write:@"{" withState:state];
}

- (void)endObjectWithState:(JYFormatterState *)state {
    NSInteger itemCount = [[state.levelItemCount lastObject] integerValue];
    [state.levelItemCount removeLastObject];
    if (itemCount > 0)
        [self writeIndentsWithState:state];
    [self write:@"}" withState:state];
}

- (void)beginArrayWithState:(JYFormatterState *)state {
    [state.levelItemCount addObject:@0];
    [self write:@"[" withState:state];
}

- (void)endArrayWithState:(JYFormatterState *)state {
    NSInteger itemCount = [[state.levelItemCount lastObject] integerValue];
    [state.levelItemCount removeLastObject];
    if (itemCount > 0)
        [self writeIndentsWithState:state];
    [self write:@"]" withState:state];
}

- (void)writeProperty:(NSString *)key withValue:(id)value withState:(JYFormatterState *)state errors:(NSArray **)errors {
    [self writeObject:key withState:state errors:errors];
    [self write:@":" withState:state];
    [self writeSpace:state];
    [self.jsonSerializer serializeObject:value withState:state errors:errors];
}

- (void)write:(NSString *)str withState:(JYFormatterState *)state {
    [state.builder appendString:str];
}

- (void)incrementItemCountWithState:(JYFormatterState *)state {
    if ([self levelWithState:state] < 1)
        return;
    int itemCount = [[state.levelItemCount lastObject] intValue];
    NSNumber *newObj = [NSNumber numberWithInt:itemCount+1];
    [state.levelItemCount replaceObjectAtIndex:[self levelWithState:state]-1 withObject:newObj];
}

- (void)writeCommaIfNeededWithState:(JYFormatterState *)state {
    if ([self levelWithState:state] == 0)
        return;
    if ([[state.levelItemCount lastObject] integerValue] > 0)
        [self write:@"," withState:state];
}

- (void)writeObject:(id)obj withState:(JYFormatterState *)state errors:(NSArray **)errors {
    if ([[obj class] isSubclassOfClass:[NSString class]])
        [self write:[NSString stringWithFormat:@"\"%@\"", obj] withState:state];
    else if ([[obj class] isSubclassOfClass:[NSNumber class]])
        [self write:[self numberToString:obj] withState:state];
    else if (obj == nil || [[obj class] isSubclassOfClass:[NSNull class]])
        [self write:@"null" withState:state];
    else if ([[obj class] isSubclassOfClass:[NSArray class]])
        [self writeArray:obj withState:state errors:(NSArray **)errors];
    else if ([[obj class] isSubclassOfClass:[NSDictionary class]])
        [self writeDictionary:obj withState:state errors:errors];
    else
        [self writeProperties:obj withState:state errors:errors];
}

- (NSString *)numberToString:(NSNumber *)number {
    return [number isKindOfClass:objc_getClass("__NSCFBoolean")]
        ? ([number boolValue] ? @"true" : @"false")
        : [number stringValue];
}

- (void)writeProperties:(id)obj withState:(JYFormatterState *)state errors:(NSArray **)errors {
    [self beginObjectWithState:state];
    JYClassDescriptor *classDesc = [[JYClassDescriptor alloc] initWithClass:[obj class]];
    NSDictionary *propertyMap = nil;
    if ([obj respondsToSelector:@selector(jsonPropertyMap)])
        propertyMap = [obj jsonPropertyMap];
    for (JYPropertyDescriptor *prop in classDesc.propertyDescriptors)
    {
        if ([prop.protocolNames containsObject:@"JYIgnore"])
            continue; // Ignore the property.
        id value = [obj valueForKey:prop.name];
        if ([self serializerSettings].ignoreNull && (value == nil || value == [NSNull null]))
            continue; // Ignore null values.
        [self writeCommaIfNeededWithState:state];
        [self writeIndentsWithState:state];
        [self incrementItemCountWithState:state];
        // Uses mapped property name or converted property name if it is not mapped.
        NSString *propName = [propertyMap objectForKey:prop.name] ?: [self.caseConverter convert:prop.name];
        [self writeProperty:propName withValue:value withState:state errors:errors];
    }
    [self endObjectWithState:state];
}

- (void)writeArray:(NSArray *)array withState:(JYFormatterState *)state errors:(NSArray **)errors {
    [self beginArrayWithState:state];
    for (int i = 0; i < [array count]; i++)
    {
        [self writeCommaIfNeededWithState:state];
        [self writeIndentsWithState:state];
        [self incrementItemCountWithState:state];
        id value = [array objectAtIndex:i];
        [self.jsonSerializer serializeObject:value withState:state errors:errors];
    }
    [self endArrayWithState:state];
}

- (void)writeDictionary:(NSDictionary *)dict withState:(JYFormatterState *)state errors:(NSArray **)errors {
    [self beginObjectWithState:state];
    for (int i = 0; i < [dict count]; i++)
    {
        [self writeCommaIfNeededWithState:state];
        [self writeIndentsWithState:state];
        [self incrementItemCountWithState:state];
        NSString *key = [[dict allKeys] objectAtIndex:i];
        id value = [[dict allValues] objectAtIndex:i];
        [self writeProperty:key withValue:value withState:state errors:errors];
    }
    [self endObjectWithState:state];
}

- (JYSerializerSettings *)serializerSettings {
    JYJsonSerializer *serializer = self.jsonSerializer;
    return serializer.serializerSettings;
}

- (NSUInteger)levelWithState:(JYFormatterState *)state {
    return [state.levelItemCount count];
}

@end