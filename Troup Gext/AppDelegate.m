//
//  AppDelegate.m
//  Troup Gext
//
//  Created by Boris Ruvinov on 1/26/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import "AppDelegate.h"
#import "Archive.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@property (nonatomic, retain) DataAccess *DAOContacts;
@property (nonatomic) NSMutableArray *archiveArray;
@property (strong, nonatomic) NSString * pathToFile;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self contactScan];
    [self loadArchiveData];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self archive];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self loadContacts];
    [self loadArchiveData];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [self archive];
}

//ARCHIVE DATA
-(void)loadArchiveData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    self.pathToFile = [documentsPath stringByAppendingPathComponent:@"groups.archive"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.pathToFile]) {
        //File exists
        self.archiveArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.pathToFile];
    }
}

- (void)archive {
    NSData *groupsListData = [[NSUserDefaults standardUserDefaults] objectForKey:@"GroupsListData"];
    
    Archive *groups = [[Archive alloc] initWithData:groupsListData];
    if (self.archiveArray) {
        [self.archiveArray replaceObjectAtIndex:0 withObject:groups];
    } else {
        self.archiveArray = [NSMutableArray array];
        [self.archiveArray addObject:groups];
    }
    
    [NSKeyedArchiver archiveRootObject:self.archiveArray toFile:self.pathToFile];
}



- (void) contactScan {
    if ([CNContactStore class]) {
        //ios9 or later
        CNEntityType entityType = CNEntityTypeContacts;
        if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
        {
            CNContactStore * contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if(granted){
//                    [self loadingScreen];
                    [self loadContacts];
                    [self loadingScreen];
                }
            }];
        }
        else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
        {
            [self loadContacts];
        }
    }
}


- (void)loadContacts {
    /*=-=-=-=-=-=-=-=-=-=Load Data=-=-=-=-=-=-=-=-=-=*/
    self.DAOContacts = [DataAccess sharedDAO];
    [self.DAOContacts fetchAllContacts];
    [self.DAOContacts getUserDefaults];
}

//- (void)loadVC {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        UIViewController *vc =[storyboard instantiateInitialViewController];
//        
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.window.rootViewController = vc;
//        [self.window makeKeyAndVisible];
//    });
//}

- (void)loadingScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Loading"
                                                             bundle:[NSBundle mainBundle]];
        UIViewController *vc =[storyboard instantiateInitialViewController];
        
        [self.window.rootViewController presentViewController:vc
                                                     animated:YES
                                                   completion:nil];
//        [self.window makeKeyAndVisible];
    });
}

@end
