//
//  MWStack.h
//  Calculator
//
//  Created by Michael Welch on 8/9/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWStack : NSObject
- (NSArray *)state;
+ (MWStack *)stackWithState:(NSArray *)state;
- (void)push:(id)object;
- (id)pop;
- (void)clear;
- (id)init;
@end
