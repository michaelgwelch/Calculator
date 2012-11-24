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
@synthesize panGesture = _panGesture;
@synthesize pinchGesture = _pinchGesture;
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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor blueColor] setStroke];
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];

    int xPixel = 0;
    int x = xPixel / self.contentScaleFactor;
    float xUnit = [self convertToXValueForXPoint:x];
    
    float yUnit = [self.dataSource getYValueForXValue:xUnit];
    float y = [self convertToYPointForYValue:yUnit];
    CGContextMoveToPoint(context, x, y);
    
    for (xPixel = 1; xPixel < self.bounds.size.width * self.contentScaleFactor; xPixel++)
    {
        x = xPixel / self.contentScaleFactor;
        xUnit = [self convertToXValueForXPoint:x];
        yUnit = [self.dataSource getYValueForXValue:xUnit];
        y = [self convertToYPointForYValue:yUnit];
        CGContextAddLineToPoint(context, x, y);
    }
    CGContextDrawPath(context, kCGPathStroke);
    
}


@end
