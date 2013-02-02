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
		
		if (!card.isFaceUp) {
			BOOL hasOtherCardsFaceUpAndPlayable = NO; //use this var the determine if there's any other cards face up
			for (Card *otherCard in self.cards) {
				if (otherCard.isFaceUp && !otherCard.isUnplayable) {
					
					int matchScore = [card match:@[otherCard]];
					hasOtherCardsFaceUpAndPlayable = YES; 
					
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
				}
			}
			self.score -= FLIP_COST;
			if (!hasOtherCardsFaceUpAndPlayable) { //if there is no other cards for matching, we tell the player what card he just flipped
				self.lastFlipResult = [NSString stringWithFormat:@"Flipped up %@", card.contents];
			}
		}

		card.faceUp = !card.isFaceUp;
	}
}

- (Card *)cardAtIndex:(NSUInteger)index
{
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
