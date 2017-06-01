//
//  Contacts.m
//  Troup Gext
//
//  Created by Boris Ruvinov on 1/27/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (instancetype)initWithContactIndex:(NSUInteger)contactIndex name:(NSString*)contactName  phoneNumber:(NSString*)contactPhoneNumber phoneNumberLabel:(NSString*)contactLabel andThumbnailImage:(NSData*)contactThumbnailImage {
    self = [super init];
    if (self) {
        self.contactListIndex = contactIndex;
        self.fullName = contactName;
        self.phoneNumber = contactPhoneNumber;
        self.label = contactLabel;
        self.thumbnailImgage = contactThumbnailImage;
        self.isSelected = NO;
        
        NSLog(@"Contact %@ - %@ - %@ added.", self.fullName, self.label, self.phoneNumber);
    }
    return self;
}

- (instancetype)initWithContactIndex:(NSUInteger)contactIndex name:(NSString*)contactName  phoneNumber:(NSString*)contactPhoneNumber phoneNumberLabel:(NSString*)contactLabel {
    self = [super init];
    if (self) {
        self.contactListIndex = contactIndex;
        self.fullName = contactName;
        self.phoneNumber = contactPhoneNumber;
        self.label = contactLabel;
        self.isSelected = NO;
        self.thumbColor = [self generateRandomColor];
        
        NSLog(@"Contact %@ - %@ - %@ added.", self.fullName, self.label, self.phoneNumber);
    }
    return self;
}

- (UIColor *)generateRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *randomColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return randomColor;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    //Used when saving to disk
    [aCoder encodeObject:self.fullName forKey:@"ContactFullName"];
    [aCoder encodeObject:self.phoneNumber forKey:@"ContactPhoneNumber"];
    [aCoder encodeObject:self.label forKey:@"ContactLabel"];
    [aCoder encodeObject:self.thumbnailImgage forKey:@"ContactThumbnail"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    //Used when reading from disk
    self = [super init];
    if (self) {
        self.fullName = [aDecoder decodeObjectForKey:@"ContactFullName"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"ContactPhoneNumber"];
        self.label = [aDecoder decodeObjectForKey:@"ContactLabel"];
        self.thumbnailImgage = [aDecoder decodeObjectForKey:@"ContactThumbnail"];
    }
    return self;
}


@end
