//
//  SetCardView.m
//  SuperCard
//
//  Created by Tom Billings on 17/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//
//  - (void)drawSquiggle:(CGRect)rect internals were inspired by Dominic Heale
//      - the original code can be found on his github at -- https://github.com/dheale
//

#import "SetCardView.h"

@implementation SetCardView
#define CORNER_RADIUS 5
#define SHAPE_H_PERCENTAGE 0.90                 // not used but equals 1 - 2 * SHAPE_BORDER_HOFFSET_PERCENTAGE
#define SHAPE_V_PERCENTAGE 0.25                 // 1 = SHAPE_V_PERCENTAGE * 3 + SHAPE_BORDER_VOFFSET_PERCENTAGE * 2 + SHAPE_INTERNAL_VOFFSET_PERCENTAGE * 2
#define SHAPE_BORDER_HOFFSET_PERCENTAGE 0.05
#define SHAPE_BORDER_VOFFSET_PERCENTAGE 0.075
#define SHAPE_INTERNAL_VOFFSET_PERCENTAGE 0.05
#define SHAPE_LINEWIDTH 4.0
#define DIAMOND_HSCALE_FACTOR 0.10
#define OVAL_HSCALE_FACTOR 0.25
#define SQUIGGLE_HSCALE_FACTOR 0.15
#define SQUIGGLE_VSCALE_FACTOR 0.10
#define SHADING_STRIPED_LINE_WIDTH_DEFAULT 0.04

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    if (self.faceUp) {
        [[UIColor lightGrayColor] setFill];
        UIRectFill(self.bounds);
    } else {
        [[UIColor whiteColor] setFill];
        UIRectFill(self.bounds);
    }
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawShapes];
}

#pragma mark - Shape Logic -

- (void)drawShapes
{
    // make rect for center rec (used as base for drawing other shapes)
    CGRect centerRect = CGRectInset(self.bounds,
                                    self.bounds.size.width * SHAPE_BORDER_HOFFSET_PERCENTAGE,
                                    self.bounds.size.height * (SHAPE_BORDER_VOFFSET_PERCENTAGE + SHAPE_V_PERCENTAGE + SHAPE_INTERNAL_VOFFSET_PERCENTAGE));
    
    if (self.number != 2) {
        //draw middle one  (i.e. number == 1,3)
        [self drawShapeInRect:centerRect];
        if (self.number == 3) {
            // offset up and draw top
            CGRect topRect = CGRectOffset(centerRect,
                                           0,
                                           -self.bounds.size.height * (SHAPE_V_PERCENTAGE + SHAPE_INTERNAL_VOFFSET_PERCENTAGE));
            [self drawShapeInRect:topRect];
            // offset down and draw bottom
            CGRect bottomRect = CGRectOffset(centerRect,
                                             0,
                                             self.bounds.size.height * (SHAPE_V_PERCENTAGE + SHAPE_INTERNAL_VOFFSET_PERCENTAGE));
            [self drawShapeInRect:bottomRect];
        }
    } else if (self.number == 2) {
        // offset a bit from corner and draw top
        CGRect topRect = CGRectOffset(centerRect,
                                       0,
                                       -self.bounds.size.height * (SHAPE_V_PERCENTAGE + SHAPE_INTERNAL_VOFFSET_PERCENTAGE) / 2.0);
        [self drawShapeInRect:topRect];
        // scoot and draw bottom
        CGRect bottomRect = CGRectOffset(topRect,
                                        0,
                                        self.bounds.size.height * (SHAPE_V_PERCENTAGE + SHAPE_INTERNAL_VOFFSET_PERCENTAGE));
        [self drawShapeInRect:bottomRect];
    }
}

- (void)drawShapeInRect:(CGRect)rect
{
    switch(self.symbol) {
        case 1:
            [self drawDiamond:rect];
            break;
        case 2:
            [self drawOval:rect];
            break;
        case 3:
            [self drawSquiggle:rect];
            break;
        default:
            [self drawDiamond:rect];
            break;
    }
}

- (UIColor *)renderColor
{
    switch(self.color) {
        case 1:
            return [UIColor colorWithRed:1.00 green:0.10 blue:0.07 alpha:1.00];
        case 2:
            return [UIColor colorWithRed:0.00 green:0.84 blue:0.32 alpha:1.00];
        case 3:
            return [UIColor colorWithRed:0.42 green:0.15 blue:0.79 alpha:1.00];
        default:            // problem if we are ever here
            return [UIColor blackColor];
    }
}

