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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.faceUp) {
        NSString *imageName = [NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit];
        UIImage *faceImage = [UIImage imageNamed:imageName];
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds,
                                           self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                           self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        }else {
            NSLog(@"Draw pips");
            [self drawPips];
        }
        [self drawCorners];
    } else {
        UIImage *cardBackImage = [UIImage imageNamed:@"cardback"];
        CGRect imageRect = CGRectInset(self.bounds,
                                       self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                       self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
        [cardBackImage drawInRect:imageRect];
    }

}

- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    paragraphStyle.paragraphSpacingBefore = - cornerFont.pointSize * CORNER_LINE_SPACING_REDUCTION;
    
    NSString *rank = [self rankAsString];
    NSString *suit = self.suit;
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", rank, suit] attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont }];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

-(void)drawSquiggle:(CGPoint)origin width:(int)width height:(int)height
{
    UIBezierPath *squigglePath = [UIBezierPath bezierPath];
    [squigglePath moveToPoint:origin];
    CGPoint topControlPoint1 = CGPointMake(origin.x + width/3.0, origin.y-height/2.0);
    CGPoint bottomControlPoint1 = CGPointMake(origin.x + 2*width/3.0, origin.y+height/2.0+height);
    CGPoint topControlPoint2 = CGPointMake(origin.x + 2*width/3.0, origin.y+height/2.0);
    CGPoint bottomControlPoint2 = CGPointMake(origin.x + width/3.0, origin.y-height/2.0+height);
    [squigglePath addCurveToPoint:CGPointMake(origin.x+width, origin.y) controlPoint1: topControlPoint1 controlPoint2:topControlPoint2];
    [squigglePath addLineToPoint:CGPointMake(origin.x+width, origin.y+height)];
    [squigglePath addCurveToPoint:CGPointMake(origin.x, origin.y+height) controlPoint1:bottomControlPoint1 controlPoint2:bottomControlPoint2];
    [squigglePath closePath];
    squigglePath.lineWidth = 2;
    [squigglePath stroke];
}


-(void)drawDiamond:(CGPoint)origin width:(int)width height:(int)height
{
    UIBezierPath *squigglePath = [UIBezierPath bezierPath];
    [squigglePath moveToPoint:origin];
    [squigglePath addLineToPoint:CGPointMake(origin.x+width/2.0, origin.y-height/2.0)];
    [squigglePath addLineToPoint:CGPointMake(origin.x+width, origin.y)];
    [squigglePath addLineToPoint:CGPointMake(origin.x+width/2.0, origin.y+height/2.0)];
    [squigglePath closePath];
    squigglePath.lineWidth = 2;
    [squigglePath stroke];
}

-(void)drawOval:(CGPoint)origin width:(int)width height:(int)height
{
    UIBezierPath *squigglePath = [UIBezierPath bezierPath];
    [squigglePath moveToPoint:origin];
    [squigglePath addLineToPoint:CGPointMake(origin.x+width-height, origin.y)];
    
    [squigglePath addArcWithCenter:CGPointMake(origin.x+width-height, origin.y+height/2.0) radius:height/2.0 startAngle:3.0*M_PI/2.0 endAngle:M_PI/2.0 clockwise:true];
    [squigglePath addLineToPoint:CGPointMake(origin.x, origin.y+height)];
    [squigglePath addArcWithCenter:CGPointMake(origin.x, origin.y+height/2.0) radius:height/2.0 startAngle:M_PI/2.0 endAngle:3.0*M_PI/2.0 clockwise:true];
    squigglePath.lineWidth = 2;
    [squigglePath stroke];
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

- (NSString *)rankAsString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

#pragma mark - Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270
#define PIP_FONT_SCALE_FACTOR 0.015

- (void)drawPips
{
    [self drawSquiggle:CGPointMake(10, 10) width:20 height:10];
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

- (void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
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
