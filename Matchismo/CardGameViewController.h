//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Tom Billings on 29/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGameMove.h"

@interface CardGameViewController : UIViewController
// abstract methods and properties
- (Deck *)createDeck;
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate;
- (void)updateStatus:(UIView *)view usingMove:(CardMatchingGameMove *)move;

@property (strong, nonatomic) NSString *cardType;
@property (strong, nonatomic) NSString *gameType;
@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) NSUInteger matchingMode;
@property (nonatomic) NSUInteger flipCost;
@property (nonatomic) NSUInteger mismatchPenalty;
@property (nonatomic) NSUInteger matchBonus;

// abstract methods left over from assignment 2 -- no longer needed

//- (void)updateUIButton:(UIButton *)button withCard:(Card *)card;
// concrete methods - do not need to be overwritten
- (void)clearStatus:(UIView *)view;
- (NSAttributedString *)cardToAttributedString:(Card *)card;
- (NSString *)moveToString:(CardMatchingGameMove *)move;

@end
