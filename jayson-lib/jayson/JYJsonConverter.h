//
//  JYJsonConverter.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

@protocol JYJsonConverter

/**
 * Converts an object to its string representation.
 * 
 * @param obj Object to convert.
 * @return String representation of the object.
 */
- (NSString *)toString:(id)obj;

/**
 * Converts a string back to an object.
 *
 * @param string String to parse.
 * @return Parsed object.
 */
- (id)fromString:(NSString *)string;

/**
 * Method to override which verifies if the class can be converted from and to a string.
 *
 * @param objectClass Class to verify.
 * @return True if the class can be converted.
 */
- (BOOL)canConvert:(Class)objectClass;

@end
