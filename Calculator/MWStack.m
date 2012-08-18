//
//  MWStack.m
//  Calculator
//
//  Created by Michael Welch on 8/9/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "MWStack.h"

@interface MWStack()

@property (strong,nonatomic) NSMutableArray *array;

@end



@implementation MWStack

@synthesize array = _array;

- (BOOL)isEmpty
{
    return self.array.count == 0;
}

- (NSUInteger)count
{
    return self.array.count;
}

- (NSArray *)state
{
    return [self.array copy];
}

- (id)init
{
    return [self initWithState:[[NSArray alloc] init]];
}

- (id)initWithState:(NSArray *)state
{
    if (self == [super init])
    {
        [self setArray:[state mutableCopy]];
    }
    return self;
}

+ (MWStack *)stackWithState:(NSArray *)state
{
    return [[MWStack alloc] initWithState:state];
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
