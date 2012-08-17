//
//  MWStack.m
//  Calculator
//
//  Created by Michael Welch on 8/9/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "MWStack.h"

@interface MWStack()

@property (strong,readonly,nonatomic) NSMutableArray *array;

@end



@implementation MWStack

@synthesize array = _array;

- (id)state
{
    return [self.array copy];
}

+ (MWStack *)stackWithState:(id)state
{
    MWStack *stack;
    if ([state isKindOfClass:[self class]]) {
        stack = [state mutableCopy];
    }
    return stack;
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    
    return _array;
}


- (void)push:(id)object
{
    [self.array addObject:object];
}

- (id)pop
{
    id object = [self.array lastObject];
    if (object) {
        [self.array removeLastObject];
    }
    return object;
}

- (void)clear
{
    [self.array removeAllObjects];
}

@end
