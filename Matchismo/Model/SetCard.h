//
//  SetCard.h
//  Matchismo
//
//  Created by Tom Billings on 10/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//
//  Cards in Set have:
//      number:  1,2,3
//      symbol:  ■,▲,●
//      shading: "solid","striped","open"
//      color:   "red","green","purple"

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

+ (NSInteger)maxNumber;
+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

@end
