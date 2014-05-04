//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Andy Mai on 4/5/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation CardGameViewController

/*
 Getter for game. Calls the custom init method if it has not been initialized.
 */
- (CardMatchingGame *)game
{
    if (!_game) {
        
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    }
    
    return _game;
}

/*
 Creates the deck by calling the custom init method PlayingCardDeck.
 */
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

/*
 Button event for the left Card
 */
- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

/*
 Button action to redeal and reset the game
 */
- (IBAction)redealButton:(UIButton *)sender
{
    self.game = nil;
    [self updateUI];
  }

/*
 Updates the UI to reflect which cards have been flipped and matched.
 It also sets the texts of the labels.
 */
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

/*
 Returns the attributed string used to display as the result of the last (mis)match
 */
- (NSMutableAttributedString *)getLastResultString
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *currentCards = [self combineCardContents:self.game.currentCards];
    
    if (self.game.scoreDiff == 0) {
        result = currentCards;
    } else if (self.game.scoreDiff < 0) {
        [result appendAttributedString:currentCards];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"don't match! %d points penalty!",-1*self.game.scoreDiff]]];
        
        self.game.scoreDiff = 0;
    } else {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
        [result appendAttributedString:currentCards];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"for %d points",self.game.scoreDiff]]];
    }
    
    return result;
}

/*
 Helper method to concatent the contents of an array of cards
 */
- (NSMutableAttributedString *)combineCardContents:(NSArray *)otherCards
{
    NSMutableAttributedString *cardContents = [[NSMutableAttributedString alloc] init];
    
    for (Card *card in otherCards) {
        [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:card.contents]];
        [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    return cardContents;
}


/*
 Helper method to set the title for each card for UI
 */
- (NSAttributedString *)titleForCard:(Card *)card
{
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if (card.isChosen) {
        [title appendAttributedString:[[NSAttributedString alloc] initWithString:card.contents]];
    }
    
    return title;
}

/*
 Helper method to set the background image for each card
 */
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