#pragma mark - Shape Implementation -

- (void)drawDiamond:(CGRect)rect
{
    UIBezierPath *diamond = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    [diamond moveToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y)];
    
    // Draw the lines.
    [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - DIAMOND_HSCALE_FACTOR), rect.origin.y + rect.size.height/2)];
    [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height)];
    [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * DIAMOND_HSCALE_FACTOR, rect.origin.y + rect.size.height/2)];
    [diamond closePath];
    
    [self pushContext];
    
    [diamond addClip];
    
    [[UIColor whiteColor] setFill];
    [[self renderColor] setStroke];
    diamond.lineWidth = SHAPE_LINEWIDTH;
    
    [diamond fill];
    [diamond stroke];
    
    [self shade:diamond];
    
    [self popContext];
}

- (void)drawOval:(CGRect)rect
{
    UIBezierPath *oval = [UIBezierPath bezierPath];
    // draw top line
    [oval moveToPoint:CGPointMake(rect.origin.x + rect.size.width * OVAL_HSCALE_FACTOR, rect.origin.y)];
    [oval addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - OVAL_HSCALE_FACTOR), rect.origin.y)];
    // draw right arc
    [oval addArcWithCenter:CGPointMake(rect.origin.x + rect.size.width * (1 - OVAL_HSCALE_FACTOR), rect.origin.y + rect.size.height / 2)
                    radius:rect.size.height / 2
                startAngle:-M_PI_2
                  endAngle:M_PI_2
                 clockwise:YES];
    // draw bottom line
    [oval addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * OVAL_HSCALE_FACTOR, rect.origin.y + rect.size.height)];
    // draw left arc
    [oval addArcWithCenter:CGPointMake(rect.origin.x + rect.size.width * OVAL_HSCALE_FACTOR, rect.origin.y + rect.size.height / 2)
                    radius:rect.size.height / 2
                startAngle:M_PI_2
                  endAngle:-M_PI_2
                 clockwise:YES];
    
    [self pushContext];
    
    [oval addClip];
    
    [[UIColor whiteColor] setFill];
    [[self renderColor] setStroke];
    oval.lineWidth = SHAPE_LINEWIDTH;
    
    [oval fill];
    [oval stroke];
    
    [self shade:oval];
    
    [self popContext];
}

