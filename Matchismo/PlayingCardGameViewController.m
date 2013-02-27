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

#define CARD_WIDTH_TO_HEIGHT_RATIO 0.7
#define CARD_OFFSET 5.0

- (void)updateStatus:(UIView *)view usingMove:(CardMatchingGameMove *)move
{
    [self clearStatus:view];
    NSString *status = [self moveToString:move];
    NSInteger offset = 0;
    
    CGFloat cardWidth = view.bounds.size.height * CARD_WIDTH_TO_HEIGHT_RATIO;
    CGFloat cardHeight = view.bounds.size.height;
    
    CGFloat labelWidth = view.bounds.size.width - ([self matchingMode] * (cardWidth + CARD_OFFSET) + CARD_OFFSET);
    CGFloat labelHeight = view.bounds.size.height;
    
    if (move.moveType == MoveTypeFlipUp) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,labelWidth,labelHeight)];
        
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentRight;
        label.autoresizesSubviews = YES;
        label.backgroundColor = [UIColor clearColor];
        
        label.text = status;
        [view addSubview:label];
        
        offset += label.bounds.size.width + CARD_OFFSET;
    }
    
    for (Card *card in move.cards) {
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            PlayingCardView *playingCardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(offset,0,cardWidth,cardHeight)];
            
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = YES;
            
            playingCardView.opaque = NO;
            [playingCardView setBackgroundColor:[UIColor clearColor]];
            
            [view addSubview:playingCardView];
            
            offset += cardWidth + CARD_OFFSET;
        }
    }
    
    if (move.moveType == MoveTypeMatch || move.moveType == MoveTypeMismatch) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offset,0,labelWidth,labelHeight)];
        
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizesSubviews = YES;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        
        label.text = status;
        [view addSubview:label];
    }
}

/*
- (void)updateCell:(UICollectionViewCell *)cell usingMove:(CardMatchingGameMove *)move
{
    if ([cell isKindOfClass:[PlayingCardStatusCollectionViewCell class]]) {
        NSArray *playingCardViews = ((PlayingCardStatusCollectionViewCell *)cell).playingCardViews;
        if ([move isKindOfClass:[CardMatchingGameMove class]]) {
            CardMatchingGameMove *gameMove = (CardMatchingGameMove *)move;
            if ([gameMove.cards count] <= [playingCardViews count]) {
                int i = 0;
                for (Card *card in gameMove.cards) {
                    if ([card isKindOfClass:[PlayingCard class]]) {
                        PlayingCard *playingCard = (PlayingCard *)card;
                        PlayingCardView *playingCardView = [playingCardViews objectAtIndex:i];
                        playingCardView.rank = playingCard.rank;
                        playingCardView.suit = playingCard.suit;
                        playingCardView.faceUp = YES;
                        i++;
                    }
                }
            }
        }
    } else if ([cell isKindOfClass:[CardGameMoveStatusCollectionViewCell class]]) {
        UITextView *status = ((CardGameMoveStatusCollectionViewCell *)cell).cardGameStatus;
        if ([move isKindOfClass:[CardMatchingGameMove class]]) {
            [self moveToString:(CardMatchingGameMove *)move];
        }
    }
}
*/
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
