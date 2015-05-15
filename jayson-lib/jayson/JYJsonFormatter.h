//
//  JYJsonFormatter.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-12.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJsonFormatter : NSObject

/*
 * When true, the json is indented when serializing objects.
 */
@property (assign, nonatomic) BOOL indented;

/*
 * Serializer used by the json formatter.
 */
@property (nonatomic, strong) id jsonSerializer;

/*
 * Initializes a json formatter with a json formatter.
 */
- (instancetype)initWithSerializer:(id)serializer;

/**
 * Serializes an object.
 */
- (NSString *)serialize:(id)object;

@end
