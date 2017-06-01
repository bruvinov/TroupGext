//
//  Archive.m
//  Troup Gext
//
//  Created by Boris Ruvinov on 2/13/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import "Archive.h"

@implementation Archive


- (instancetype) initWithData:(NSData *)groupsData {
    self = [super init];
    if (self) {
        self.archiveGroupsListData = groupsData;
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    //Used when saving to disk
    [aCoder encodeObject:self.archiveGroupsListData forKey:@"GroupsListData"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    //Used when reading from disk
    self = [super init];
    if (self) {
        self.archiveGroupsListData = [aDecoder decodeObjectForKey:@"GroupsListData"];
    }
    return self;
}



@end
