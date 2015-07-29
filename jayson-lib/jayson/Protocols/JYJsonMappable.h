//
//  JYJsonMappable.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-07-28.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JYJsonMappable

/*
 * Maps object property names to json property names for serialization/deserialization.
 * Properties that are not included in the dictionary will default to the object property name.
 */
- (NSDictionary *)jsonPropertyMap;

@end