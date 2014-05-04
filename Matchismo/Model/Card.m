//
//  Card.m
//  Matchismo
//
//  Created by Andy Mai on 4/6/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Card.h"

@implementation Card

/*
 Check to see if the itself (a Card) matches to other cards in a deck.
 */
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score += 1;
        }
    }
    
    return score;
}

@end
