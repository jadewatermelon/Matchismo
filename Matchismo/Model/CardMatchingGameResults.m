//
//  CardMatchingGameResults.m
//  Matchismo
//
//  Created by Tom Billings on 15/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardMatchingGameResults.h"

@interface CardMatchingGameResults()

@property (nonatomic,readwrite) NSDate *start;
@property (nonatomic,readwrite) NSDate *end;
@property (nonatomic,readwrite) NSString *gameType;

@end

@implementation CardMatchingGameResults

#define ALL_RESULTS_KEY @"CardMatchingGameResults_ALL"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"
#define GAMETYPE_KEY @"GameType"

+ (NSArray *)allGameResults
{
    NSMutableArray *gameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        CardMatchingGameResults *gameResult = [[CardMatchingGameResults alloc] initFromPropertyList:plist];
        [gameResults addObject:gameResult];
    }
    
    return gameResults;
}

+ (void)resetGameResults
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSComparisonResult)dateCompare:(CardMatchingGameResults *)gameResult
{
    return [self.end compare:gameResult.end];
}

- (NSComparisonResult)scoreCompare:(CardMatchingGameResults *)gameResult
{
    return [@(self.score) compare:@(gameResult.score)];
}

- (NSComparisonResult)durationCompare:(CardMatchingGameResults *)gameResult
{
    return [@(self.duration) compare:@(gameResult.duration)];
}

- (void)synchronize
{
    // grab most recent storage of GameResults
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    // make a new one if one has never been stored
    if (!mutableGameResultsFromUserDefaults)
        mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    // use the start time of the game as the key
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    // update userDefaults
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{START_KEY : self.start,
             END_KEY : self.end,
             SCORE_KEY : @(self.score),
             GAMETYPE_KEY : self.gameType};
}

// designated initializer
- (id)initWithGameType:(NSString *)gameType
{
    self = [super init];
    
    if (self) {
        _start = [NSDate date];
        _end = _start;
        _gameType = gameType;
    }
    return self;
}
// convenience initializer
- (id)initFromPropertyList:(id)plist
{
    self = [self initWithGameType:@"Unknown"];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *gameResults = (NSDictionary *)plist;
            _start = gameResults[START_KEY];
            _end = gameResults[END_KEY];
            _score = [gameResults[SCORE_KEY] intValue] ;
            _gameType = gameResults[GAMETYPE_KEY];
            if (!_start || !_end)
                self = nil;
        }
    }
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

@end
