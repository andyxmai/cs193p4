//
//  Deck.m
//  Matchismo
//
//  Created by Andy Mai on 4/6/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

/*
 Private property that contains all the cards in the current state of deck.
 */
- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

/*
 Adds a card to the deck. A boolean atTop dictates whether to add it on top or not.
 */
- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

/*
 Adds the card to the deck
 */
- (void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

/*
 Draws a random card from the deck. Returns that card and removes from the NSMutableArray cards
 */
- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if ([self.cards count]) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

@end
