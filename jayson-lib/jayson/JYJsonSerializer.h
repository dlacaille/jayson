//
//  JYJsonSerializer.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJsonConverter.h"

@interface JYJsonSerializer : NSObject

/**
 * Array of converters to be used when serializing or deserializing an object.
 */
@property (nonatomic, strong) NSArray<JYJsonConverter> *jsonConverters;

@end
