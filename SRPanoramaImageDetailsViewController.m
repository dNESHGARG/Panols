//
//  SRPanoramaImageDetailsControllerViewController.m
//  Splitarama
//
//  Created by Dinesh Garg on 1/25/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import "SRPanoramaImageDetailsViewController.h"
#import "SRImageMetadata.h"
#import "SRImageDetailsCell.h"
#import "SRCameraSpecificationsCell.h"
#import "SRImageLocationInfoCell.h"

@interface SRPanoramaImageDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UILabel *navSubtitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *customTabBarView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *splitButton;
@property (weak, nonatomic) IBOutlet UIButton *metadataInfoButton;
@property (assign) BOOL isMetaDataOn;
@property (nonatomic, strong) SRImageMetadata *metaData;
@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) UIImage* leftImage;
@property (nonatomic, strong) UIImage* middleImage;
@property (nonatomic, strong) UIImage* rightImage;
@property (nonatomic, assign) CGImageRef inputCGImage;

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;

//@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, strong) UIImage *image;

@end

@implementation SRPanoramaImageDetailsViewController

- (instancetype)initWithAsset:(PHAsset*)asset andImage:(UIImage*)image {
    self = [super init];
    self.image = image;
    if (self != nil)
    {
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *image, NSDictionary *info) {
            self.image = image;
            self.inputCGImage = [image CGImage];
            self.data = UIImagePNGRepresentation(image);
            [self phpAssetMetadata:asset];
        }];
 
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.metaData = [[SRImageMetadata alloc] init];
    
    static NSString *CellIdentifier1 = @"SRImageDetailsCell";
    static NSString *CellIdentifier2 = @"SRImageLocationInfoCell";
    static NSString *CellIdentifier3 = @"SRCameraSpecificationsCell";
    
    UINib *nib = [UINib nibWithNibName:@"SRImageDetailsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier1];
    
    nib = [UINib nibWithNibName:@"SRImageLocationInfoCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier2];
    
    nib = [UINib nibWithNibName:@"SRCameraSpecificationsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier3];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --
- (void)phpAssetMetadata:(PHAsset*)asset {
    
    //PHFetchResult *fetchResult=[PHAsset fetchAssetsWithALAssetURLs:@[photoURL] options:nil];
    //PHAsset *asset= asset;
    
    //    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    //
    //    [[PHImageManager defaultManager]
    //     requestImageDataForAsset:asset
    //     options:imageRequestOptions
    //     resultHandler:^(NSData *imageData, NSString *dataUTI,
    //                     UIImageOrientation orientation,
    //                     NSDictionary *info)
    //     {
    //         //[uploadingFile setValue:[NSString stringWithFormat:@"%@",[info valueForKey:@"PHImageFileURLKey"]] forKey:@"filePath"];
    //         NSLog(@"Dictionary: %@", info);
    //     }];
    
    
    PHContentEditingInputRequestOptions *editOptions = [[PHContentEditingInputRequestOptions alloc]init];
    editOptions.networkAccessAllowed = YES;
    [asset requestContentEditingInputWithOptions:editOptions completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
        CIImage *image = [CIImage imageWithContentsOfURL:contentEditingInput.fullSizeImageURL];
        self.metaData = [[SRImageMetadata alloc] initImageMetadata:image.properties withImage:self.image];
        [self.tableView reloadData];
        NSLog(@"metadata: %@", image.properties.description);
    }];
}

#pragma mark --
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 274.0;
    
    if (indexPath.row == 1)
        return 370.0;
    
    if (indexPath.row == 2)
        return 420.0;
        
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier1 = @"SRImageDetailsCell";
    static NSString *CellIdentifier2 = @"SRImageLocationInfoCell";
    static NSString *CellIdentifier3 = @"SRCameraSpecificationsCell";
    
    
    if (indexPath.row == 0)
    {
        SRImageDetailsCell *cell = (SRImageDetailsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        [cell setCellWithData:self.metaData];
        cell.panImageView.image = self.image;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1)
    {
        SRImageLocationInfoCell *cell = (SRImageLocationInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        [cell setCellWithData:self.metaData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 2)
    {
        SRCameraSpecificationsCell *cell = (SRCameraSpecificationsCell *)[tableView dequeueReusableCellWithIdentifier:
                                                                          CellIdentifier3];
        [cell setCellWithData:self.metaData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
  
    
    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
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
