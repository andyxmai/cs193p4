//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Andy Mai on 4/21/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Deck.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "SetGameViewController.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UIView *cardsBoundaryView;
@property (strong, nonatomic) Grid *cardGrid;
@property (strong, nonatomic) NSMutableArray *cardViews;


@end

@implementation SetGameViewController

#define NUM_START_CARDS 12

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateCards];
}

- (void)populateCards
{
    NSUInteger counter = 0;
    for (NSUInteger i = 0; i < self.cardGrid.rowCount; i++) {
        for (NSUInteger j = 0; j < self.cardGrid.columnCount; j++) {
            CGPoint center = [self.cardGrid centerOfCellAtRow:i inColumn:j];
            CGRect frame = [self.cardGrid frameOfCellAtRow:i inColumn:j];
            SetCardView *cardView = [[SetCardView alloc] initWithFrame:frame];
            cardView.center = center;
            Card *card = [self.game cardAtIndex:counter];
            cardView.faceUp = YES;
            [self.cardsBoundaryView addSubview:cardView];
            [self.cardViews addObject:cardView];
            counter++;
        }
    }
}

- (Grid *)cardGrid {
    if (!_cardGrid) {
        _cardGrid = [[Grid alloc] init];
        _cardGrid.cellAspectRatio = 0.75;
        _cardGrid.minimumNumberOfCells = NUM_START_CARDS;
        _cardGrid.size = self.cardsBoundaryView.bounds.size;
    }
    
    return _cardGrid;
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
    NSArray *colors = @[[UIColor redColor],[UIColor greenColor],[UIColor purpleColor]];
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







/*
 Getter for game. Calls the custom init method if it has not been initialized.
 */
- (CardMatchingGame *)game
{
    if (!_game) {
        
        _game = [[CardMatchingGame alloc] initWithCardCount:NUM_START_CARDS
                                                  usingDeck:[self createDeck]];
    }
    
    return _game;
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
//    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


@end
