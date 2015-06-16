//
//  JYJayson.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJsonSerializer.h"

@interface JYJayson : NSObject

/**
 * Returns the default serializer. This can be used to modify the default behavior of JYJayson.
 * @return The default serializer used by JYJayson.
 */
+ (JYJsonSerializer *)defaultSerializer;

/**
 * Serializes an object to JSON using the default serializer.
 * @return A serialized string representing the object.
 */
+ (NSString *)serializeObject:(id)obj;

/**
 * Serializes an object to JSON using a new serializer with specified settings.
 * @return A serialized string representing the object.
 */
+ (NSString *)serializeObject:(id)obj withSettings:(JYSerializerSettings *)settings;

/**
 * Deserializes a JSON array into an object.
 *
 * @param json JSON string to deserialize.
 * @param objectClass Class of the object to return.
 * @return The deserialized object of "objectClass" type.
 */
+ (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass;

/**
 * Deserializes a JSON string into an object.
 *
 * @param json JSON string to deserialize.
 * @param objectClass Class of the object to return.
 * @return The deserialized object of "objectClass" type.
 */
+ (id)deserializeObject:(NSString *)json withClass:(Class)objectClass;

/**
 * Deserializes a JSON string into an object.
 *
 * @param json JSON string to deserialize.
 * @return The deserialized object of "objectClass" type.
 */
+ (id)deserializeObject:(NSString *)json;

/**
 * Deserializes Data into an object. The data must be a UTF8 encoded string.
 *
 * @param data Data to deserialize.
 * @return The deserialized object of "objectClass" type.
 */
+ (id)deserializeObjectFromData:(NSData *)data;

/**
 * Deserializes Data into an object. The data must be a UTF8 encoded string.
 *
 * @param data Data to deserialize.
 * @param objectClass Class of the object to return.
 * @return The deserialized object of "objectClass" type.
 */
+ (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass;

/**
 * Return a dictionary from a JSON string.
 *
 *@param json JSON string to convert into dictionary.
 *@return The dictionary from the JSON string.
 */
+ (NSDictionary *)toDictionary:(NSString *)json;

@end
