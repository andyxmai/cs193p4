//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Andy Mai on 4/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) Deck *deck;
@end

@implementation CardMatchingGame

/*
 Getter for property cards. Uses lazy instantiation
 */
- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

/*
 Custom init method to draw random cards from the deck
 */
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated initializer
    
    if (self) {
        self.deck = deck;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
                self.numCardsDrawn++;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (void)addThreeCards
{
    int numCardAdded = 0;
    
    while (numCardAdded < 3) {
        Card *card = [self.deck drawRandomCard];
        if (![self.cards containsObject:card]) {
            [self.cards addObject:card];
            numCardAdded++;
            self.numCardsDrawn++;
        }
    }
}

/*
 Returns the card in the specific index of the array of cards drawn
 */
- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

- (NSUInteger)indexForCard:(Card *)card
{
    if ([self.cards containsObject:card]) {
        return [self.cards indexOfObject:card];
    } else {
        return INT_MAX;
    }
}

/*
 Multipliers and constants for score keeping
 */
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

/*
 The main logic of the game. It assembles all the cards that have been chosen and calculates the scores for the matches.
 It also computes the result string that lastResultLabel will display in the UI.
 */
- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                }
            }

            self.currentCards = otherCards;
        } else {
            // match against other chosen cards
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                }
            }
            
            if ([otherCards count] == 2) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *otherCard in otherCards)
                        otherCard.matched = YES;
                    card.matched = YES;
                    self.scoreDiff = matchScore * MATCH_BONUS;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards)
                        otherCard.chosen = NO;
                    self.scoreDiff = -1 * MISMATCH_PENALTY;
                }
            } else { // Logic for handling when there aren't enough cards to check for score.
                self.scoreDiff = 0;
            }
            
            self.currentCards = otherCards;
            [self.currentCards addObject:card];
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
        }
    }
}
@end
