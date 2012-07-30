//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Michael Welch on 7/30/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CalculatorBrain : NSObject
@property (nonatomic) BOOL operationError;
- (void)reset;
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
@end
