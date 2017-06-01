//
//  DataAccess.h
//  Troup Gext
//
//  Created by Boris Ruvinov on 1/26/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "Group.h"
#import "Contact.h"

@interface DataAccess : NSObject

@property (nonatomic, strong) NSMutableArray *contactsList;
@property (nonatomic, strong) NSMutableArray *groupsList;

+ (id)sharedDAO;
- (void)fetchAllContacts;
- (void)addGroup:(Group *)groupToAdd;
- (void)deleteGroupAtIndex:(NSUInteger)index;
- (void)getUserDefaults;

@end
