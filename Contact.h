//
//  Contacts.h
//  Troup Gext
//
//  Created by Boris Ruvinov on 1/27/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Contact : NSObject <NSCoding>

@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSData *thumbnailImgage;
@property (nonatomic, retain) NSString *label;
@property (nonatomic) NSUInteger contactListIndex;
@property (nonatomic) bool isSelected;
@property (nonatomic, retain) UIColor *thumbColor;

- (instancetype)initWithContactIndex:(NSUInteger)contactIndex name:(NSString*)contactName  phoneNumber:(NSString*)contactPhoneNumber phoneNumberLabel:(NSString*)contactLabel andThumbnailImage:(NSData*)contactThumbnailImage;

- (instancetype)initWithContactIndex:(NSUInteger)contactIndex name:(NSString*)contactName  phoneNumber:(NSString*)contactPhoneNumber phoneNumberLabel:(NSString*)contactLabel;

@end
