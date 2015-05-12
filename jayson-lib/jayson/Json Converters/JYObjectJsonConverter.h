//
//  JYObjectJsonConverter.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-12.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJsonConverter.h"
#import "JYJsonSerializer.h"

@interface JYObjectJsonConverter : NSObject<JYJsonConverter>

@property (nonatomic, strong) JYJsonSerializer *jsonSerializer;

@end
