//
//  JYJsonFormatter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-12.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJsonFormatter.h"
#import "JYJsonSerializer.h"
#import <objc/runtime.h>

@interface FormatterState : NSObject

@property (nonatomic, strong) NSMutableString *builder;
@property (nonatomic, strong) NSMutableArray *levelItemCount;

@end

@implementation FormatterState

- (instancetype)init {
    if (self = [super init]) {
        self.builder = [NSMutableString new];
        self.levelItemCount = [NSMutableArray new];
        return self;
    }
    return nil;
}

@end

@implementation JYJsonFormatter

- (instancetype)initWithSerializer:(id)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (void)writeIndentsWithState:(FormatterState *)state  {
    if (![self indented])
        return;
    if ([state.builder length] > 0)
        [self write:@"\n" withState:state];
    for (int i=0; i<[self levelWithState:state]; i++)
        [self write:@"\t" withState:state];
}

- (void)beginObjectWithState:(FormatterState *)state {
    [self writeIndentsWithState:state];
    [state.levelItemCount addObject:@0];
    [self write:@"{" withState:state];
}

- (void)endObjectWithState:(FormatterState *)state {
    [state.levelItemCount removeLastObject];
    [self writeIndentsWithState:state];
    [self write:@"}" withState:state];
}

- (void)beginArrayWithState:(FormatterState *)state {
    [self writeIndentsWithState:state];
    [state.levelItemCount addObject:@0];
    [self write:@"[" withState:state];
}

- (void)endArrayWithState:(FormatterState *)state {
    [state.levelItemCount removeLastObject];
    [self writeIndentsWithState:state];
    [self write:@"]" withState:state];
}

- (void)writeProperty:(NSString *)key withValue:(id)value withState:(FormatterState *)state {
    [self writeObject:key withState:state];
    [self write:@":" withState:state];
    NSString *serialized = [self.jsonSerializer serializeObject:value];
    [self write:serialized withState:state];
}

- (void)write:(NSString *)str withState:(FormatterState *)state {
    [state.builder appendString:str];
}

- (void)incrementItemCountWithState:(FormatterState *)state {
    if ([self levelWithState:state] < 1)
        return;
    int itemCount = [[state.levelItemCount lastObject] intValue];
    NSNumber *newObj = [NSNumber numberWithInt:itemCount+1];
    [state.levelItemCount replaceObjectAtIndex:[self levelWithState:state]-1 withObject:newObj];
}

- (void)writeCommaIfNeededWithState:(FormatterState *)state {
    if ([self levelWithState:state] == 0)
        return;
    if ([[state.levelItemCount lastObject] integerValue] > 0)
        [self write:@"," withState:state];
}

- (void)writeObject:(id)obj withState:(FormatterState *)state {
    if ([[obj class] isSubclassOfClass:[NSString class]])
        [self write:[NSString stringWithFormat:@"\"%@\"", obj] withState:state];
    else if ([[obj class] isSubclassOfClass:[NSNumber class]])
        [self write:[(NSNumber *)obj stringValue] withState:state];
    else if ([[obj class] isSubclassOfClass:[NSNull class]])
        [self write:@"null" withState:state];
    else if ([[obj class] isSubclassOfClass:[NSArray class]])
        [self writeArray:obj withState:state];
    else if ([[obj class] isSubclassOfClass:[NSDictionary class]])
        [self writeDictionary:obj withState:state];
    else
        [self writeProperties:obj withState:state];
}

- (void)writeProperties:(NSObject *)obj withState:(FormatterState *)state {
    [self beginObjectWithState:state];
    unsigned int pCount;
    objc_property_t *properties = class_copyPropertyList([obj class], &pCount);
    for (int i = 0; i < pCount; i++)
    {
        [self writeCommaIfNeededWithState:state];
        [self writeIndentsWithState:state];
        [self incrementItemCountWithState:state];
        NSString *propName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [obj valueForKey:propName];
        [self writeProperty:propName withValue:value withState:state];
    }
    free(properties);
    [self endObjectWithState:state];
}

- (void)writeArray:(NSArray *)array withState:(FormatterState *)state {
    [self beginArrayWithState:state];
    for (int i = 0; i < [array count]; i++)
    {
        [self writeCommaIfNeededWithState:state];
        [self writeIndentsWithState:state];
        [self incrementItemCountWithState:state];
        id value = [array objectAtIndex:i];
        NSString *serialized = [self.jsonSerializer serializeObject:value];
        [self write:serialized withState:state];
    }
    [self endArrayWithState:state];
}

- (void)writeDictionary:(NSDictionary *)dict withState:(FormatterState *)state {
    [self beginObjectWithState:state];
    for (int i = 0; i < [dict count]; i++)
    {
        [self writeCommaIfNeededWithState:state];
        [self writeIndentsWithState:state];
        [self incrementItemCountWithState:state];
        NSString *key = [[dict allKeys] objectAtIndex:i];
        id value = [[dict allValues] objectAtIndex:i];
        [self writeProperty:key withValue:value withState:state];
    }
    [self endObjectWithState:state];
}

- (NSString *)serialize:(id)object {
    FormatterState *state = [FormatterState new];
    [self writeObject:object withState:state];
    return [NSString stringWithString:state.builder];
}

- (NSUInteger)levelWithState:(FormatterState *)state {
    return [state.levelItemCount count];
}

@end