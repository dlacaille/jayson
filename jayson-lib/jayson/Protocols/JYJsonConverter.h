//
//  JYJsonConverter.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJsonSerializer.h"
#import "JYFormatterState.h"

@protocol JYJsonConverter

@property (nonatomic, strong) JYJsonSerializer *jsonSerializer;

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer;

/**
 * Converts an object to its string representation.
 * 
 * @param obj Object to convert.
 * @return String representation of the object.
 */
- (id)serialize:(id)obj errors:(NSArray **)errors;

/**
 * Converts a string back to an object with no specific class.
 *
 * @param string String to parse.
 * @return Parsed object.
 */
- (id)deserialize:(NSString *)string errors:(NSArray **)errors;

/**
 * Converts a string back to an object.
 *
 * @param string String to parse.
 * @param Class to return.
 * @return Parsed object.
 */
- (id)deserialize:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors;

/**
 * Converts a string back to an array of objects.
 *
 * @param string String to parse.
 * @param Class of the objects in the array.
 * @return Parsed object.
 */
- (id)deserializeArray:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors;

/**
 * Converts a string back to a dictionary of strict types.
 *
 * @param string String to parse.
 * @param Class of the objects in the array.
 * @return Parsed object.
 */
- (id)deserializeDictionary:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors;

/**
 * Method to override which verifies if the class can be converted from and to a string.
 *
 * @param objectClass Class to verify.
 * @return True if the class can be converted.
 */
- (BOOL)canConvert:(Class)objectClass errors:(NSArray **)errors;

/**
 * Method to override which verifies if the string can be converted to a class.
 *
 * @param json Json to verify.
 * @return True if the class can be converted.
 */
- (BOOL)canConvertJson:(NSString *)string errors:(NSArray **)errors;

@end
