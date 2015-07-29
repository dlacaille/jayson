//
//  PropertyMapClass.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-07-28.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJsonMappable.h"

@interface PropertyMapTestClass : NSObject<JYJsonMappable>

@property (strong, nonatomic) NSNumber *numId;

@end
