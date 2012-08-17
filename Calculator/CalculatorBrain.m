//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Michael Welch on 7/30/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>
#import "MWStack.h"



@interface CalculatorBrain()

@property (nonatomic,strong,readonly) MWStack *programStack;

@end



@implementation CalculatorBrain


///////////////////////// Public Interface Implementation //////////////////

- (void)reset
{
    self.operationError = NO;
    [self.programStack clear];
}

- (void)pushOperand:(double)operand
{
    if (self.operationError) return;
    
    [self.programStack push:[NSNumber numberWithDouble:operand]];
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
            result = [self performSquareRootOperation:[self popOperand]];
            break;
            
        default:
            result = 0; // any unknown operation eats 0 values and calculates 0
            break;
    }
    
    [self pushOperand:result];
    return result;
    
}

//////////////////////// Private Implementation ///////////////////

@synthesize programStack = _programStack;


- (MWStack *)programStack
{
    if (!_programStack) {
        _programStack = [[MWStack alloc] init];
    }
    
    return _programStack;
}

- (double) popOperand
{
    NSNumber *operandObject = [self.programStack pop];
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

@end
