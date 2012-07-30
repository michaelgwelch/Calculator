//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Welch on 7/28/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
 
@property (nonatomic) BOOL userIsInMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;


@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInMiddleOfEnteringNumber = _userIsInMiddleOfEnteringNumber;
@synthesize brain = _brain;


- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    if (self.brain.operationError) return;
    
    NSString *currentDisplay = self.display.text;
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInMiddleOfEnteringNumber)
    {
        currentDisplay = [currentDisplay stringByAppendingFormat:@"%@",digit];
    }
    else
    {
        currentDisplay = digit;
        self.userIsInMiddleOfEnteringNumber = YES;
    }
    
    self.display.text = currentDisplay;
}

- (IBAction)enterPressed
{
    if (self.brain.operationError) return;
    
    self.userIsInMiddleOfEnteringNumber = NO;
    double value = [self.display.text doubleValue];
    [self.brain pushOperand:value];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.brain.operationError) return;
    if (self.userIsInMiddleOfEnteringNumber) [self enterPressed];
    
    double result = [self.brain performOperation:sender.currentTitle];
    if (self.brain.operationError)
    {
        self.display.text = @"Error";
    }
    else
    {
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
    
}

- (IBAction)clearPressed
{
    [self.brain reset];
    self.display.text = @"0";
}



@end
