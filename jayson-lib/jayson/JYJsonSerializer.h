//
//  JYJsonSerializer.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJsonFormatter.h"
#import "JYCaseConverter.h"
#import "JYSerializerSettings.h"

@interface JYJsonSerializer : NSObject

/**
 * Creates an instance of JYJsonSerializer with specified settings.
 */
- (instancetype)initWithSettings:(JYSerializerSettings *)settings;

/**
 * Array of converters to be used when serializing or deserializing an object.
 */
@property (nonatomic, strong) NSArray *jsonConverters;

/**
 * Case converter used to translate json property names to objC properties.
 */
@property (nonatomic, strong) NSObject<JYCaseConverter> *caseConverter;

/**
 * Json Formatter to use in serialization.
 */
@property (nonatomic, strong) JYJsonFormatter *jsonFormatter;

/**
 * Settings used to configure serialization.
 */
@property (nonatomic, strong, readonly) JYSerializerSettings *serializerSettings;

/**
 * Serializes an object to JSON.
 * @return A serialized string representing the object.
 */
- (NSString *)serializeObject:(id)obj;

/**
 * Serializes an object to JSON.
 * @param errors Errors while deserializing.
 * @return A serialized string representing the object.
 */
- (NSString *)serializeObject:(id)obj errors:(NSArray **)errors;

/**
 * Writes a serialized object to an existing FormatterState.
 * @param state State of the JsonFormatter
 * @return A serialized string representing the object.
 */
- (void)serializeObject:(id)obj withState:(JYFormatterState *)state;

/**
 * Writes a serialized object to an existing FormatterState.
 * @param state State of the JsonFormatter
 * @param errors Errors while deserializing.
 * @return A serialized string representing the object.
 */
- (void)serializeObject:(id)obj withState:(JYFormatterState *)state errors:(NSArray **)errors;

/**
 * Deserializes a JSON array into an object.
 *
 * @param json JSON string to deserialize.
 * @param objectClass Class of the object to return.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass;

/**
 * Deserializes a JSON array into an object.
 *
 * @param json JSON string to deserialize.
 * @param objectClass Class of the object to return.
 * @param errors Errors while deserializing.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass errors:(NSArray **)errors;

/**
 * Deserializes a JSON dictionary into a dictionary with strict types.
 *
 * @param json JSON string to deserialize.
 * @param objectClass Class of the dictionary value to return.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectDictionary:(NSString *)json withClass:(Class)objectClass;

/**
 * Deserializes a JSON dictionary into a dictionary with strict types.
 *
 * @param json JSON string to deserialize.
 * @param objectClass Class of the dictionary value to return.
 * @param errors Errors while deserializing.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectDictionary:(NSString *)json withClass:(Class)objectClass errors:(NSArray **)errors;

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
 * @param objectClass Class of the object to return.
 * @param errors Errors while deserializing.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObject:(NSString *)json withClass:(Class)objectClass errors:(NSArray **)errors;

/**
 * Deserializes a JSON string into an object.
 *
 * @param json JSON string to deserialize.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObject:(NSString *)json;

/**
 * Deserializes a JSON string into an object.
 *
 * @param json JSON string to deserialize.
 * @param errors Errors while deserializing.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObject:(NSString *)json errors:(NSArray **)errors;

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
 * @param errors Errors while deserializing.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectFromData:(NSData *)data errors:(NSArray **)errors;

/**
 * Deserializes Data into an object. The data must be a UTF8 encoded string.
 *
 * @param data Data to deserialize.
 * @param objectClass Class of the object to return.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass;

/**
 * Deserializes Data into an object. The data must be a UTF8 encoded string.
 *
 * @param data Data to deserialize.
 * @param objectClass Class of the object to return.
 * @param errors Errors while deserializing.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass errors:(NSArray **)errors;

/**
 * Deserializes Data into an array of objects. The data must be a UTF8 encoded string.
 *
 * @param data Data to deserialize.
 * @param objectClass Class of the object in the array to return.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectArrayFromData:(NSData *)data withClass:(Class)objectClass;

/**
 * Deserializes Data into an array of objects. The data must be a UTF8 encoded string.
 *
 * @param data Data to deserialize.
 * @param objectClass Class of the object in the array to return.
 * @param errors Errors while deserializing.
 * @return The deserialized object of "objectClass" type.
 */
- (id)deserializeObjectArrayFromData:(NSData *)data withClass:(Class)objectClass errors:(NSArray **)errors;

@end
