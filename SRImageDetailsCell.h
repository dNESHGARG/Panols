//
//  SRImageDetailsCell.h
//  Splitarama
//
//  Created by Dinesh Garg on 1/25/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRImageMetadata;

@interface SRImageDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *panImageView;
- (void)setCellWithData:(SRImageMetadata*)metaData;

@end
