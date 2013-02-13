//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tom Billings on 29/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "SetCard.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UILabel *lastPlayLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeChanged;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

//@property (nonatomic) NSUInteger gameMode;
@property (nonatomic) int flipCount;

@end

@implementation CardGameViewController

- (NSUInteger)numPlayableCards
{
    return [self.cardButtons count];
}

- (IBAction)historySliderChanged:(UISlider *)sender
{
    int index = (int) [sender value];
    
    if (index < 0 || index > [self.game.moveHistory count] - 1)
        return;
    
    self.lastPlayLabel.alpha = (index < [self.game.moveHistory count] - 1) ? 0.3 : 1.0; 
    self.lastPlayLabel.text = [[self.game.moveHistory objectAtIndex:index] description];
}
/*
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
*/

- (IBAction)dealNewCards
{
    self.game = nil;
    self.flipCount = 0;
//    self.gameModeChanged.enabled = YES;
    [self updateUI];
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if ([card isKindOfClass:[PlayingCard class]]) {
            [cardButton setBackgroundImage:[UIImage imageNamed:@"Images/playingCardBack.png"]
                                  forState:UIControlStateNormal];                               // shows card back for playing card
            [cardButton setBackgroundImage:[UIImage imageNamed:@"Images/playingCardFrontBorder"]
                                  forState:UIControlStateSelected];                             // shows blank background when card isFaceUp and playable
            [cardButton setBackgroundImage:[UIImage imageNamed:@"Images/playingCardFrontBorder"]
                                  forState:UIControlStateSelected|UIControlStateDisabled];      // shows blank background when card isFaceUp and unplayable
            [cardButton setTitle:@"" forState:UIControlStateNormal];                            // ensures no text is on the playing card back
        } else if ([card isKindOfClass:[SetCard class]]) {
            [cardButton setTitle:card.contents forState:UIControlStateNormal];
        }
        [cardButton setTitle:card.contents  forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.lastPlayLabel.text = [[self.game.moveHistory lastObject] description];
    
    [self.historySlider setMinimumValue:0.0];
    [self.historySlider setMaximumValue:(float) [self.game.moveHistory count]];//self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
//    self.gameModeChanged.enabled = NO;
    
    [self.historySlider setValue:(float) [self.game.moveHistory count]];//self.flipCount];
    [self updateUI];
}

@end
