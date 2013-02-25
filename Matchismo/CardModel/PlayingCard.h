//
//  PlayingCard.h
//  Matchismo
//
//  Created by Tom Billings on 30/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
