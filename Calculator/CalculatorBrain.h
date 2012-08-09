//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Michael Welch on 7/30/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CalculatorAddOperation,
    CalculatorSubtractOperation,
    CalculatorMultiplyOperation,
    CalculatorDivideOperation,
    CalculatorPiOperation,
    CalculatorSinOperation,
    CalculatorCosOperation,
    CalculatorSquareRootOperation,
} CalculatorOperation;



@interface CalculatorBrain : NSObject
@property (nonatomic) BOOL operationError;
- (void)reset;
- (void)pushOperand:(double)operand;
- (double)performOperation:(CalculatorOperation)operation;
@end