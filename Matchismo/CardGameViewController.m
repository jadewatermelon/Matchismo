//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tom Billings on 29/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController() <UICollectionViewDataSource>

@property (strong, nonatomic) CardMatchingGame *game;

//@property (weak, nonatomic) IBOutlet UILabel *lastPlayLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchesLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIButton *dealMoreCards;
@property (strong, nonatomic) NSArray *hintIndexes;

@end

@implementation CardGameViewController

#pragma mark - CollectionView Protocol Implementation -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
        return 1;// default return value is 1 just to show how to implement optional protocol
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
      numberOfItemsInSection:(NSInteger)section
{
    return self.game.numCardsInPlay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cardType forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}

#pragma mark - Game and Card Handling -

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]
                                               matchingMode:self.matchingMode
                                                   gameType:self.gameType
                                                   flipCost:self.flipCost
                                           mistmatchPenalty:self.mismatchPenalty
                                                 matchBonus:self.matchBonus];
    return _game;
}

- (IBAction)dealNewCards
{
    self.game = nil;
    [self clearStatus:self.statusView];
    [self.cardCollectionView reloadData];
    
    self.dealMoreCards.alpha = 1.0;
    self.dealMoreCards.enabled = YES;
    
    [self updateUI];
}

- (IBAction)dealMoreCards:(UIButton *)sender
{
    // in future is it possible to fill in blanks from cards that were just matched... AUTO_REPLACE below
    if ([self.game.deck isEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deck is empty!"
                                                        message:@"Continue making matches or deal new game."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        sender.enabled = NO;
        sender.alpha = 0.5;
    } else {
        for (int i = 0; i < sender.tag; i++) {
            [self.game addCardAtIndex:self.game.numCardsInPlay];
        }
        [self.cardCollectionView reloadData];
        
        [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.game.numCardsInPlay- 1) inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:YES];
    }
    [self updateUI];
}
- (IBAction)hint
{
    if ([self.game numAvailableMatches]) {
        self.hintIndexes = [self.game possibleMatch];
/*
        for (int i = 0; i < [self.hintIndexes count]; i++) {
            int index = [self.hintIndexes[i] intValue];
            UICollectionViewCell *cell = [self.cardCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            Card *card = [self.game cardAtIndex:index];
            
            cell.selected = YES;
            [self updateCell:cell usingCard:card animate:YES];
        }
*/        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No matches present"
                                                        message:@"Add more cards or deal new game."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateUI];
}

#define AUTO_REPLACE false

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath) {
        CardMatchingGameMove *move = [self.game flipCardAtIndex:indexPath.item];
        
        if (move && move.moveType == MoveTypeMatch) {
            NSMutableArray *indexPathsForMatchedCards = [[NSMutableArray alloc] init];
            
            for (Card *card in move.cards) {
                [indexPathsForMatchedCards addObject:[NSIndexPath indexPathForItem:[self.game indexOfCard:card] inSection:0]];
            }
            
            for (Card *card in move.cards) {
                [self.game removeCardAtIndex:[self.game indexOfCard:card]];
            }
            
            [self.cardCollectionView deleteItemsAtIndexPaths:indexPathsForMatchedCards];
            self.hintIndexes = nil;
            if (AUTO_REPLACE)
            {
                for (NSIndexPath *indexPath in indexPathsForMatchedCards) {
                    [self.game addCardAtIndex:indexPath.item];
                }
                [self.cardCollectionView insertItemsAtIndexPaths:indexPathsForMatchedCards];
            }
        }
        [self.historySlider setValue:(float) [self.game.moveHistory count]];
        [self updateUI];
    }
}

#pragma mark - UI refresh methods -

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        if ([self.hintIndexes containsObject:@(indexPath.item)]) cell.selected = YES;
        [self updateCell:cell usingCard:card animate:YES];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.matchesLabel.text = [NSString stringWithFormat:@"Matches: %d", self.game.numAvailableMatches];
    [self updateStatus:self.statusView usingMove:[self.game.moveHistory lastObject]];
//    self.lastPlayLabel.attributedText = [self moveToAttributedString:[self.game.moveHistory lastObject]];
    
    [self.historySlider setMinimumValue:0.0];
    [self.historySlider setMaximumValue:(float) [self.game.moveHistory count]];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableBackground"]];
    self.matchesLabel.text = [NSString stringWithFormat:@"Matches: %d", self.game.numAvailableMatches];
}

- (void)clearStatus:(UIView *)view
{
    for (UIView *subview in [view subviews])
    {
        [subview removeFromSuperview];
    }
}

- (IBAction)historySliderChanged:(UISlider *)sender
{
    int index = (int) [sender value];
    
    if (index < 0 || index > [self.game.moveHistory count] - 1)
        return;
    
    //self.lastPlayLabel.alpha = (index < [self.game.moveHistory count] - 1) ? 0.3 : 1.0;
    //self.lastPlayLabel.attributedText = [self moveToAttributedString:[self.game.moveHistory objectAtIndex:index]];
    [self updateStatus:self.statusView usingMove:[self.game.moveHistory objectAtIndex:index]];
    self.statusView.alpha = (index < [self.game.moveHistory count] - 1) ? 0.3 : 1.0;
}

# pragma mark - Abstract Methods -

- (Deck *)createDeck
{
    return nil;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    //abstract
}

- (void)updateStatus:(UIView *)view usingMove:(CardMatchingGameMove *)move
{
    // abstract
}

// methods leftover from assignment 2 -- no longer needed
/*
- (void)updateUIButton:(UIButton *)button withCard:(Card *)card
{
    // abstract
}
*/

#pragma mark - Helper Methods to Strings -

- (NSAttributedString *)cardToAttributedString:(Card *)card
{
    return nil;
}

- (NSString *)moveToString:(CardMatchingGameMove *)move
{
    NSString *moveResults;
    
    if (move.moveType == MoveTypeFlipDown) {
        return @"";
    } else if (move.moveType == MoveTypeFlipUp) {
        moveResults = @"Flipped up: ";
    } else if (move.moveType == MoveTypeMatch) {
        moveResults = [NSString stringWithFormat:@"⭐Match⭐\nfor %d points", move.scoreChange];
    } else if (move.moveType == MoveTypeMismatch) {
       moveResults = [NSString stringWithFormat:@"❌Mismatch❌\n%d point penalty", abs(move.scoreChange)];
    }
    return moveResults;
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
    
    if (move.moveType == MoveTypeFlipDown) {
        return nothing;
    } else if (move.moveType == MoveTypeFlipUp) {
        moveSummary = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
        [moveSummary appendAttributedString:cardsToInsert];
    } else if (move.moveType == MoveTypeMatch) {
        moveSummary = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
        [moveSummary appendAttributedString:cardsToInsert];
        [moveSummary appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nfor %d points",move.scoreChange]]];
    } else if (move.moveType == MoveTypeMismatch) {
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
