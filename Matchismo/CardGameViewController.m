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
    self.lastPlayLabel.attributedText = [self moveToAttributedString:[self.game.moveHistory objectAtIndex:index]];
}

- (IBAction)dealNewCards
{
    self.game = nil;
    self.flipCount = 0;
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
        [self updateUIButton:cardButton withCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.lastPlayLabel.attributedText = [self moveToAttributedString:[self.game.moveHistory lastObject]];
    
    [self.historySlider setMinimumValue:0.0];
    [self.historySlider setMaximumValue:(float) [self.game.moveHistory count]];
}

- (void)updateUIButton:(UIButton *)button withCard:(Card *)card
{
    [button setBackgroundImage:nil forState:UIControlStateNormal];      // default is a blank card back
    [button setAttributedTitle:nil forState:UIControlStateNormal];      // with no text
    [button setAttributedTitle:[self cardToAttributedString:card] forState:UIControlStateSelected]; // when selected show the contents
    [button setAttributedTitle:[self cardToAttributedString:card] forState:UIControlStateSelected|UIControlStateDisabled]; // when selected and out of play still show the contents
    
    button.alpha = card.isUnplayable ? 0.3 : 1.0;   // make transparent if the card is no longer playable
    button.selected = card.isFaceUp;
    button.enabled = !card.isUnplayable;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    // only update flipCount if you are flipping up
    if (!sender.selected)
        self.flipCount++;
    
    [self.historySlider setValue:(float) [self.game.moveHistory count]];
    [self updateUI];
}

- (NSAttributedString *)cardToAttributedString:(Card *)card
{
    return [[NSAttributedString alloc] initWithString:card.contents];
}

- (NSAttributedString *)moveToAttributedString:(CardMatchingGameMove *)move
{
    NSMutableAttributedString *cardsToInsert = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *moveSummary;
    
    NSAttributedString *nothing = [[NSAttributedString alloc] initWithString:@""];
    NSAttributedString *andper = [[NSAttributedString alloc] initWithString:@"&"];
    
    for (Card *card in move.cards) {
        [cardsToInsert appendAttributedString:[self cardToAttributedString:card]];
        [cardsToInsert appendAttributedString:[card isEqual:[move.cards lastObject]] ? nothing : andper];
    }
    
    if (move.move == MoveTypeFlipDown) {
        return nothing;
    } else if (move.move == MoveTypeFlipUp) {
        moveSummary = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
        [moveSummary appendAttributedString:cardsToInsert];
    } else if (move.move == MoveTypeMatch) {
        moveSummary = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
        [moveSummary appendAttributedString:cardsToInsert];
        [moveSummary appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nfor %d points",move.scoreChange]]];
    } else if (move.move == MoveTypeMismatch) {
        moveSummary = [[NSMutableAttributedString alloc] initWithAttributedString:cardsToInsert];
        [moveSummary appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" do not match\n%d point penalty",move.scoreChange]]];
    }
    
    if (moveSummary) {
        // add center paragraph style and font for entire attributedstring
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        UIFont *fontStyle = [UIFont systemFontOfSize:14];
        
        [moveSummary addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : fontStyle}
                             range:NSMakeRange(0,[moveSummary length])];
        return moveSummary;
    }
    else
        return nothing;
}

@end
