//
//  JYJsonConverter.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJsonSerializer.h"

@protocol JYJsonConverter

@property (nonatomic, strong) JYJsonSerializer *jsonSerializer;

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer;

/**
 * Converts an object to its string representation.
 * 
 * @param obj Object to convert.
 * @return String representation of the object.
 */
- (NSString *)toString:(id)obj;

/**
 * Converts a string back to an object with no specific class.
 *
 * @param string String to parse.
 * @return Parsed object.
 */
- (id)fromString:(NSString *)string;

/**
 * Converts a string back to an object.
 *
 * @param string String to parse.
 * @param Class to return.
 * @return Parsed object.
 */
- (id)fromString:(NSString *)string withClass:(Class)objectClass;

/**
 * Method to override which verifies if the class can be converted from and to a string.
 *
 * @param objectClass Class to verify.
 * @return True if the class can be converted.
 */
- (BOOL)canConvert:(Class)objectClass;

/**
 * Method to override which verifies if the string can be converted to a class.
 *
 * @param json Json to verify.
 * @return True if the class can be converted.
 */
- (BOOL)canConvertJson:(NSString *)string;

@end
