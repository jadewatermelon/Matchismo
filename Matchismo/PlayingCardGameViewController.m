//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Tom Billings on 12/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

#pragma mark - Abstract Method Implementations -

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            if (animate && playingCardView.faceUp != playingCard.isFaceUp) {
                if (playingCardView.faceUp) {
                    [UIView transitionWithView:playingCardView
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionFlipFromLeft
                                    animations:^{
                                    }completion:NULL];
                } else {
                    [UIView transitionWithView:playingCardView
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionFlipFromRight
                                    animations:^{
                                    }completion:NULL];
                }
            }
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

#pragma mark - Abstract Property Getters -

- (NSString *)cardType
{
    return @"PlayingCard";
}

- (NSString *)gameType
{
    return @"Matching";
}

- (NSUInteger)startingCardCount
{
    return 22;
}

- (NSUInteger)matchingMode
{
    return 2;
}


- (NSAttributedString *)cardToAttributedString:(Card *)card
{
    // do I need to do something prettier here?
    return [[NSAttributedString alloc] initWithString:card.contents];
}
/*
- (void)updateUIButton:(UIButton *)button withCard:(Card *)card
{
    if ([card isKindOfClass:[PlayingCard class]]) {
        // back of playing card has an image with no text
        [button setBackgroundImage:[UIImage imageNamed:@"Images/playingCardBack.png"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
        [button setAttributedTitle:nil forState:UIControlStateNormal];
        // when the card is faceup the contents are shown whether or not it is unplayable
        // the background is defined as well
        [button setBackgroundImage:[UIImage imageNamed:@"Images/playingCardFrontBorder.png"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"Images/playingCardFrontBorder.png"] forState:UIControlStateSelected|UIControlStateDisabled];
        [button setAttributedTitle:[self cardToAttributedString:card] forState:UIControlStateSelected];
        [button setAttributedTitle:[self cardToAttributedString:card] forState:UIControlStateSelected|UIControlStateDisabled];
        
        button.alpha = card.isUnplayable ? 0.3 : 1.0;   // make transparent if the card is no longer playable
        button.selected = card.isFaceUp;
        button.enabled = !card.isUnplayable;
    }
}
*/
@end
