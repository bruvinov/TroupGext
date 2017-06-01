//
//  Archive.h
//  Troup Gext
//
//  Created by Boris Ruvinov on 2/13/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Archive : NSObject <NSCoding>

@property (nonatomic) NSData *archiveGroupsListData;

- (instancetype) initWithData:(NSData*)groupsData;

@end
