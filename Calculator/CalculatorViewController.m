//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Welch on 7/28/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
 
@property (nonatomic) BOOL userIsInMiddleOfEnteringNumber;
@property (nonatomic, strong) NSMutableArray *stack;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInMiddleOfEnteringNumber = _userIsInMiddleOfEnteringNumber;
@synthesize stack = _stack;


- (void) setStack:(NSMutableArray *)stack
{
    _stack = stack;
}

- (NSMutableArray *) stack
{
    if (!_stack) [self setStack:[[NSMutableArray alloc] init]];
    return _stack;
}

- (void) push: (double) value
{
    [self.stack addObject:[NSNumber numberWithDouble:value]];
}

- (double) pop
{
    double value = [[self.stack lastObject] doubleValue];
    [self.stack removeLastObject];
    return value;
}

- (IBAction)digitPressed:(UIButton *)sender
{
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
    self.userIsInMiddleOfEnteringNumber = NO;
    double value = [self.display.text doubleValue];
    [self push:value];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInMiddleOfEnteringNumber) [self enterPressed];
    
    NSString *operation = sender.currentTitle;
    double op1 = [self pop];
    double op2 = [self pop];
    double result;
    
    if ([operation isEqualToString:@"*"])
    {
        result = op1 * op2;
    }
    else if ([operation isEqualToString:@"/"])
    {
        
    }
    
    [self push:result];
    self.display.text = [[NSNumber numberWithDouble:result] stringValue];
    
}



@end
