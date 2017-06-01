//
//  ContactTableViewCell.h
//  Troup Gext
//
//  Created by Boris Ruvinov on 1/31/17.
//  Copyright © 2017 BoRuv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *numberLabel;
@property (retain, nonatomic) IBOutlet UILabel *labelLabel;
@property (nonatomic, assign) NSUInteger contactIndex;

@end
