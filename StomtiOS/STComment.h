//
//  STComment.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 17/09/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STTarget;

@interface STComment : NSObject
@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSDate* createdAt;
@property (nonatomic) BOOL anonym;
@property (nonatomic) BOOL reaction;
@property (nonatomic) BOOL byStomtCreator;
@property (nonatomic) BOOL byTargetOwner;
@property (nonatomic) NSInteger amountSubcomments;
@property (nonatomic) NSInteger amountVotes;
@property (nonatomic) NSInteger amountPositive;
@property (nonatomic) NSInteger amountNegative;
@property (nonatomic,strong) NSArray<STComment*>* subComments;
@property (nonatomic,strong) STTarget* creator;

@property (nonatomic,weak) NSString* associatedStomtID;
@property (nonatomic,weak) STComment* parent;
@property (nonatomic) NSInteger level;

+ (instancetype)initWithDictionary:(NSDictionary*)dataDict;
- (instancetype)initWithIdentifier:(NSString *)identifier
					   commentText:(NSString *)text
						 createdAt:(NSDate *)createdAt
						 anonymous:(BOOL)anonym
				  hasBeenReactedTo:(BOOL)reaction
			   isByTheStomtCreator:(BOOL)byStomtCreator
				   isByTargetOwner:(BOOL)byTargetOwner
			   amountOfSubcomments:(NSInteger)amountSubcomments
					 amountOfVotes:(NSInteger)amountVotes
			 amountOfPositiveVotes:(NSInteger)amountPositive
			 amountOfNegativeVotes:(NSInteger)amountNegative
				  subcommentsArray:(NSArray *)subComments
						   creator:(STTarget *)creator;
@end
