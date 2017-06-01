//
//  Group.h
//  Troup Gext
//
//  Created by Boris Ruvinov on 2/2/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface Group : NSObject <NSCoding>

@property (nonatomic, retain) NSArray *contacts;
@property (nonatomic, retain) NSString *name;

- (instancetype)initWithName: (NSString *)name andContacts:(NSArray *)contactsToAdd;
- (void)addContact: (Contact *)contact;
- (void)removeContacts: (Contact *)contact;

@end
