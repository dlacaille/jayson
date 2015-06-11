//
//  JYFormatterState.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-06-11.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFormatterState : NSObject

@property (nonatomic, strong) NSMutableString *builder;
@property (nonatomic, strong) NSMutableArray *levelItemCount;

- (NSString *)string;

@end
