//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Andy Mai on 5/4/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;

@end


@implementation SetCardView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
#define CORNER_LINE_SPACING_REDUCTION 0.25
#define STRIPE_INTERVAL 3.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

#pragma mark Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
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

/*
 Getting colors: 0 - Green, 1 - Red, 2 - Purple
 */
- (UIColor *) getColor{
    if([self.color integerValue] == 0) return [UIColor greenColor];
    else if ([self.color integerValue] == 1) return [UIColor redColor];
    else{
        return [UIColor purpleColor];
    }
}

/* Draws rect for set cards. It modifies the super method */
- (void)drawRect:(CGRect)rect
{
    if (self.faceUp) [super drawRect:rect];
    else{
        [super drawRoundedRect:rect fillColor:[UIColor grayColor]];
    }
    [self drawCorners];
    [self drawShapes];
}

/* Draws corners for set cards */
- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    paragraphStyle.paragraphSpacingBefore = - cornerFont.pointSize * CORNER_LINE_SPACING_REDUCTION;
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@""] attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont }];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

/* Adds strips for the shading of the card */
-(void)addStripes:(UIBezierPath*)currentPath{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextSetLineWidth(currentContext, 0.5);
    [currentPath addClip];
    CGFloat minX = CGRectGetMinX(currentPath.bounds);
    CGFloat maxX = CGRectGetMaxX(currentPath.bounds);
    CGFloat maxY = CGRectGetMaxY(currentPath.bounds);
    for(double x = minX; x < maxX; x+=STRIPE_INTERVAL){
        CGContextMoveToPoint(currentContext, x, 0.0);
        CGContextAddLineToPoint(currentContext, x, maxY);
    }
    CGContextStrokePath(currentContext);
    CGContextRestoreGState(currentContext);
}

/* Fills the set card for shading */
-(void) addShading:(UIBezierPath *)path{
    if([self.shade integerValue] == 2){
        [[self getColor] setFill];
        [path fill];
    }
    else if([self.shade integerValue] == 1) [self addStripes:path];
}

/* Draws the shape */
-(void) drawShapeBorder:(UIBezierPath *)path{
    path.lineWidth = 2;
    [[self getColor] setStroke];
    [path stroke];
    [self addShading:path];
}

//0 is no fill, 1 is stripes, 2 is filled
-(void)drawSquiggle:(CGPoint)origin width:(double)width height:(double)height
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    CGPoint topControlPoint1 = CGPointMake(origin.x + width/3.0, origin.y-height/2.0);
    CGPoint bottomControlPoint1 = CGPointMake(origin.x + 2*width/3.0, origin.y+height/2.0+height);
    CGPoint topControlPoint2 = CGPointMake(origin.x + 2*width/3.0, origin.y+height/2.0);
    CGPoint bottomControlPoint2 = CGPointMake(origin.x + width/3.0, origin.y-height/2.0+height);
    [path addCurveToPoint:CGPointMake(origin.x+width, origin.y) controlPoint1: topControlPoint1 controlPoint2:topControlPoint2];
    [path addLineToPoint:CGPointMake(origin.x+width, origin.y+height)];
    [path addCurveToPoint:CGPointMake(origin.x, origin.y+height) controlPoint1:bottomControlPoint1 controlPoint2:bottomControlPoint2];
    [path closePath];
    [self drawShapeBorder:path];
    [self addShading:path];
}

/* Draws the diamond */
-(void)drawDiamond:(CGPoint)origin width:(double)width height:(double)height
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    [path addLineToPoint:CGPointMake(origin.x+width/2.0, origin.y-height/2.0)];
    [path addLineToPoint:CGPointMake(origin.x+width, origin.y)];
    [path addLineToPoint:CGPointMake(origin.x+width/2.0, origin.y+height/2.0)];
    [path closePath];
    [self drawShapeBorder:path];
    [self addShading:path];
}

/* Draws the oval */
-(void)drawOval:(CGPoint)origin width:(double)width height:(double)height
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    [path addLineToPoint:CGPointMake(origin.x+width-height, origin.y)];
    
    [path addArcWithCenter:CGPointMake(origin.x+width-height, origin.y+height/2.0) radius:height/2.0 startAngle:3.0*M_PI/2.0 endAngle:M_PI/2.0 clockwise:true];
    [path addLineToPoint:CGPointMake(origin.x, origin.y+height)];
    [path addArcWithCenter:CGPointMake(origin.x, origin.y+height/2.0) radius:height/2.0 startAngle:M_PI/2.0 endAngle:3.0*M_PI/2.0 clockwise:true];
    [self drawShapeBorder:path];
    [self addShading:path];
}

//Squiggle = 0, oval = 1, diamond = 2,
-(void)drawShapes
{
    double shapeHeight = self.bounds.size.height/6.0;
    double shapeWidth = self.bounds.size.width/2.0;
    double numShapes = [self.count integerValue]+1;
    double spacingHeight = (self.bounds.size.height-shapeHeight*numShapes)/(numShapes+1);
    int shapeNumber = [self.shape integerValue];
    for(int i = 0; i < numShapes; i++){
        CGPoint origin = CGPointMake((self.bounds.size.width-shapeWidth)/2, (i+1)*spacingHeight+i*shapeHeight);
        if(shapeNumber == 0) [self drawSquiggle: origin width:shapeWidth height:shapeHeight];
        else if(shapeNumber == 1){
            origin.x += shapeHeight/2.0;
            [self drawOval: origin width:shapeWidth height:shapeHeight];
        }
        else{
            origin.y += shapeHeight/2.0;
            [self drawDiamond: origin width:shapeWidth height:shapeHeight];
        }
    }
}



- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark Gestures

- (void)resizeFaceWithPinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

#pragma mark Properties

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setShape:(NSNumber *)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
