//
//  Card.h
//  Assignment1_Matchismo
//
//  Created by 钟 子豪 on 13-2-1.
//  Copyright (c) 2013年 Pride Chung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;

@end
