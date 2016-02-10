//
//  SRHomeTableCell.h
//  Splitarama
//
//  Created by Dinesh Garg on 2/6/16.
//  Copyright © 2016 Panols. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRHomeTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *panolsImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageName;


@end
