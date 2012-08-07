//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Michael Welch on 7/30/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>




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

- (double)performBinaryOperation:(CalculatorOperation)operation
                withFirstOperand:(double)firstOperand
                andSecondOperand:(double)secondOperand
{
    switch (operation) {
        case CalculatorAddOperation:
            return firstOperand + secondOperand;
            break;
            
        case CalculatorSubtractOperation:
            return firstOperand - secondOperand;
            break;
            
        case CalculatorMultiplyOperation:
            return firstOperand * secondOperand;
            break;
            
        case CalculatorDivideOperation:
            if (secondOperand == 0) {
                self.operationError = YES;
                return 0;
            }
            return firstOperand / secondOperand;
            break;
            
        default:
            return 0;
            
    }
}


- (double)performSquareRootOperation:(double)operand
{
    double result;
    if (operand < 0)
    {
        result = 0;
        self.operationError = YES;
    }
    else
    {
        result = sqrt(operand);
    }
    return result;
}

// Swaps the order of the top two operands.
- (void)swapOperands
{
    double op2 = [self popOperand];
    double op1 = [self popOperand];
    [self pushOperand:op2];
    [self pushOperand:op1];
    return;
}

///////////////////////// Interface Implementation //////////////////

- (void)pushOperand:(double)operand
{
    if (self.operationError) return;
    
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}


- (double)performOperation:(CalculatorOperation)operation
{
    if (self.operationError) return 0;
    
    double result;
    
    switch (operation) {
        case CalculatorAddOperation:
        case CalculatorSubtractOperation:
        case CalculatorMultiplyOperation:
        case CalculatorDivideOperation:
            [self swapOperands];
            result = [self performBinaryOperation:operation withFirstOperand:[self popOperand] andSecondOperand:[self popOperand]];
            break;
            
        case CalculatorPiOperation:
            result = M_PI;
            break;
            
        case CalculatorCosOperation:
            result = cos([self popOperand]);
            break;
            
        case CalculatorSinOperation:
            result = sin([self popOperand]);
            break;
            
        case CalculatorSquareRootOperation:
            [self performSquareRootOperation:[self popOperand]];
            break;
            
        default:
            result = 0; // any unknown operation eats 0 values and calculates 0
            break;
    }
    
    [self pushOperand:result];
    return result;
    
}

@end
