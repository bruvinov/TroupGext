//
//  HomeViewController.m
//  Troup Gext
//
//  Created by Boris Ruvinov on 1/31/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import "HomeViewController.h"
#import "DataAccess.h"
#import "ContactTableViewCell.h"
#import "Contact.h"
#import "NewGroupViewController.h"
#import "NewMessageViewController.h"

@interface HomeViewController ()

@property (nonatomic, retain) DataAccess *DAOContacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSMutableArray *activeList;
@property (nonatomic) NSUInteger selectedGroupIndex;
@property (nonatomic) Boolean isGroupsSelected;


@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end


@implementation HomeViewController

static NSString * const contactCellIdentifier = @"ContactCell";
static NSString * const groupCellIdentifier = @"GroupCell";

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"Grouptacts";
    [self loadInterface];
    
    self.isGroupsSelected = NO;
    
    //DELEGATES
    self.tabBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self.tabBar setSelectedItem:[[self.tabBar items] objectAtIndex:1]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (!self.DAOContacts) {
        self.DAOContacts = [DataAccess sharedDAO];
    }
    self.contactsList = self.DAOContacts.contactsList;
    self.groupsList = self.DAOContacts.groupsList;
    self.activeList = self.contactsList;
    self.searchBar.text = @"";
    
    [self clearSelectedContacts];
    [self.tableView reloadData];
    [self reloadNavButtons];
}

- (void)loadInterface {
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor clearColor]];
    [txfSearchField setLeftViewMode:UITextFieldViewModeNever];
    [txfSearchField setRightViewMode:UITextFieldViewModeNever];
    [txfSearchField setBorderStyle:UITextBorderStyleRoundedRect];
    txfSearchField.layer.borderWidth = 1.0f;
    txfSearchField.layer.cornerRadius = 10.0f;
    txfSearchField.layer.borderColor = [UIColor greenColor].CGColor;
    txfSearchField.clearButtonMode = UITextFieldViewModeAlways;
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [self.searchBar setEnablesReturnKeyAutomatically:NO];
}

- (void)clearSelectedContacts {
    if (self.selectedContacts.count ) {
        for (Contact* contact in self.contactsList) {
            contact.isSelected = NO;
            self.activeList = self.contactsList;
            [self.selectedContacts removeAllObjects];
            [self reloadNavButtons];
            [self.tableView reloadData];
        }
    }
}
/*=-=-=-=-=-=-=-=-=-=-=-=-=| NavButtons |=-=-=-=-=-=-=-=-=-=-=-=-=*/

- (void)loadLeftNavBarItem {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] init];
    
    if (self.isGroupsSelected == YES) {//groups tab active
        
    } else {//contacts tab active
        if (self.selectedContacts.count) {//selection active
            int selectedCount = (int) self.selectedContacts.count;
            NSString *titleString = [NSString stringWithFormat:@"Clear (%i)", selectedCount];
            [self changeFontOf:leftButton];
            leftButton.title = titleString;
            leftButton.style = UIBarButtonItemStylePlain;
            leftButton.target = self;
            leftButton.action = @selector(clearSelectedContacts);
        }
    }
    self.navItem.leftBarButtonItem = leftButton;
}

- (void)loadRightNavBarItem {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc] init];
    if (self.isGroupsSelected == YES) {//groups tab active
        //DO SOMETHING
        //MAYBE EDIT IN FUTURE
    } else {
        if (self.selectedContacts.count) {//selection active
            NSString *titleString = @"Message";
            [self changeFontOf:rightButton];
            rightButton.title = titleString;
            rightButton.style = UIBarButtonItemStylePlain;
            rightButton.target = self;
            rightButton.action = @selector(newMessageAction);
            
            NSString *title2 = @"Group";
            [self changeFontOf:rightButton2];
            rightButton2.title = title2;
            rightButton2.style = UIBarButtonItemStylePlain;
            rightButton2.target = self;
            rightButton2.action = @selector(newGroupButtonPressed);
            
        }
    }
    self.navItem.rightBarButtonItems = @[rightButton,rightButton2];
}

- (void)reloadNavButtons {
    [self loadLeftNavBarItem];
    [self loadRightNavBarItem];
}

- (void)changeFontOf: (UIBarButtonItem *)button {
    [button setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:11.0],
                                         NSForegroundColorAttributeName: [UIColor blueColor]
                                         } forState:UIControlStateNormal];
}

