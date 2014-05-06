//
//  CardView.m
//  Matchismo
//
//  Created by Andy Mai on 5/4/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardView.h"

@interface CardView()
@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation CardView

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

-(void) drawRoundedRect:(CGRect)rect fillColor:(UIColor *)color{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [color setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}


- (void)drawRect:(CGRect)rect
{
    [self drawRoundedRect:rect fillColor:[UIColor whiteColor]];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setMatched:(BOOL)matched
{
    _matched = matched;
    [self setNeedsDisplay];
}

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


@end
