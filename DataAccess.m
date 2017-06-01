//
//  DataAccess.m
//  Troup Gext
//
//  Created by Boris Ruvinov on 1/26/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import "DataAccess.h"

@interface DataAccess ()

@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation DataAccess 

+ (id)sharedDAO {
    static DataAccess *sharedDao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDao = [[DataAccess alloc] init];
    });
    return sharedDao;
}

- (void)fetchAllContacts {
    NSMutableArray *result = [NSMutableArray new];
    CNContactStore *addressBook = [[CNContactStore alloc] init];
    NSError *fetchError;
    
    NSArray *keysToFetch = @[CNContactFamilyNameKey,
                             CNContactGivenNameKey,
                             CNContactPhoneNumbersKey,
                             CNContactThumbnailImageDataKey];
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    BOOL success = [addressBook enumerateContactsWithFetchRequest:fetchRequest
                                                            error:&fetchError
                                                       usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                                                           [result addObject:contact];
                                                       }];
    if (!success) {
        NSLog(@"error = %@", fetchError);
    }
    self.contacts = [[NSMutableArray alloc] initWithArray:result];
    
    [self convertToContactsList];
}

- (void)convertToContactsList {
    if (!self.contactsList) {
        self.contactsList = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *contactsToConvert = [[NSMutableArray alloc]init];
    
    for (CNContact *contact in self.contacts) {
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
        NSArray <CNLabeledValue<CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
        NSData *thumbImageData = contact.thumbnailImageData;
        
        for (int x = 0; x < phoneNumbers.count; x++) {
            CNLabeledValue<CNPhoneNumber *> *phoneObject = [phoneNumbers objectAtIndex:x];
            CNPhoneNumber *number = phoneObject.value;
            NSString *digits = number.stringValue;
            NSString *label = [CNLabeledValue localizedStringForLabel:phoneObject.label];
            NSUInteger indexInContactList = [contactsToConvert count];
            
            if (thumbImageData) {
                Contact *new = [[Contact alloc] initWithContactIndex:indexInContactList
                                                                name:fullName
                                                         phoneNumber:digits
                                                    phoneNumberLabel:label
                                                   andThumbnailImage:thumbImageData];
                [contactsToConvert addObject:new];
            } else {
                Contact *new = [[Contact alloc] initWithContactIndex:indexInContactList name:fullName phoneNumber:digits phoneNumberLabel:label];
                [contactsToConvert addObject:new];
            }
        }
    }
    self.contactsList = [NSMutableArray arrayWithArray:contactsToConvert];
}

-(void)getUserDefaults {
    NSData *groupsListData = [[NSUserDefaults standardUserDefaults] objectForKey:@"GroupsListData"];
    if (groupsListData != nil) {
        NSArray *groupsListArray = [NSKeyedUnarchiver unarchiveObjectWithData:groupsListData];
        if (groupsListArray != nil) {
            self.groupsList = [NSMutableArray arrayWithArray:groupsListArray];        }
    }
}

-(void)updateUserDefaults {
    NSData *groupsListData = [NSKeyedArchiver archivedDataWithRootObject:self.groupsList];
    [[NSUserDefaults standardUserDefaults] setObject:groupsListData forKey:@"GroupsListData"];

}

- (void)addGroup:(Group *)groupToAdd {
    if (!self.groupsList) {
        self.groupsList = [[NSMutableArray alloc]init];
    }
    [self.groupsList addObject:groupToAdd];
    [self updateUserDefaults];
}

- (void)deleteGroupAtIndex:(NSUInteger)index {
    [self.groupsList removeObjectAtIndex:index];
    [self updateUserDefaults];
}
@end
