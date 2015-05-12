//
//  JYJsonFormatter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-12.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJsonFormatter.h"
#import <objc/runtime.h>

@implementation JYJsonFormatter
{
    NSMutableString *builder;
    NSMutableArray *levelItemCount;
}

- (instancetype)init {
    if (self = [super init]) {
        builder = [NSMutableString new];
        levelItemCount = [NSMutableArray new];
        return self;
    }
    return nil;
}

- (void)beginObject {
    [levelItemCount addObject:@0];
    [self write:@"{"];
}

- (void)endObject {
    [levelItemCount removeLastObject];
    [self write:@"}"];
}

- (void)beginArray {
    [levelItemCount addObject:@0];
    [self write:@"["];
}

- (void)endArray {
    [levelItemCount removeLastObject];
    [self write:@"]"];
}

- (void)writeProperty:(NSString *)key withValue:(NSObject *)value {
    [self writeObject:key];
    [self write:@":"];
    [self writeObject:value];
}

- (void)write:(NSString *)str {
    [builder appendString:str];
}

- (void)incrementItemCount {
    int level = (int)[levelItemCount count] - 1;
    if (level < 0)
        return;
    int itemCount = [[levelItemCount lastObject] intValue];
    NSNumber *newObj = [NSNumber numberWithInt:itemCount+1];
    [levelItemCount replaceObjectAtIndex:level withObject:newObj];
}

- (void)writeCommaIfNeeded {
    if ([levelItemCount count] == 0)
        return;
    if ([[levelItemCount lastObject] integerValue] > 0)
        [self write:@","];
}

- (void)writeObject:(id)obj {
    if ([[obj class] isSubclassOfClass:[NSString class]])
        [self write:[NSString stringWithFormat:@"\"%@\"", obj]];
    else if ([[obj class] isSubclassOfClass:[NSNumber class]])
        [self write:[(NSNumber *)obj stringValue]];
    else if ([[obj class] isSubclassOfClass:[NSNull class]])
        [self write:@"null"];
    else if ([[obj class] isSubclassOfClass:[NSArray class]])
        [self writeArray:obj];
    else if ([[obj class] isSubclassOfClass:[NSDictionary class]])
        [self writeDictionary:obj];
    else
        [self writeProperties:obj];
}

- (void)writeArray:(NSArray *)array {
    [self beginArray];
    for (int i = 0; i < [array count]; i++)
    {
        [self writeCommaIfNeeded];
        [self incrementItemCount];
        id value = [array objectAtIndex:i];
        [self writeObject:value];
    }
    [self endArray];
}

- (void)writeProperties:(NSObject *)obj {
    [self beginObject];
    unsigned int pCount;
    objc_property_t *properties = class_copyPropertyList([obj class], &pCount);
    for (int i = 0; i < pCount; i++)
    {
        [self writeCommaIfNeeded];
        [self incrementItemCount];
        NSString *propName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [obj valueForKey:propName];
        [self writeProperty:propName withValue:value];
    }
    free(properties);
    [self endObject];
}

- (void)writeDictionary:(NSDictionary *)dict {
    [self beginObject];
    for (int i = 0; i < [dict count]; i++)
    {
        [self writeCommaIfNeeded];
        [self incrementItemCount];
        NSString *key = [[dict allKeys] objectAtIndex:i];
        id value = [[dict allValues] objectAtIndex:i];
        [self writeProperty:key withValue:value];
    }
    [self endObject];
}

- (NSString *)serialize:(id)object {
    builder = [NSMutableString new];
    levelItemCount = [NSMutableArray new];
    [self writeObject:object];
    return [NSString stringWithString:builder];
}

@end