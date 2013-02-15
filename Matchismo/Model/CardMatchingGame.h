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
               gameType:(NSString *)type;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSMutableArray *moveHistory; // of type CardMatchingGameMove
@property (nonatomic) CardMatchingGameResults *results;

@end
