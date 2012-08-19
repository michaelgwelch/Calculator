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

NSString *getOperationSymbol(CalculatorOperation operation)
{
    switch (operation) {
        case CalculatorAddOperation:
            return @"+";
            break;
            
        case CalculatorSubtractOperation:
            return @"-";
            break;
            
        case CalculatorMultiplyOperation:
            return @"*";
            break;
            
        case CalculatorDivideOperation:
            return @"/";
            
        case CalculatorCosOperation:
            return @"cos";
            
        case CalculatorPiOperation:
            return @"pi";
            
        case CalculatorSinOperation:
            return @"sin";
            
        case CalculatorSquareRootOperation:
            return @"sqrt";
            
        default:
            break;
    }
    
    return @"";
    
}

NSString *parenthesizeForMultiplicationOrDivisionIfNeeded(NSArray *descriptionArray)
{
    NSString *description = [descriptionArray objectAtIndex:1];
    id operationValue = [descriptionArray objectAtIndex:0];
    BOOL parenthesize = NO;
    
    if ([operationValue isKindOfClass:[NSValue class]]) {
        CalculatorOperation operation;
        [operationValue getValue:&operation];
        parenthesize = (operation == CalculatorAddOperation || operation == CalculatorSubtractOperation);
    }

    if (parenthesize) {
        return [NSString stringWithFormat:@"(%@)", description];
    }
    
    return description;
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
        return [CalculatorBrain performOperation:operation withOperandsFromStack:programStack];
    }
    return 0;
}

+ (double)performOperation:(CalculatorOperation)operation
    withOperandsFromStack:(MWStack *)programStack
{
    double result;
    
    switch (operation) {
            
        case CalculatorAddOperation:
        case CalculatorMultiplyOperation:
        case CalculatorSubtractOperation:
        case CalculatorDivideOperation:
        {
            double op2 = [CalculatorBrain popOperandOffTopOfStack:programStack];
            double op1 = [CalculatorBrain popOperandOffTopOfStack:programStack];
            result = [CalculatorBrain performBinaryOperation:operation
                                            withFirstOperand:op1
                                            andSecondOperand:op2];
            break;
        }
            
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
            result = sqrt([CalculatorBrain popOperandOffTopOfStack:programStack]);
            break;
            
        default:
            result = 0; // any unknown operation eats 0 values and calculates 0
            break;
    }
    
    return result;
    
}

+ (NSString *)descriptionOfProgram:(id)program
{
    MWStack *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [MWStack stackWithState:[program mutableCopy]];
    }
    
    NSString *programString = @"";
    BOOL firstEntry = YES;
    while (!stack.isEmpty) {
        if (firstEntry) {
            firstEntry = NO;
        } else {
            programString = [@", " stringByAppendingString:programString];
        }
        programString = [[[CalculatorBrain descriptionOfTopOfStack:stack] objectAtIndex:1]
                         stringByAppendingString:programString];
    }
    return programString;
}

// Returns a two element array. The first element is the operation encoded as NSValue
// of the top level operation (if the top is an operation), else the first element is
// empty string.
// The second is the actual description
+ (NSArray *)descriptionOfTopOfStack:(MWStack *)stack
{
    id element = [stack pop];
    if ([element isKindOfClass:[NSNumber class]]) {
        return @[@"",[NSString stringWithFormat:@"%g", [element doubleValue]]];
    } else if ([element isKindOfClass:[NSValue class]]) {
        CalculatorOperation operation;
        [element getValue:&operation];
        return [CalculatorBrain descriptionOfOperation:operation withOperandsFromStack:stack];
    }
    return @[@"", @"0"];
}

// Returns a two element array. The first element is the operation encoded as NSValue
// The second is the actual description.
+ (NSArray *)descriptionOfOperation:(CalculatorOperation)operation
               withOperandsFromStack:(MWStack *)stack
{
    switch (operation) {
        case CalculatorAddOperation:
        case CalculatorSubtractOperation:
        {
            NSString *descriptionOfOperation = getOperationSymbol(operation);
            NSString *descriptionOfOperand2 = [[CalculatorBrain descriptionOfTopOfStack:stack] objectAtIndex:1];
            NSString *descriptionOfOperand1 = [[CalculatorBrain descriptionOfTopOfStack:stack] objectAtIndex:1];
            return @[[NSValue value:&operation withObjCType:@encode(enum _CalculatorOperation)],[NSString stringWithFormat:@"%@ %@ %@", descriptionOfOperand1, descriptionOfOperation, descriptionOfOperand2]];
            break;
        }
 
        case CalculatorMultiplyOperation:
        case CalculatorDivideOperation:
        {
            NSString *descriptionOfOperation = getOperationSymbol(operation);
            NSArray *descriptionArrayOfOperand2 = [CalculatorBrain descriptionOfTopOfStack:stack];
            NSString *descriptionOfOperand2 = parenthesizeForMultiplicationOrDivisionIfNeeded(descriptionArrayOfOperand2);
            NSArray *descriptionArrayOfOperand1 = [CalculatorBrain descriptionOfTopOfStack:stack];
            NSString *descriptionOfOperand1 = parenthesizeForMultiplicationOrDivisionIfNeeded(descriptionArrayOfOperand1);
            return @[[NSValue value:&operation withObjCType:@encode(enum _CalculatorOperation)],[NSString stringWithFormat:@"%@ %@ %@", descriptionOfOperand1, descriptionOfOperation, descriptionOfOperand2]];
            break;
        }
            
        case CalculatorCosOperation:
        case CalculatorSinOperation:
        case CalculatorSquareRootOperation:
        {
            NSString *descriptionOfOperation = getOperationSymbol(operation);
            NSString *descriptionOfOperand = [[CalculatorBrain descriptionOfTopOfStack:stack] objectAtIndex:1];
            return @[[NSValue value:&operation withObjCType:@encode(enum _CalculatorOperation)],[NSString stringWithFormat:@"%@(%@)", descriptionOfOperation, descriptionOfOperand]];
        }
            
        case CalculatorPiOperation:
            return @[[NSValue value:&operation withObjCType:@encode(enum _CalculatorOperation)], @"π"];

        default:
            break;
    }
    return @[@"", @""];
    
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


@end
