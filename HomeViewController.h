//
//  HomeViewController.h
//  Troup Gext
//
//  Created by Boris Ruvinov on 1/31/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, retain) NSMutableArray *contactsList;
@property (nonatomic, retain) NSMutableArray *groupsList;

@end
