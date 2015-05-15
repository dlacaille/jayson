//
//  JYJsonSerializer.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJsonFormatter.h"

@interface JYJsonSerializer : NSObject

/**
 * Array of converters to be used when serializing or deserializing an object.
 */
@property (nonatomic, strong) NSArray *jsonConverters;

/**
 * Format used by the date converter. Default value is ISO8601 yyyy-MM-dd'T'HH:mm:ssZZZZZ
 */
@property (nonatomic, strong) NSString *dateFormat;

/**
 * Json Formatter to use in serialization.
 */
@property (nonatomic, strong) JYJsonFormatter *jsonFormatter;

/**
 * Serializes an object to JSON.
 * @return A serialized string representing the object.
 */
- (NSString *)serializeObject:(id)obj;

/**
 * Deserializes a JSON array into an object.
 *
 * @param json JSON string to deserialize.
 * @param objectClass Class of the object to return.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass;

/**
 * Deserializes a JSON string into an object.
 *
 * @param json JSON string to deserialize.
 * @param objectClass Class of the object to return.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObject:(NSString *)json withClass:(Class)objectClass;

/**
 * Deserializes a JSON string into an object.
 *
 * @param json JSON string to deserialize.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObject:(NSString *)json;

/**
 * Deserializes Data into an object. The data must be a UTF8 encoded string.
 *
 * @param data Data to deserialize.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectFromData:(NSData *)data;

/**
 * Deserializes Data into an object. The data must be a UTF8 encoded string.
 *
 * @param data Data to deserialize.
 * @param objectClass Class of the object to return.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass;

@end
