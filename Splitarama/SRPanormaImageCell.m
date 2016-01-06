//
//  SRPanormaImageCell.m
//  Splitarama
//
//  Created by Dinesh Garg on 1/4/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import "SRPanormaImageCell.h"

@implementation SRPanormaImageCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SRPanormaImageCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        //self.imageView.layer.cornerRadius = 7.0;
        //self.imageView.clipsToBounds = YES;
        
    }
    
    return self;
    
}

@end