- (void)newGroupButtonPressed {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewGroupViewController *vc = (NewGroupViewController *)[sb instantiateViewControllerWithIdentifier:@"NewGroup"];
    vc.selectedContacts = [NSArray arrayWithArray:self.selectedContacts];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)newMessageAction {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewMessageViewController *vc = (NewMessageViewController *)[sb instantiateViewControllerWithIdentifier:@"NewMessage"];
    if (self.isGroupsSelected == YES) {
        vc.selectedContacts = [NSArray arrayWithArray:[self.groupsList[self.selectedGroupIndex] contacts]];
    } else {
        vc.selectedContacts = [NSArray arrayWithArray:self.selectedContacts];

    }
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

/*=-=-=-=-=-=-=-=-=-=-=-=-=| UITableViewDelegate |=-=-=-=-=-=-=-=-=-=-=-=-=*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isGroupsSelected == YES) {//groups tab active
        return self.groupsList.count;
    } else {//contacts tab selected
        return self.activeList.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isGroupsSelected == YES) {//groups tab active
        UITableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:groupCellIdentifier forIndexPath:indexPath];
        
        //text
        NSString *cellText = [self.groupsList[indexPath.row] name];
        groupCell.textLabel.text = cellText;
        
        //subtitle
        NSMutableString *subtitleText = [[NSMutableString alloc] init];
        for (Contact *contact in [self.groupsList[indexPath.row] contacts]) {
            [subtitleText appendString:[NSString stringWithFormat:@"%@. ", [contact fullName]]];
        }
        groupCell.detailTextLabel.text = subtitleText;
        
        return groupCell;
    
    } else {//contacts tab selected
        ContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:contactCellIdentifier forIndexPath:indexPath];
        
        //image
        if ([self.activeList[indexPath.row] thumbnailImgage]) {
            NSData *thumbImageData = [self.activeList[indexPath.row] thumbnailImgage];
            UIImage *thumbImage = [UIImage imageWithData:thumbImageData];
            contactCell.thumbImageView.image = thumbImage;
        } else {
            UIImage *defaultImage = [UIImage imageNamed:@"defaultthumb.png"];
            UIColor *thumbColor = [self.activeList[indexPath.row] thumbColor];
            contactCell.thumbImageView.image = defaultImage;
            contactCell.thumbImageView.image = [contactCell.thumbImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [contactCell.thumbImageView setTintColor:thumbColor];
        }
        
        //name
        NSString *cellText = [self.activeList[indexPath.row] fullName];
        contactCell.nameLabel.text = cellText;
        
        //digits
        NSString *digitsText = [self.activeList[indexPath.row] phoneNumber];
        NSString *labelText = [self.activeList[indexPath.row] label];
        contactCell.numberLabel.text = digitsText;
        contactCell.labelLabel.text = labelText;
        contactCell.contactIndex = [self.activeList[indexPath.row] contactListIndex];
        
        //check if selected
        NSUInteger contactListIndex = [[self.activeList objectAtIndex:indexPath.row] contactListIndex];

        if ([self.contactsList[contactListIndex] isSelected] == YES) {
            contactCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            contactCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return contactCell;
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isGroupsSelected == YES) {
        self.selectedGroupIndex = indexPath.row;
        [self newMessageAction];
    } else {
        if (!self.selectedContacts) {
            self.selectedContacts = [[NSMutableArray alloc] init];
        }
        NSUInteger contactListIndex = [[self.activeList objectAtIndex:indexPath.row] contactListIndex];
        Contact *selectedContact = [self.contactsList objectAtIndex:contactListIndex];
        
        if (selectedContact.isSelected == YES) {
            [self.contactsList[contactListIndex] setIsSelected:NO];
            [self.selectedContacts removeObject:selectedContact];
        } else {
            [self.contactsList[contactListIndex] setIsSelected:YES];
            [self.selectedContacts addObject:selectedContact];
        }
        
        [self.tableView reloadData];
        [self reloadNavButtons];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {//only group tab can edit
    if (self.isGroupsSelected == YES) {//groups tab selected
        return YES;
    } else {//contacts tab selected
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {//delete group from list
        [self.DAOContacts deleteGroupAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}

/*=-=-=-=-=-=-=-=-=-=-=-=-=| UISearchBarDelegate |=-=-=-=-=-=-=-=-=-=-=-=-=*/

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText  isEqual: @""]) {
        self.activeList = self.contactsList;
    } else {
        NSMutableArray *matchesContacts = [[NSMutableArray alloc] init];
        for (Contact *contact in self.contactsList) {
            if ([contact.fullName.lowercaseString containsString:searchText.lowercaseString]) {
                [matchesContacts addObject:contact];
            }
        }
        self.activeList = matchesContacts;
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

/*=-=-=-=-=-=-=-=-=-=-=-=-=| UITabBarDelegate |=-=-=-=-=-=-=-=-=-=-=-=-=*/

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"]; //access the textfield of the searchbar
    if (item.tag == 0) {//groups tab selected
        self.isGroupsSelected = YES;
        self.searchBar.userInteractionEnabled = NO;
        self.searchBar.placeholder = @"You can only search contacts";
        txfSearchField.layer.borderColor = [UIColor redColor].CGColor;
    } else if (item.tag == 1) {//contacts tab selected
        self.isGroupsSelected = NO;
        self.searchBar.userInteractionEnabled = YES;
        self.searchBar.placeholder = @"Search";
        txfSearchField.layer.borderColor = [UIColor greenColor].CGColor;
    }

    [self.tableView reloadData];
    [self reloadNavButtons];
}

/*=-=-=-=-=-=-=-=-=-=-=-=-=| MISC |=-=-=-=-=-=-=-=-=-=-=-=-=*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
