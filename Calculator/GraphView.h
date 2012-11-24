//
//  GraphView.h
//  Calculator
//
//  Created by Michael Welch on 11/23/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphDataSource <NSObject>

- (float)getYValueForXValue:(float)x;

@end

@interface GraphView : UIView

@property (nonatomic) CGPoint origin;
@property (nonatomic) float scale;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic,weak) id <GraphDataSource> dataSource;

@end
