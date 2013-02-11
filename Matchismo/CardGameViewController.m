//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tom Billings on 29/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UILabel *flipStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeChanged;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@property (strong,nonatomic) NSMutableArray *history;
@property (nonatomic) NSUInteger gameMode;
@property (nonatomic) int flipCount;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]
                                               matchingMode:self.gameMode];
    return _game;
}

- (IBAction)historySliderChanged:(UISlider *)sender
{
    int index = (int) [sender value];
    
    if (index < 0 || index > self.flipCount - 1)
        return;
    
    self.flipStatusLabel.alpha = (index < self.flipCount - 1) ? 0.3 : 1.0;
    self.flipStatusLabel.text = [self.history objectAtIndex:index];
}

- (NSMutableArray *)history
{
    if (!_history)
        _history = [[NSMutableArray alloc] init];
    return _history;
}

- (NSUInteger) gameMode
{
    if (!_gameMode || _gameMode < 2)
        _gameMode = 2;
    return _gameMode;
}


- (IBAction)gameModeChanged:(UISegmentedControl *)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.gameMode = 2;
            break;
        case 1:
            self.gameMode = 3;
            break;
        default:
            self.gameMode = 2;
            break;
    }
    [self dealNewCards];
}


- (IBAction)dealNewCards
{
    self.game = nil;
    self.flipCount = 0;
    self.gameModeChanged.enabled = YES;
    self.history = nil;
    [self updateUI];
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for (UIButton *cardButton in cardButtons) {
        [cardButton setBackgroundImage:[UIImage imageNamed:@"Images/playingCardBack.png"] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"Images/playingCardFrontBorder"] forState:UIControlStateSelected];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"Images/playingCardFrontBorder"] forState:UIControlStateSelected|UIControlStateDisabled];
        [cardButton setTitle:@"" forState:UIControlStateNormal];
    }
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents  forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipStatusLabel.text = self.game.lastPlay;
    
    [self.historySlider setMinimumValue:0.0];
    [self.historySlider setMaximumValue:(float) self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.gameModeChanged.enabled = NO;
    
    [self.historySlider setValue:(float) self.flipCount];
    [self.history addObject:self.game.lastPlay];
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

@end
