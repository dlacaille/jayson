//
//  JYClassDescriptor.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-21.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface JYClassDescriptor : NSObject

/**
 * Creates an instance of JYClassDescriptor with a class.
 */
- (instancetype)initWithClass:(Class)class;

/**
 * Gets the class name.
 */
- (NSString *)className;

/**
 * Gets the class.
 */
- (Class)class;

/**
 * Returns an array of JYPropertyDescriptor describing the properties of the class.
 */
- (NSArray *)propertyDescriptors;

@end
