//
//  JYClassDescriptor.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-21.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYClassDescriptor.h"
#import "JYPropertyDescriptor.h"

@interface JYClassDescriptor()

@property (nonatomic, strong) Class class;

@end

@implementation JYClassDescriptor

- (instancetype)initWithClass:(Class)class {
    if (self = [super init]) {
        self.class = class;
        return self;
    }
    return nil;
}

- (NSString *)className {
    return NSStringFromClass(self.class);
}

- (Class)class {
    return _class;
}

- (NSArray *)propertyDescriptors {
    unsigned int pCount;
    objc_property_t *properties = class_copyPropertyList(self.class, &pCount);
    NSMutableArray *descriptors = [NSMutableArray arrayWithCapacity:pCount];
    for (int i=0; i<pCount; i++) {
        objc_property_t property = properties[i];
        JYPropertyDescriptor *descriptor = [[JYPropertyDescriptor alloc] initWithProperty:property];
        [descriptors addObject:descriptor];
    }
    free(properties);
    return descriptors;
}

@end
