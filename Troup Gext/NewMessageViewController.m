//
//  NewMessageViewController.m
//  Troup Gext
//
//  Created by Boris Ruvinov on 2/8/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import "NewMessageViewController.h"
#import "Contact.h"

@interface NewMessageViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    self.textView.text = @"Sup";
    self.textView.textColor =[UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.textView becomeFirstResponder];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.textColor == [UIColor lightGrayColor]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text  isEqual: @""]) {
        textView.text = @"Sup";
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
    if ([text length] == 1 && resultRange.location != NSNotFound) {
        [textView endEditing:YES];
        return NO;
    }
    
    return YES;
}

- (void)showSMSWithContacts:(NSArray *)contacts {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You device does not support SMS messaging." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [warningAlert addAction:defaultAction];
        [self presentViewController:warningAlert animated:YES completion:nil];

        return;
    }
    
    NSMutableArray *recipents = [[NSMutableArray alloc] init];
    NSString *message = [NSString stringWithFormat:@"%@", self.textView.text];
    
    for (Contact *contact in contacts) {
        [recipents addObject:contact.phoneNumber];
    }
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self showSMSWithContacts:self.selectedContacts];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to send message!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: @"OK"
                                                                    style: UIAlertActionStyleCancel
                                                                  handler: nil];
            [warningAlert addAction:defaultAction];
            [self presentViewController:warningAlert animated:YES completion:nil];
            
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
