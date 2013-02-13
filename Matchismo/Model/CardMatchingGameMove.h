//
//  CardMatchingGameMove.h
//  Matchismo
//
//  Created by Tom Billings on 12/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

// Stores the current state of a CardMatchingGame by recording an
// array of cards along with the move type and the amount the score
// changed.

// the cards array should be sorted based on orderClicked parameter
// prior to storage to ensure that order is preserved for printing back

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MoveType) {
    MoveTypeFlipDown,
    MoveTypeFlipUp,
    MoveTypeMatch,
    MoveTypeMismatch
};

@interface CardMatchingGameMove : NSObject

// designated initiliazer
- (id) initWithMoveType:(MoveType)moveType
       withFlippedCards:(NSArray *)flippedCards
        withScoreChange:(NSInteger)scorechange;


@property (nonatomic) NSArray *cards;
@property (nonatomic) MoveType move;
@property (nonatomic) NSInteger scoreChange;

@end
