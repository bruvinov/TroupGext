//
//  Group.m
//  Troup Gext
//
//  Created by Boris Ruvinov on 2/2/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import "Group.h"

@implementation Group

- (instancetype)initWithName: (NSString *)groupName andContacts:(NSArray *)contactsToAdd {
    self = [super init];
    
    if (self) {
        self.name = groupName;
        self.contacts = contactsToAdd;
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    //Used when saving to disk
    [aCoder encodeObject:self.name forKey:@"GroupName"];
    [aCoder encodeObject:self.contacts forKey:@"GroupContacts"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    //Used when reading from disk
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"GroupName"];
        self.contacts = [aDecoder decodeObjectForKey:@"GroupContacts"];
    }
    return self;
}


- (void)addContact: (Contact *)contact {
    //DO SOMETHING
}

- (void)removeContacts: (Contact *)contact {
    //DO SOMETHING
}

@end
