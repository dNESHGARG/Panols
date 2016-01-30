//
//  SRImageDetailsCell.m
//  Splitarama
//
//  Created by Dinesh Garg on 1/25/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import "SRImageDetailsCell.h"
#import "SRImageMetadata.h"

@interface SRImageDetailsCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *imageTitle;
@property (weak, nonatomic) IBOutlet UITextField *imageDescription;
@property (weak, nonatomic) IBOutlet UITextField *keywords;
@property (weak, nonatomic) IBOutlet UILabel *imageExtensionLabel;

@end

@implementation SRImageDetailsCell

- (void)awakeFromNib {
    // Initialization code
    self.panImageView.clipsToBounds = YES;
    
    //self.panImageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.frame.size.width - 30.0, 128.0);
}

- (void)setCellWithData:(SRImageMetadata*)metaData {
    self.imageExtensionLabel.layer.cornerRadius = 3.0;
    self.imageExtensionLabel.clipsToBounds = YES;
    self.panImageView.image = metaData.image;
    
    if (metaData.title.length > 0)
        self.imageTitle.text = metaData.title;
    
    if (metaData.subtitle.length > 0)
        self.imageDescription.text = metaData.subtitle;
    
    NSString *keyWordsString = [[NSString alloc] init];
    for (int i =0; i<metaData.keyWords.count; i++)
    {
        NSString *name = [NSString stringWithFormat:@"%@ ",metaData.keyWords[i]];
        [keyWordsString stringByAppendingString:name];
    }
    
    if (keyWordsString.length > 0)
        self.keywords.text = keyWordsString;
    
    if (metaData.extension.length > 0)
        self.imageExtensionLabel.text = metaData.extension;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//- (instancetype)initWithMetadat:(SRImageMetadata*)metaData {
//    self = [super init];
//    if (self != nil)
//    {
//        if (metaData.title.length > 0)
//            self.imageTitle.text = metaData.title;
//        
//        if (metaData.subtitle.length > 0)
//            self.imageDescription.text = metaData.subtitle;
//        
//        NSString *keyWordsString = [[NSString alloc] init];
//        for (int i =0; i<metaData.keyWords.count; i++)
//        {
//            NSString *name = [NSString stringWithFormat:@"%@ ", metaData.keyWords[i]];
//            [keyWordsString stringByAppendingString:name];
//        }
//        
//        if (keyWordsString.length > 0)
//            self.keywords.text = keyWordsString;
//        
//        if (metaData.extension.length > 0)
//            self.imageExtensionLabel.text = metaData.extension;
//    }
//    
//    return self;
//}

@end
