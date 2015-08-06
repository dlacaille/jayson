//
//  JYKeyValuePair.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-07-30.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYKeyValuePair : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSObject *value;

- (instancetype)initWithKey:(NSString *)key value:(NSObject *)value;

@end
