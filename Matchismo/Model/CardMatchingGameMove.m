//
//  CardMatchingGameMove.m
//  Matchismo
//
//  Created by Tom Billings on 12/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardMatchingGameMove.h"

@implementation CardMatchingGameMove

// designated initializer
- (id) initWithMoveType:(MoveType)moveType
       withFlippedCards:(NSArray *)flippedCards
        withScoreChange:(NSInteger)scoreChange
{
    self = [super init];
    
    if (self) {
        _move = moveType;
        _cards = flippedCards;
        _scoreChange = scoreChange;
    }
    return self;
}
// assumes all cards will be of same type per round... probably not the best way but easier/cleaner code for now
- (NSString *)description
{
    NSString * descriptions = @"";
    NSMutableArray *cardDescriptions = [self.cards mutableCopy];
    [cardDescriptions sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"orderClicked" ascending:YES]]];  // doesn't work the way i think it should because it's not a deep copy... so the orderClicked field is getting reset based on code in CardMatchingGame
    NSString *cardStrings = [cardDescriptions componentsJoinedByString:@"&"];
    
    if (self.move == MoveTypeFlipDown) {
        descriptions = @"";
    } else if (self.move == MoveTypeFlipUp) {
        descriptions = [NSString stringWithFormat:@"Flipped up %@",cardStrings];
    } else if (self.move == MoveTypeMatch) {
        descriptions = [NSString stringWithFormat:@"Matched %@\nfor %d points!", cardStrings, self.scoreChange];
    } else if (self.move == MoveTypeMismatch) {
        descriptions = [NSString stringWithFormat:@"%@ do not match!\n%d point penalty", cardStrings, self.scoreChange];
    }
    return descriptions;
}

@end
