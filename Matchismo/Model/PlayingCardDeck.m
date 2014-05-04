//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Andy Mai on 4/6/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

/*
 Custom init method. It adds all possible rank-suit card combination to a deck and
 returns it.
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
