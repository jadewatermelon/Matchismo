//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Tom Billings on 31/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "CardMatchingGameMove.h"
#import "CardMatchingGameResults.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
           matchingMode:(NSUInteger)num
               gameType:(NSString *)type
               flipCost:(NSUInteger)flipCost
       mistmatchPenalty:(NSUInteger)mismatchPenalty
             matchBonus:(NSUInteger)matchBonus;

- (CardMatchingGameMove *)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfCard:(Card *) card;
- (void)removeCardAtIndex:(NSUInteger)index;
- (void)addCardAtIndex:(NSUInteger)index;
- (NSArray *)possibleMatch;

@property (strong, nonatomic) Deck *deck;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSUInteger numCardsInPlay;
@property (nonatomic, readonly) NSMutableArray *moveHistory; // of type CardMatchingGameMove
@property (nonatomic) CardMatchingGameResults *results;
@property (nonatomic, readonly) NSUInteger numAvailableMatches;

@end
