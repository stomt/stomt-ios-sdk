//
//  STObject.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 15/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class STTarget;
@class STImage;

typedef enum{
	kSTObjectPositive,kSTObjectWish
}kSTObjectQualifier;

@interface STObject : NSObject
@property (nonatomic,strong) NSString* identifier;
@property (nonatomic) BOOL positive;
@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSString* lang; //Replace with enum
@property (nonatomic,strong) NSDate* createdAt;
@property (nonatomic) BOOL anonym;
//@property (nonatomic,strong) STImage* image; Not needed anymore
@property (nonatomic,strong) STTarget* creator;
@property (nonatomic,strong) STTarget* target;
@property (nonatomic) int amountOfAgreements;
@property (nonatomic) int amountOfComments;
@property (nonatomic) BOOL agreed;
+ (instancetype)objectWithTextBody:(NSString *)body positiveOrWish:(kSTObjectQualifier)positiveOrWish;
@end
