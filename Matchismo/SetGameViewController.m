//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Andy Mai on 4/21/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetGameViewController.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}

/*
 Creates the deck by calling the custom init method PlayingCardDeck.
 */
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

/*
 Helper method to set the title for each card for UI
 */
- (NSAttributedString *)titleForCard:(Card *)card
{
    SetCard *setCard = (SetCard *)card;
   
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[self getFigureWithShapeIndex:setCard.shape numShapes:setCard.count] attributes:@{NSForegroundColorAttributeName:[[self getColorWithIndex:setCard.color] colorWithAlphaComponent:[self getShadeWithIndex:setCard.shade]]}];

    return title;
    
}

/*
 Helper method to set the background image for each card
 */
- (UIImage *)backgroundImageForCard:(Card *)card
{
    if (card.isChosen) {
        return [UIImage imageNamed:@"cardfrontselected"];
    } else {
        return [UIImage imageNamed:@"cardfront"];
    }
}

/*
 Returns the appropriate figure given the index
 */
- (NSString *)getFigureWithShapeIndex:(NSNumber *)shapeIndex numShapes:(NSNumber *)num
{
    NSString *figure = @"";
    NSArray *shapes = @[@"●",@"■",@"▲"];
    NSString *shape = shapes[[shapeIndex intValue]];
    
    for (int i = 0; i < [num intValue]+1; i++) {
        figure = [figure stringByAppendingString:shape];
    }
    
    return figure;
}

/*
 Returns the appropriate color given the index
 */
- (UIColor *)getColorWithIndex:(NSNumber *)index
{
    NSArray *colors = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]];
    UIColor *color = colors[[index intValue]];
    
    return color;
}

/*
 Returns the appropriate shade given the index
 */
-(CGFloat)getShadeWithIndex:(NSNumber *)index
{
    NSArray *shades = @[[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:1.0]];
    
    CGFloat shade = [shades[[index intValue]] floatValue];
    
    return shade;
}

/*
 Helper method to concatent the contents of an array of cards
 */
- (NSMutableAttributedString *)combineCardContents:(NSArray *)otherCards
{
    NSMutableAttributedString *cardContents = [[NSMutableAttributedString alloc] init];
    
    for (Card *card in otherCards) {
        [cardContents appendAttributedString:[self titleForCard:card]];
        [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    return cardContents;
}

@end
