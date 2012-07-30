//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Michael Welch on 7/30/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic,strong,readonly) NSMutableArray *operandStack;

@end



@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (void)reset
{
    self.operationError = NO;
    [self.operandStack removeAllObjects];
}

- (NSMutableArray *)operandStack
{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    
    return _operandStack;
}

- (double) popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (void)pushOperand:(double)operand
{
    if (self.operationError) return;
    
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    if (self.operationError) return 0;
    
    // implementation assumes all ops are two operand
    double secondOperand = [self popOperand];
    double firstOperand = [self popOperand];
    double result;
    
    if ([operation isEqualToString:@"+"])
    {
        result = firstOperand + secondOperand;
    }
    else if ([operation isEqualToString:@"-"])
    {
        result = firstOperand - secondOperand;
    }
    else if ([operation isEqualToString:@"*"])
    {
        result = firstOperand * secondOperand;
    }
    else if ([operation isEqualToString:@"/"])
    {
        if (secondOperand == 0)
        {
            self.operationError = YES;
            result = 0;
        }
        else
        {
            result = firstOperand / secondOperand;
        }
    }

    [self pushOperand:result];
    return result;
    
}

@end
