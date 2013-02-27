//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tom Billings on 31/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (strong, nonatomic) NSMutableArray *cards; // of type Card
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSUInteger numCardsInPlay;
@property (nonatomic) NSUInteger numCardsToMatch;
@property (nonatomic) NSString* gameType;
@property (strong, nonatomic) NSMutableArray *faceUpCards;

@property (nonatomic) NSUInteger flipCost;
@property (nonatomic) NSUInteger mismatchPenalty;
@property (nonatomic) NSUInteger matchBonus;

@property (nonatomic, readwrite) NSMutableArray *moveHistory; // of type CardMatchingGameMove
@property (nonatomic) MoveType currentMoveType;
@property (nonatomic) int currentScoreChange;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)moveHistory
{
    if (!_moveHistory) _moveHistory = [[NSMutableArray alloc] init];
    return _moveHistory;
}

- (NSMutableArray *)faceUpCards
{
    if (!_faceUpCards) _faceUpCards = [[NSMutableArray alloc] init];
    return _faceUpCards;
}

- (NSUInteger)numCardsInPlay
{
    return [self.cards count];
}

- (CardMatchingGameResults *)results
{
    if (!_results)
        _results = [[CardMatchingGameResults alloc] initWithGameType:self.gameType];
    return _results;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
           matchingMode:(NSUInteger)num
               gameType:(NSString *)type
               flipCost:(NSUInteger)flipCost
       mistmatchPenalty:(NSUInteger)mismatchPenalty
             matchBonus:(NSUInteger)matchBonus
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.numCardsInPlay = num;
        self.deck = deck;
        self.numCardsToMatch = num;
        self.gameType = type;
        self.flipCost = flipCost;
        self.mismatchPenalty = mismatchPenalty;
        self.matchBonus = matchBonus;
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (NSUInteger)indexOfCard:(Card *)card
{
    return [self.cards indexOfObject:card];
}

- (CardMatchingGameMove *)flipCardAtIndex:(NSUInteger)index
{
    CardMatchingGameMove *currentMove = nil;
    self.currentMoveType = MoveTypeFlipDown;
    self.currentScoreChange = 0;
    
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            self.currentMoveType = MoveTypeFlipUp;
            self.currentScoreChange -= self.flipCost;
        }

        card.faceUp = !card.faceUp;
        
        int numFaceUp = [self numFaceUpCards];
        card.orderClicked = numFaceUp - 1;
        // preserve current state of cards by sorting based on orderClicked
        [self.faceUpCards sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"orderClicked" ascending:YES]]];
        NSArray *currentCardOrder = [[NSArray alloc] initWithArray:self.faceUpCards]; // copyItems:YES];  // want to do a deep copy....
        
        if (numFaceUp == self.numCardsToMatch){
            [self matchFaceUpCards];
        }
        
        // if the previous move was a flip down remove it
        if ([[[self.moveHistory lastObject] description] isEqualToString:@""]) {
            [self.moveHistory removeLastObject];
        }
        
        currentMove = [[CardMatchingGameMove alloc] initWithMoveType:self.currentMoveType withFlippedCards:currentCardOrder withScoreChange:self.currentScoreChange];
        [self.moveHistory addObject:currentMove];
        self.score += self.currentScoreChange;
        // update game results for every flip
        self.results.score = self.score;
    }
    return currentMove;
}

- (NSUInteger)numFaceUpCards
{
    NSUInteger num = 0;
    self.faceUpCards = nil;
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            num++;
            [self.faceUpCards addObject:card];
        }
    }
    return num;
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
}

- (void)addCardAtIndex:(NSUInteger)index
{
    Card *card = [self.deck drawRandomCard];
    if (card) {
        [self.cards insertObject:card atIndex:index];
    }
}

- (void)matchFaceUpCards
{
    NSMutableArray *cardsToMatch = [self.faceUpCards mutableCopy];          // used to update orderClicked for future moves
    
    Card *card = [cardsToMatch lastObject];
    [cardsToMatch removeObject:card];
    
    int matchScore = [card match:cardsToMatch];
    if (matchScore) {
        for (Card *matchedCard in cardsToMatch) {
            matchedCard.unplayable = YES;
            matchedCard.orderClicked = 0;
        }
        card.unplayable = YES;
        card.orderClicked = 0;
        
        self.currentMoveType = MoveTypeMatch;
        self.currentScoreChange += matchScore * self.matchBonus;
    } else {
        for (Card *unmatchedCard in cardsToMatch) {
            unmatchedCard.faceUp = NO;
            unmatchedCard.orderClicked = 0;
        }            
//        card.faceUp = NO;                     // comment if you want the last card selected to remain faceup
        card.orderClicked = 0;

        self.currentMoveType = MoveTypeMismatch;
        self.currentScoreChange -= self.mismatchPenalty;
    }
}
@end