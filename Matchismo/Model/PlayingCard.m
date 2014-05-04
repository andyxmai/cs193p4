//
//  PlayingCard.m
//  Matchismo
//
//  Created by Andy Mai on 4/6/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

/*
 Calculates the score for the cards that are drawn. It returns a score for the appropriate matches.
 The logic only works for 2-card and 3-card modes.
 */
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = 4;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        }
    } else if ([otherCards count] == 2) {
        PlayingCard *firstCard = [otherCards firstObject];
        PlayingCard *secondCard = [otherCards lastObject];
        if (self.rank == firstCard.rank && self.rank == secondCard.rank) {
            score = 10;
        } else if ([self.suit isEqualToString:firstCard.suit] && [self.suit isEqualToString:secondCard.suit]) {
            score = 6;
        } else if (self.rank == firstCard.rank || self.rank == secondCard.rank || firstCard.rank == secondCard.rank) {
            score = 4;
        } else if ([self.suit isEqualToString:firstCard.suit] || [self.suit isEqualToString:secondCard.suit] || [firstCard.suit isEqualToString:secondCard.suit]) {
            score = 1;
        }
    }
    
    return score;
}

/*
 Returns the content of the card, which is an NSString for the rank and suit
 */
- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize  suit = _suit;

/*
 A static array of all possible suits
 */
+ (NSArray *)validSuits
{
    return @[@"♠",@"♥",@"♣",@"♦"];
}

/*
 Setter for the PlayingCard suit. It checks to see if the suit is one of the four valid suits.
 */
- (void)setSuits:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

/*
 Getter for PlayingCard suit. Returns "?" if no suit has been set
 */
-(NSString *)suit
{
    return _suit ? _suit : @"?";
}

/*
 All possible ranks of cards
 */
+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
             @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

/*
 Returns the highest rank possible
 */
+ (NSUInteger)maxRank { return [[self rankStrings] count]-1; }

/*
 Setter for rank. It checks whether the rank passed in is less than the max.
 */
- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
