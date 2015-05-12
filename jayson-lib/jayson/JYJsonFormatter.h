//
//  JYJsonFormatter.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-12.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJsonFormatter : NSObject

/**
 * Begins an object.
 */
- (void)beginObject;

/**
 * Ends an object.
 */
- (void)endObject;

/**
 * Begins an array.
 */
- (void)beginArray;

/**
 * Ends an array.
 */
- (void)endArray;

/**
 * Writes a property with a key and a value.
 */
- (void)writeProperty:(NSString *)key withValue:(id)value;

/**
 * Writes an object.
 */
- (void)writeObject:(id)obj;

/**
 * Writes a raw string.
 */
- (void)write:(NSString *)str;

/**
 * Serializes an object.
 */
- (NSString *)serialize:(id)object;

@end