- (void)drawSquiggle:(CGRect)rect
{
    UIBezierPath *squiggle = [UIBezierPath bezierPath];
    
    // p1, p2, p3, p4 form a parallogram on the border of the input rect.  they act as the anchor points for the four
    // bezier curves that will comprise a squiggle
    
    CGPoint p1, p2, p3, p4;
    p1 = CGPointMake(rect.origin.x + rect.size.width * SQUIGGLE_HSCALE_FACTOR, rect.origin.y + rect.size.height * SQUIGGLE_VSCALE_FACTOR);
    p2 = CGPointMake(rect.origin.x + rect.size.width * (1 - SQUIGGLE_HSCALE_FACTOR * 2), rect.origin.y + rect.size.height * SQUIGGLE_VSCALE_FACTOR);
    p3 = CGPointMake(rect.origin.x + rect.size.width * (1 - SQUIGGLE_HSCALE_FACTOR), rect.origin.y + rect.size.height * (1 - SQUIGGLE_VSCALE_FACTOR));
    p4 = CGPointMake(rect.origin.x + rect.size.width * SQUIGGLE_HSCALE_FACTOR * 2, rect.origin.y + rect.size.height * (1 - SQUIGGLE_VSCALE_FACTOR));
    
    CGFloat controlPointOffset = rect.size.width * SQUIGGLE_HSCALE_FACTOR;
    
    // dheale found a working solution with all control points being offset by 45 degrees which means that the x
    // and y offsets are equal.  now we just have two types of curves:
    //      - horizontal waves
    //      - vertical ends
    
    // horizontal wave: the control points for p1 is 45 degrees right and above p1
    // horizontal wave: the control points for p2 is 45 degrees left  and below p2
    
    // vertical end:    the control points for p2 is 45 degrees right and above p2
    // vertical end:    the control points for p3 is 45 degrees right and above p3
    
    // horizontal wave: the control points for p3 is 45 degrees left  and below p3
    // horizontal wave: the control points for p4 is 45 degrees right and above p4
    
    // vertical end:    the control points for p4 is 45 degrees left  and below p4
    // vertical end:    the control points for p1 is 45 degrees left  and below p1

    [squiggle moveToPoint:p1];
    // horizontal wave from p1 to p2
    [squiggle addCurveToPoint:p2
                controlPoint1:CGPointMake(p1.x + controlPointOffset, p1.y - controlPointOffset)
                controlPoint2:CGPointMake(p2.x - controlPointOffset, p2.y + controlPointOffset)];
    // vertical end from p2 to p3
    [squiggle addCurveToPoint:p3
                controlPoint1:CGPointMake(p2.x + controlPointOffset, p2.y - controlPointOffset)
                controlPoint2:CGPointMake(p3.x + controlPointOffset, p3.y - controlPointOffset)];
    // horizontal wave from p3 to p4
    [squiggle addCurveToPoint:p4
                controlPoint1:CGPointMake(p3.x - controlPointOffset, p3.y + controlPointOffset)
                controlPoint2:CGPointMake(p4.x + controlPointOffset, p4.y - controlPointOffset)];
    // vertical end from p4 to p1
    [squiggle addCurveToPoint:p1
                controlPoint1:CGPointMake(p4.x - controlPointOffset, p4.y + controlPointOffset)
                controlPoint2:CGPointMake(p1.x - controlPointOffset, p1.y + controlPointOffset)];
    [squiggle closePath];
    
    [self pushContext];
    
    [squiggle addClip];
    
    [[UIColor whiteColor] setFill];
    [[self renderColor] setStroke];
    squiggle.lineWidth = 4.0;
    
    [squiggle fill];
    [squiggle stroke];
    
    [self shade:squiggle];
    
    [self popContext];
}

- (void)pushContext
{
    CGContextSaveGState(UIGraphicsGetCurrentContext());
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)shade:(UIBezierPath *)shape
{
    [self pushContext];
    switch(self.shading) {
        case 1: // open fill done by default
            break;
        case 2: // striped fill
            [self fillBezier:shape withVerticalLineSpacing:SHADING_STRIPED_LINE_WIDTH_DEFAULT];
            break;
        case 3: // solid fill
            [[self renderColor] setFill];
            [shape fill];
            break;
        default:
            // open fill do nothing
            break;
    }
    [self popContext];
}

- (void)fillBezier:(UIBezierPath *)shape withHorizontalLineSpacing:(float)percentage
{
    [self pushContext];         // save current state
    
    shape.lineWidth = shape.lineWidth/5;
    
    int stepSize = (int) shape.bounds.size.height * SHADING_STRIPED_LINE_WIDTH_DEFAULT * 2;
    
    [shape addClip];            // only fill space within shape with lines
    if (percentage > 0 && percentage < 1.0) {
        stepSize = (int) shape.bounds.size.height * percentage;
    }
    
    for (int y = 0; y < shape.bounds.size.height; y += stepSize) {
        [shape moveToPoint:CGPointMake(0, y)];
        [shape addLineToPoint:CGPointMake(shape.bounds.size.width, y)];
    }
    
    [shape stroke];
    
    [self popContext];          // return everything to normal
}

- (void)fillBezier:(UIBezierPath *)shape withVerticalLineSpacing:(float)percentage
{
    [self pushContext];         // save current state
    
    shape.lineWidth = shape.lineWidth/5;
    
    int stepSize = (int) shape.bounds.size.width * SHADING_STRIPED_LINE_WIDTH_DEFAULT;
    
    [shape addClip];            // only fill space within shape with lines
    if (percentage > 0 && percentage < 1.0) {
        stepSize = (int) shape.bounds.size.width * percentage;
    }
    
    for (int x = 0; x < shape.bounds.size.width; x += stepSize) {
        [shape moveToPoint:CGPointMake(x, 0)];
        [shape addLineToPoint:CGPointMake(x, shape.bounds.size.height)];
    }
    
    [shape stroke];
    
    [self popContext];          // return everything to normal
}

#pragma mark - Setters -

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Initialization -

- (void)setup
{
    // do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
