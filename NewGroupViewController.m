//
//  NewGroupViewController.m
//  Troup Gext
//
//  Created by Boris Ruvinov on 2/3/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import "NewGroupViewController.h"
#import "Group.h"
#import "DataAccess.h"

@interface NewGroupViewController ()
@property (strong, nonatomic) IBOutlet UITextField *groupNameTextField;

@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupNameTextField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.groupNameTextField becomeFirstResponder];
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self createGroup];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self createGroup];
    [self dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

- (void)createGroup {
    NSString *groupName;
    if ([self.groupNameTextField.text isEqualToString:@""]) {
        groupName = @"No Name";
    } else {
        groupName = self.groupNameTextField.text;
    }
    Group *newGroup = [[Group alloc] initWithName:groupName andContacts:self.selectedContacts];
    [[DataAccess sharedDAO] addGroup:newGroup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
