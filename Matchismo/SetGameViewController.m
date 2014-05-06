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
@property (strong, nonatomic) NSMutableArray *cardViews;

@property (weak, nonatomic) IBOutlet UIView *cardsBoundaryView;
//@property (strong, nonatomic) Grid *cardGrid;
//@property (strong, nonatomic) NSMutableArray *cardViews;


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
    //NSLog(@"populate cards");
    //NSLog(@"%@",[NSString stringWithFormat:@"%d, %d, %d",self.cardGrid.minimumNumberOfCells, self.cardGrid.rowCount, self.cardGrid.columnCount]);
    
    [self removeAllCardViews];
    NSUInteger counter = 0;
    NSUInteger row = 0;
    NSUInteger col = 0;
    
    while (counter < [self.cardViews count]) {
        Card *card = [self.game cardAtIndex:counter];
        if (!card.isMatched) {
            if (col == self.cardGrid.columnCount) {
                row++;
                col = 0;
            }
            
            CGPoint center = [self.cardGrid centerOfCellAtRow:row inColumn:col];
            CGRect frame = [self.cardGrid frameOfCellAtRow:row inColumn:col];

            SetCardView *cardView = [self.cardViews objectAtIndex:counter];
            cardView.center = center;
            cardView.frame = frame;
            
            [self.cardsBoundaryView addSubview:cardView];
            col++;
        } else {
            //NSLog(@"%@",[NSString stringWithFormat:@"%d",counter]);
        }
    
        counter++;
    }
}

- (IBAction)dealCards:(UIButton *)sender {
    NSLog(@"deal");
    [self.game addThreeCards];
    
    for (NSUInteger i = 0; i < 3; i++) {
        Card *card = [self.game cardAtIndex:(self.game.numCardsDrawn-1-i)];
        SetCardView *cardView = [[SetCardView alloc] init];
        SetCard *setCard = (SetCard *)card;
        cardView.shade = setCard.shade;
        cardView.shape = setCard.shape;
        cardView.color = setCard.color;
        cardView.count = setCard.count;
        cardView.faceUp = !card.isChosen;
        
        UITapGestureRecognizer *singleTapCardGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCardWithTouch:)];
        [singleTapCardGestureRecognizer setNumberOfTouchesRequired:1];
        [cardView addGestureRecognizer:singleTapCardGestureRecognizer];
        
        [self.cardViews addObject:cardView];
    }
    
    self.cardGrid.minimumNumberOfCells += 3;
    [self populateCards];
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) {
        _cardViews = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < NUM_START_CARDS; i++) {
            SetCardView *cardView = [[SetCardView alloc] init];
            Card *card = [self.game cardAtIndex:i];
            SetCard *setCard = (SetCard *)card;
            cardView.shade = setCard.shade;
            cardView.shape = setCard.shape;
            cardView.color = setCard.color;
            cardView.count = setCard.count;
            cardView.faceUp = !card.isChosen;
            
            UITapGestureRecognizer *singleTapCardGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCardWithTouch:)];
            [singleTapCardGestureRecognizer setNumberOfTouchesRequired:1];
            [cardView addGestureRecognizer:singleTapCardGestureRecognizer];
            
            [_cardViews addObject:cardView];
            [self.cardsBoundaryView addSubview:cardView];
        }
    }
    
    return _cardViews;
}

- (void)flipCardWithTouch:(UITapGestureRecognizer *)recognizer
{
    CardView *cardView = (CardView *)(recognizer.view);
    cardView.faceUp = !cardView.faceUp;
    int chosenCardViewIndex = [self.cardViews indexOfObject:cardView];
    NSLog(@"%@",[NSString stringWithFormat:@"%d", chosenCardViewIndex]);
    [self.game chooseCardAtIndex:chosenCardViewIndex];
    
//    if (self.game.scoreDiff != 0) {
//        NSLog(@"matched");
//        for (Card *card in self.game.currentCards) {
//            card.matched = YES;
//        }
//    }
    
    if (self.game.scoreDiff > 0) {
        self.cardGrid.minimumNumberOfCells -= 3;
        NSLog(@"matched");
    }
    
    [self populateCards];
     
    //self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
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
