//
//  JYPropertyDescriptor.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-21.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface JYPropertyDescriptor : NSObject

/**
 * Creates an instance of JYPropertyDescriptor with a objc property.
 */
- (instancetype)initWithProperty:(objc_property_t)property;

/**
 * Returns the string representation of the property's attributes.
 */
- (NSString *)propertyAttributes;

/**
 * Returns the class name including its protocols.
 */
- (NSString *)classNameWithProtocols;

/**
 * Returns the class name.
 */
- (NSString *)className;

/**
 * Returns the class of the property.
 */
- (Class)propertyClass;

/**
 * Returns the property.
 */
- (objc_property_t)property;

/**
 * Returns the property name.
 */
- (NSString *)name;

/**
 * Returns the protocol names as an NSString array.
 */
- (NSArray *)protocolNames;

/**
 * Returns a class with the same name as the first protocol.
 * This is used to provide typed array functionnality.
 */
- (Class)classFromProtocol;

@end
