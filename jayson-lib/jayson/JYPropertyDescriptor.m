//
//  JYPropertyDescriptor.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-21.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYPropertyDescriptor.h"

@interface JYPropertyDescriptor()

@property (nonatomic, assign) objc_property_t property;

@end

@implementation JYPropertyDescriptor

- (instancetype)initWithProperty:(objc_property_t)property {
    if (self = [super init]) {
        self.property = property;
        return self;
    }
    return nil;
}

- (NSString *)propertyAttributes {
    return [NSString stringWithUTF8String:property_getAttributes(self.property)];
}

- (NSString *)classNameWithProtocols {
    NSArray* splitPropertyAttributes = [self.propertyAttributes componentsSeparatedByString:@"\""];
    if ([splitPropertyAttributes count] >= 2)
        return [splitPropertyAttributes objectAtIndex:1];
    return nil;
}

- (NSString *)className {
    NSArray *split = [self.classNameWithProtocols componentsSeparatedByString:@"<"];
    return [split objectAtIndex:0];
}

- (Class)propertyClass {
    return NSClassFromString(self.className);
}

- (objc_property_t)property {
    return _property;
}

- (NSString *)name {
    return [NSString stringWithUTF8String:property_getName(self.property)];
}

- (NSArray *)protocolNames {
    NSArray *split = [self.classNameWithProtocols componentsSeparatedByString:@"<"];
    if ([split count] >= 2)
    {
        NSString *protocolAttr = [split objectAtIndex:1];
        protocolAttr = [protocolAttr substringToIndex:[protocolAttr length]-1];
        return [protocolAttr componentsSeparatedByString:@","];
    }
    return nil;
}

- (Class)classFromProtocol {
    NSArray *protocols = self.protocolNames;
    if (protocols != nil)
        return NSClassFromString([protocols objectAtIndex:0]);
    return nil;
}

@end
