//
//  CardMatchingGameResults.h
//  Matchismo
//
//  Created by Tom Billings on 15/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardMatchingGameResults : NSObject

+ (NSArray *)allGameResults;
+ (void)resetGameResults;
- (id)initWithGameType:(NSString *)gameType;        // designated initializer

@property (nonatomic,readonly) NSDate *start;
@property (nonatomic,readonly) NSDate *end;
@property (nonatomic,readonly) NSTimeInterval duration;
@property (nonatomic,readonly) NSString *gameType;
@property (nonatomic) int score;

- (NSComparisonResult)dateCompare:(CardMatchingGameResults *)gameResult;
- (NSComparisonResult)scoreCompare:(CardMatchingGameResults *)gameResult;
- (NSComparisonResult)durationCompare:(CardMatchingGameResults *)gameResult;

@end
