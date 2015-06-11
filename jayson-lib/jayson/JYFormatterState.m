//
//  JYFormatterState.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-06-11.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYFormatterState.h"

@implementation JYFormatterState

- (instancetype)init {
    if (self = [super init]) {
        self.builder = [NSMutableString new];
        self.levelItemCount = [NSMutableArray new];
        return self;
    }
    return nil;
}

- (NSString *)string {
    return [NSString stringWithString:self.builder];
}

@end
