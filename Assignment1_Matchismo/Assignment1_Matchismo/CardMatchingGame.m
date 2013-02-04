//
//  CardMatchingGame.m
//  Assignment1_Matchismo
//
//  Created by 钟 子豪 on 13-2-2.
//  Copyright (c) 2013年 Pride Chung. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

@property (readwrite, nonatomic) int score;
@property (nonatomic) NSMutableArray *cards;
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count
			  usingDeck:(Deck *)deck
{
	self = [super init];
	
	if (self) {
		for (int i = 0; i < count; i++) {
			Card *card = [deck drawRandomCard];
			if (card) {
				self.cards[i] = card;
			} else {
				self = nil;
				break;
			}
		}
		
		self.cardMatchingType = TwoCardMatchingType;
	}
	
	return self;
}

- (NSMutableArray *)cards
{
	if (!_cards) _cards = [[NSMutableArray alloc] init];
	return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
	Card *card = [self cardAtIndex:index];
	
	if (card && !card.isUnplayable) {
		
		self.flipCount++;
		
		if (!card.isFaceUp) {
			
			if (self.cardMatchingType == TwoCardMatchingType) {
				for (Card *otherCard in self.cards) {
					if (otherCard.isFaceUp && !otherCard.isUnplayable) {
						
						int matchScore = [card match:@[otherCard]];
						if (matchScore) {
							card.unplayable = YES;
							otherCard.unplayable = YES;
							self.score += matchScore * MATCH_BONUS;
							self.lastFlipResult = [NSString stringWithFormat:@"Matched %@ and %@ for %d points",
												   card.contents,
												   otherCard.contents,
												   matchScore * MATCH_BONUS];
						} else {
							otherCard.faceUp = NO;
							self.score -= MISMATCH_PENALTY;
							self.lastFlipResult = [NSString stringWithFormat:@"%@ and %@ don't match! %d points penalty!",
												   card.contents,
												   otherCard.contents,
												   MISMATCH_PENALTY];
						}
						break;
					} else if ([[self faceUpAndPlayableCards] count] == 0) { //if there is no other cards for matching, we tell the player what card he just flipped
						self.lastFlipResult = [NSString stringWithFormat:@"Flipped up %@", card.contents];
					}
				}
				
			} else if (self.cardMatchingType == ThreeCardMatchingType) {
				NSArray *faceUpCards = [self faceUpAndPlayableCards];
				if ([faceUpCards count] > 1) {
					int matchScore = [card match:faceUpCards];
					if (matchScore) {
						card.unplayable = YES;
						for (Card *card in faceUpCards) {
							card.unplayable = YES;
						}
						
						self.score += matchScore * MATCH_BONUS;
						self.lastFlipResult = [NSString stringWithFormat:@"Matched %@, %@ and %@ for %d points",
											   card.contents,
											   [faceUpCards[0] contents],
											   [faceUpCards[1] contents],
											   matchScore * MATCH_BONUS];
					} else {
						for (Card *card in faceUpCards) {
							card.faceUp = NO;
						}
						
						self.score -= MISMATCH_PENALTY;
						self.lastFlipResult = [NSString stringWithFormat:@"%@, %@ and %@ don't match! %d points penalty!",
											   card.contents,
											   [faceUpCards[0] contents],
											   [faceUpCards[1] contents],
											   MISMATCH_PENALTY];
					}
				} else if ([faceUpCards count] < 2) {
					self.lastFlipResult = [NSString stringWithFormat:@"Flipped up %@", card.contents];
				}
			}
			self.score -= FLIP_COST;
		}

		card.faceUp = !card.isFaceUp;
	}
}

- (Card *)cardAtIndex:(NSUInteger)index
{
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (NSArray *)faceUpAndPlayableCards
{
	NSMutableArray *faceUpCards = [NSMutableArray array];
	for (Card *card in self.cards) {
		if (card.isFaceUp && !card.isUnplayable) {
			[faceUpCards addObject:card];
		}
	}
	return faceUpCards;
}

- (id)copyWithZone:(NSZone *)zone
{
	CardMatchingGame *game = [[CardMatchingGame alloc] init];
	game.score = self.score;
	game.flipCount = self.flipCount;
	game.lastFlipResult = self.lastFlipResult;
	game.cardMatchingType = self.cardMatchingType;
	game.cards = [[NSMutableArray alloc] initWithArray:self.cards copyItems:YES];
	
	return game;
}
@end
