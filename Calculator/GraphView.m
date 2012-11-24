//
//  GraphView.m
//  Calculator
//
//  Created by Michael Welch on 11/23/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"



@implementation GraphView
@synthesize origin = _origin;
@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

- (void)setup
{
    self.scale = 20.0;
    self.origin = CGPointMake(160,252);
}

- (void)setScale:(float)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)setOrigin:(CGPoint)origin
{
    if (!CGPointEqualToPoint(origin, _origin)) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (float) convertToXValueForXPoint:(float)xPoint
{
    return (xPoint - self.origin.x) / self.scale;
}

- (float) convertToYPointForYValue:(float)yValue
{
    return self.origin.y - yValue * self.scale;
}


- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
        [self setNeedsDisplay];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.origin = [gesture locationInView:self];
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        float scale = [gesture scale];
        self.scale *= scale;
        [gesture setScale:1.0];
        [self setNeedsDisplay];
    }
}

- (void)addPointToGraphWithX:(CGFloat)x Y:(CGFloat)y fromPreviousYValue:(CGFloat)prevY withContext:(CGContextRef)context
{
    // If new y value isn't a graphable number, just return
    if (isnan(y) || isinf(y)) return;
    
    if (isnan(prevY) || isinf(prevY)) {
        // Then just add p as a point
        CGContextMoveToPoint(context, x, y);
    } else {
        // Add Line to Point
        CGContextAddLineToPoint(context, x, y);
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor blueColor] setStroke];
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];

    int xPixel;
    CGFloat x;
    CGFloat xUnit;
    
    CGFloat yUnit;
    CGFloat y;
    CGFloat prevY = NAN;
    
    for (xPixel = 0; xPixel < self.bounds.size.width * self.contentScaleFactor; xPixel++)
    {
        x = xPixel / self.contentScaleFactor;
        xUnit = [self convertToXValueForXPoint:x];
        yUnit = [self.dataSource getYValueForXValue:xUnit];
        y = [self convertToYPointForYValue:yUnit];
        
        [self addPointToGraphWithX:x Y:y fromPreviousYValue:prevY withContext:context];
        prevY = y;
    }
    CGContextDrawPath(context, kCGPathStroke);
    
}


@end
