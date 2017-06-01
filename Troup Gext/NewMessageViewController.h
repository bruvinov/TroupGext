//
//  NewMessageViewController.h
//  Troup Gext
//
//  Created by Boris Ruvinov on 2/8/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface NewMessageViewController : UIViewController <UITextViewDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *selectedContacts;

@end
