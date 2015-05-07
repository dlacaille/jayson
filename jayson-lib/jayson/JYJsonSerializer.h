//
//  JYJsonSerializer.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJsonSerializer : NSObject

/**
 * Array of converters to be used when serializing or deserializing an object.
 */
@property (nonatomic, strong) NSArray *jsonConverters;

/**
 * Serializes an object to JSON.
 * @return A serialized string representing the object.
 */
- (NSString *)serializeObject:(id)obj;

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

@end
