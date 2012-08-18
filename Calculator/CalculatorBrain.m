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


int iserror(double value)
{
    return (isnan(value) || isinf(value));
}

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

- (id)program
{
    return [self.programStack state];
}

- (double)performOperation:(CalculatorOperation)operation
{
    if (self.operationError) return 0;
    NSValue *operationValue = [NSValue value: &operation withObjCType:@encode(enum _CalculatorOperation)];
    [self.programStack push:operationValue];
    double result = [CalculatorBrain runProgram:self.program];
    if (iserror(result)) self.operationError = YES;
    return result;
}

+ (double)runProgram:(id)program
{
    MWStack *programStack;
    if ([program isKindOfClass:[NSArray class]]) {
        programStack = [MWStack stackWithState:program];
    }
    
    return [CalculatorBrain popOperandOffTopOfStack:programStack];
}

+ (double)popOperandOffTopOfStack:(MWStack *)programStack
{
    id topOfStack = [programStack pop];
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSValue class]]) {
        CalculatorOperation operation;
        [topOfStack getValue: &operation];
        return [CalculatorBrain performOperation:operation withStack:programStack];
    }
    return 0;
}

+ (double)performOperation:(CalculatorOperation)operation
                    withStack:(MWStack *)programStack
{
    double result;
    
    switch (operation) {
        case CalculatorAddOperation:
        case CalculatorSubtractOperation:
        case CalculatorMultiplyOperation:
        case CalculatorDivideOperation:
            [CalculatorBrain swapOperandsOnStack:programStack];
            result = [CalculatorBrain performBinaryOperation:operation withFirstOperand:[CalculatorBrain popOperandOffTopOfStack:programStack] andSecondOperand:[CalculatorBrain popOperandOffTopOfStack:programStack]];
            break;
            
        case CalculatorPiOperation:
            result = M_PI;
            break;
            
        case CalculatorCosOperation:
            result = cos([CalculatorBrain popOperandOffTopOfStack:programStack]);
            break;
            
        case CalculatorSinOperation:
            result = sin([CalculatorBrain popOperandOffTopOfStack:programStack]);
            break;
            
        case CalculatorSquareRootOperation:
            result = [CalculatorBrain performSquareRootOperation:[CalculatorBrain popOperandOffTopOfStack:programStack]];
            break;
            
        default:
            result = 0; // any unknown operation eats 0 values and calculates 0
            break;
    }
    
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

+ (double)performBinaryOperation:(CalculatorOperation)operation
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
            return firstOperand / secondOperand;
            break;
            
        default:
            return 0;
            
    }
}


+ (double)performSquareRootOperation:(double)operand
{
    return sqrt(operand);
}

// Swaps the order of the top two operands.
+ (void)swapOperandsOnStack:(MWStack *)stack
{
    double op2 = [CalculatorBrain popOperandOffTopOfStack:stack];
    double op1 = [CalculatorBrain popOperandOffTopOfStack:stack];
    [stack push:[NSNumber numberWithDouble:op2]];
    [stack push:[NSNumber numberWithDouble:op1]];
    return;
}

@end
