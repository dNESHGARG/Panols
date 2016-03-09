//
//  SRHomwViewController.m
//  Splitarama
//
//  Created by Dinesh Garg on 10/1/15.
//  Copyright © 2015 Dinesh Garg. All rights reserved.
//

#import "SRHomeViewController.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SRPanormaImageCell.h"
#import "SRPanolsImageCell.h"
#import "SRPanoramaHeaderView.h"
#import "SRPanoramaImageDetailsViewController.h"
#import "SRHomeTableCell.h"

#define ALBUM_NAME @"Panols"

@import Photos;
@import ImageIO;

@interface SRHomeViewController () <UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_fakeNames;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *customButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (weak, nonatomic) IBOutlet UIView *panelsBackgroundView;
@property (nonatomic, strong) UIImage* leftImage;
@property (nonatomic, strong) UIImage* middleImage;
@property (nonatomic, strong) UIImage* rightImage;
@property (nonatomic, assign) CGImageRef inputCGImage;

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
@property (weak, nonatomic) IBOutlet UILabel *addImageLabel;

@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, strong) NSData *data;
@property (weak, nonatomic) IBOutlet UIView *navigationHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *navigationHeaderImageView;

@property (weak, nonatomic) IBOutlet UIImageView *navigationLogo;

@property (nonatomic, strong) NSMutableArray *galleryImages;
@property (nonatomic, strong) NSMutableArray *panolsImages;
@property (nonatomic, strong) NSMutableArray *panolImages;

@property (strong, nonatomic) IBOutlet UIView *imagebackgrounView;
// Check the commits
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic) float panoramaImageWidth;

@property (nonatomic, strong) SRPanoramaHeaderView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (assign) BOOL refreshGalleries;

@property (weak, nonatomic) IBOutlet UITableView *panolsGalleryEmptyLabel;

@end

@implementation SRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.panelsBackgroundView.backgroundColor = [UIColor colorWithRed:34./255. green:34./255. blue:34./255. alpha:1.0];
    //    self.navigationHeaderView.backgroundColor = [UIColor colorWithRed:243./255. green:243./255. blue:245./255. alpha:1.0];
    //    self.navigationHeaderView.layer.shadowOpacity = 1.00f;
    //    self.navigationHeaderView.layer.shadowOffset = CGSizeMake(0,0);
    //    self.navigationHeaderView.layer.shadowRadius = 20;
    //    self.navigationHeaderView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationHeaderView.bounds].CGPath;
    //    self.navigationHeaderView.layer.shadowColor = [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:0.3].CGColor;
    
    //self.navigationHeaderImageView.backgroundColor = [UIColor colorWithRed:243./255. green:243./255. blue:245./255. alpha:1.0];
    //[self.customButton setTitleColor:[UIColor colorWithRed:216./255. green:216./255. blue:216./255. alpha:1.0] forState:UIControlStateNormal];
    self.imageView.userInteractionEnabled = YES;
    self.customButton.enabled = YES;
    //self.customButton.layer.shadowColor = [UIColor colorWithRed:208./255. green:208./255. blue:210./255. alpha:1.0].CGColor;
    
    [self.navigationHeaderView bringSubviewToFront:self.galleryButton];
    self.navigationController.navigationBar.hidden = true;
    //self.imageView.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.0];
    
    self.galleryImages = [[NSMutableArray alloc] init];
    self.panolImages = [[NSMutableArray alloc] init];
    
    [self getGallery];
    [self getPanolsImages];
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //[self.tableView registerClass:[SRPanoramaHeaderView class] forHeaderFooterViewReuseIdentifier:@"SRPanoramaHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SRPanoramaHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SRPanoramaHeaderView"];
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"SRPanoramaHeaderView"
                                                      owner:self
                                                    options:nil];
    
    self.tableHeaderView = [nibViews objectAtIndex:0];
    
    //UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SRPanoramaHeaderView"];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    _fakeNames = @[@"YOSEMITE", @"YOSEMITE", @"YOSEMITE FALLS", @"Blue Sky", @"Panorama Lake", @"Sierra Nevada"];
    
    [self.tableHeaderView.panoramasCollectionView registerClass:[SRPanormaImageCell class] forCellWithReuseIdentifier:@"SRPanormaImageCell"];
    
    float cellWidth = self.view.frame.size.width - 60.0;
    float cellHeight = 128.0f;
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(cellWidth, cellHeight)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.flowLayout.minimumInteritemSpacing = 30.0f;
    [self.tableHeaderView.panoramasCollectionView setCollectionViewLayout:self.flowLayout];
    self.tableHeaderView.panoramasCollectionView.bounces = YES;
    [self.tableHeaderView.panoramasCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.tableHeaderView.panoramasCollectionView setShowsVerticalScrollIndicator:NO];
    
    self.tableHeaderView.panoramasCollectionView.delegate =  self;
    self.tableHeaderView.panoramasCollectionView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshGallery:)
                                                 name:@"RefreshGallery"
                                               object:nil];
    
    self.refreshGalleries = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (self.refreshGalleries)
        [self refreshImages];
}

- (void)refreshImages {
    [self.galleryImages removeAllObjects];
    self.galleryImages = nil;
    
    [self.panolImages removeAllObjects];
    self.panolImages = nil;
    
    if(!self.galleryImages)
        self.galleryImages = [[NSMutableArray alloc] init];
    
    if(!self.panolImages)
        self.panolImages = [[NSMutableArray alloc] init];
    
    [self getGallery];
    [self getPanolsImages];
    
    self.refreshGalleries = NO;
}

- (void) refreshGallery:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    self.refreshGalleries = YES;
    
}

- (void)dealloc{
    //CGImageRelease(self.inputCGImage);
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.imagebackgrounView removeFromSuperview];
}


- (void)getGallery{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.wantsIncrementalChangeDetails = YES;
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumPanoramas options:nil];
    PHFetchResult *fetchResult;
    for (PHAssetCollection *sub in albums)
    {
        fetchResult = [PHAsset fetchAssetsInAssetCollection:sub options:options];
    }
    
    for (PHAsset *asset in fetchResult) {
        [self.galleryImages addObject:asset];
    }
    
    //    if(self.galleryImages.count == 0)
    //        self.tableHeaderView.panoramaImagesEmptyLabel.hidden = NO;
    //    else
    //        self.tableHeaderView.panoramaImagesEmptyLabel.hidden = YES;
    
    [self.tableHeaderView.panoramasCollectionView reloadData];
    
}

- (void)getPanolsImages{
    PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:userAlbumsOptions];
    
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        if([collection.localizedTitle isEqualToString:@"Panols Gallery"])
        {
            PHFetchResult *fetchResult;
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.wantsIncrementalChangeDetails = YES;
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
            
            fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            
            for (PHAsset *asset in fetchResult) {
                NSInteger num = asset.mediaSubtypes;
                if(num == 1)
                {
                    [self.panolImages addObject:asset];
                }
            }
            [self.tableView reloadData];
        }
    }];
    
    //    if(self.panolImages.count == 0)
    //    {
    //        self.panolsGalleryEmptyLabel.hidden = NO;
    //    }
    //    else
    //        self.panolsGalleryEmptyLabel.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (IBAction)customButtonTapped:(id)sender {
    [self splitImage];
}

- (IBAction)galleryButtonTapped:(id)sender {
    self.metadata = nil;
    [self selectImage];
}

# pragma mark -

-(void)splitImage
{
    
    if (self.leftImage)
        self.leftImage = nil;
    
    if (self.middleImage)
        self.middleImage = nil;
    
    if (self.rightImage)
        self.rightImage = nil;
    
    if (!self.inputCGImage)
        return;
    
    
    self.width = CGImageGetWidth(self.inputCGImage);
    self.height = CGImageGetHeight(self.inputCGImage);
    
    CGRect leftImgFrame = CGRectMake(0, 0, self.width/3, self.height);
    CGRect middleImgFrame = CGRectMake(self.width/3, 0, self.width/3, self.height);
    CGRect rightImgFrame = CGRectMake(2*self.width/3, 0, self.width/3, self.height);
    
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(self.imagebackgrounView.frame.origin.x, self.imageView.center.y , self.imageView.frame.size.width/3, 200.0)];
    leftButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.imageView addSubview:leftButton];
    [leftButton setTitle:@"3" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *middleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.imagebackgrounView.frame.size.width/3, self.imageView.center.y, self.imageView.frame.size.width/3, 200.0)];
    middleButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];;
    [self.imageView addSubview:middleButton];
    [middleButton setTitle:@"2" forState:UIControlStateNormal];
    [middleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [middleButton addTarget:self action:@selector(middleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(2*self.imagebackgrounView.frame.size.width/3, self.imageView.center.y, self.imageView.frame.size.width/3, 200.0)];
    rightButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];;
    [self.imageView addSubview:rightButton];
    [rightButton setTitle:@"1" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGImageRef left = CGImageCreateWithImageInRect(self.inputCGImage, leftImgFrame);
    CGImageRef middle = CGImageCreateWithImageInRect(self.inputCGImage, middleImgFrame);
    CGImageRef right = CGImageCreateWithImageInRect(self.inputCGImage, rightImgFrame);
    
    self.leftImage = [UIImage imageWithCGImage:left];
    self.middleImage = [UIImage imageWithCGImage:middle];
    self.rightImage = [UIImage imageWithCGImage:right];
    
    
    CGImageRelease(left);
    CGImageRelease(middle);
    CGImageRelease(right);
    CGImageRelease(self.inputCGImage);
    
}

- (void)leftButtonTapped:(UIButton*)sender {
    [self writeMetadataToCreatedImage:self.leftImage];
    [self shareOnInstagram:self.leftImage];
}

- (IBAction)middleButtonTapped:(id)sender {
    [self shareOnInstagram:self.middleImage];
}

- (IBAction)rightButtonTapped:(id)sender {
    [self shareOnInstagram:self.rightImage];
}

- (void)shareOnInstagram:(UIImage*)image {
    NSString* imagePath = [NSString stringWithFormat:@"%@/instagramShare.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    NSLog(@"Image Size >>> %@", NSStringFromCGSize(image.size));
    
    self.documentController=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    self.documentController.delegate = self;
    self.documentController.UTI = @"com.instagram.exclusivegram";
    [self.documentController presentOpenInMenuFromRect: self.view.frame inView:self.view animated:YES ];
}

#pragma mark -
#pragma mark --

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.galleryImages.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SRPanormaImageCell";
    
    SRPanormaImageCell *cell = (SRPanormaImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 7.0;
    
    cell.layer.shadowOpacity = 1.00f;
    cell.layer.shadowOffset = CGSizeMake(10,10);
    cell.layer.shadowRadius = 20;
    cell.layer.shadowColor = [UIColor colorWithRed:208./255. green:208./255. blue:210./255. alpha:1.0].CGColor;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    
    
    //cell.layer.shouldRasterize = YES;
    
    PHAsset *asset = self.galleryImages[indexPath.row];
    //PHImageManager *imageManager;
    CGSize size = CGSizeMake(140.0, 128.0);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.imageView.image = result;
    }];
    
    return cell;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0.0, 50.0, 0.0, 0.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = self.galleryImages[indexPath.row];
    //PHImageManager *imageManager;
    //[self phpAssetMetadata:asset];
    SRPanoramaImageDetailsViewController *detailsController = [[SRPanoramaImageDetailsViewController alloc] initWithAsset:asset andImage:self.galleryImages[indexPath.row]];
    [self.navigationController pushViewController:detailsController animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float cellWidth = self.tableHeaderView.panoramasCollectionView.frame.size.width - 90.0;
    float cellHeight = 128.0f;
    return CGSizeMake(cellWidth, cellHeight);
}


# pragma mark -

- (void)selectImage {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    //UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //NSURL *url =  [info objectForKey:UIImagePickerControllerReferenceURL];
    //[self phpAssetMetadata:url];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSURL *photoURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSArray *array = [[NSArray alloc] initWithObjects:photoURL, nil];
        PHFetchResult* assets =[PHAsset fetchAssetsWithALAssetURLs:array options:nil];
        for(PHAsset *asset in assets)
        {
            //[self.galleryImages insertObject:asset atIndex:0];
            [self.galleryImages insertObject:asset atIndex:0];
            SRPanoramaImageDetailsViewController *detailsController = [[SRPanoramaImageDetailsViewController alloc] initWithAsset:asset andImage:self.galleryImages[0]];
            [self.navigationController pushViewController:detailsController animated:YES];
        }
    }];
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
        self.metadata = image.properties;
        
        NSLog(@"metadata: %@", image.properties.description);
    }];
}

#pragma mark --

//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (collectionView == self.panolsCollectionView){
//        static NSString *cellIdentifier = @"SRPanolsImageCell";
//
//        SRPanolsImageCell *cell = (SRPanolsImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//        cell.layer.masksToBounds = YES;
//        cell.layer.cornerRadius = 5.0;
//
//        cell.layer.shadowOpacity = 1.00f;
//        cell.layer.shadowOffset = CGSizeZero;
//        cell.layer.shadowColor = [UIColor colorWithRed:208./255. green:208./255. blue:210./255. alpha:1.0].CGColor;
//        cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
//        //cell.layer.shouldRasterize = YES;
//
//        return cell;
//    }
//
//
//    if (collectionView == self.panormasCollectionView){
//        static NSString *cellIdentifier = @"SRPanormaImageCell";
//
//        SRPanormaImageCell *cell = (SRPanormaImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//        cell.layer.masksToBounds = YES;
//        cell.layer.cornerRadius = 7.0;
//
//        cell.layer.shadowOpacity = 1.00f;
//        cell.layer.shadowOffset = CGSizeMake(10,10);
//        cell.layer.shadowColor = [UIColor colorWithRed:208./255. green:208./255. blue:210./255. alpha:1.0].CGColor;
//        cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
//        //cell.layer.shouldRasterize = YES;
//
//        PHAsset *asset = self.galleryImages[indexPath.row];
//        //PHImageManager *imageManager;
//        CGSize size = CGSizeMake(140.0, 128.0);
//        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
//            cell.imageView.image = result;
//        }];
//
//        return cell;
//    }
//
//    //cell.imageView.image = [UIImage imageNamed:@"panormaImage"];
//
//    return [[UICollectionViewCell alloc] init];
//
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (collectionView == self.panormasCollectionView){
//        PHAsset *asset = self.galleryImages[indexPath.row];
//        SRPanoramaImageDetailsViewController *detailsController = [[SRPanoramaImageDetailsViewController alloc] initWithAsset:asset andImage:self.galleryImages[indexPath.row]];
//        [self.navigationController pushViewController:detailsController animated:YES];
//
//    }
//
//}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//
//    if (kind == UICollectionElementKindSectionHeader) {
//        for (int i = 0; i < 10; i++) {
//        SRPanoramaHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SRPanoramaHeaderView" forIndexPath:indexPath];
//
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0 + self.panoramaImageWidth + 10.0, 0.0, self.panoramaImageWidth, 128.0)];
//        [headerView addSubview:imageView];
//        imageView.image = [UIImage imageNamed:@"panormaImage"];
//        reusableview = headerView;
//        }
//    }
//
//    return reusableview;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(60.0f, 30.0f);
//}



#pragma mark -
- (NSString *)pathForPanolsDirectory {
    //    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
    //                                                                        NSUserDomainMask,
    //                                                                        YES) lastObject];
    //    NSString *panolsPhotoFolder = [documentsDirectory stringByAppendingPathComponent:@"/Panols"];
    //
    //    // Create the folder if necessary
    //    BOOL isDir = NO;
    //    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //    if (![fileManager fileExistsAtPath:panolsPhotoFolder
    //                           isDirectory:&isDir] && isDir == NO) {
    //        [fileManager createDirectoryAtPath:panolsPhotoFolder
    //               withIntermediateDirectories:NO
    //                                attributes:nil
    //                                     error:nil];
    //    }
    //    return panolsPhotoFolder;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Panols"];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    return dataPath;
}

- (void)deletContentFromPanolsDirectory:(NSString*)fileName {
    NSString *panolsPhotoFolder = [self pathForPanolsDirectory];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:panolsPhotoFolder error:nil];
    for (NSString *filename in contents)  {
        if ([filename isEqualToString:fileName])
            [[NSFileManager defaultManager] removeItemAtPath:[panolsPhotoFolder stringByAppendingPathComponent:filename] error:NULL];
    }
    
}

- (void)writeMetadataToCreatedImage:(UIImage*)inputImage{
    NSData *imageData = UIImagePNGRepresentation(inputImage);
    CIImage *image = [CIImage imageWithData:imageData];
    NSLog(@"Image Properties: %@", image.properties);
    
    // Save off the properties
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef) self.data, nil);
    //NSDictionary* metadata = (__bridge NSDictionary *) CGImageSourceCopyProperties(imageSource, NULL);
    
    // process your image
    // ...
    //NSData *outputData = // create data from altered image.
    
    // Save the image
    CGImageSourceRef outputImageSource = CGImageSourceCreateWithData((__bridge CFDataRef) imageData, nil);
    NSMutableData *dest_data = [NSMutableData data];
    //CFMutableDataRef jpegData = CFDataCreateMutable(NULL, 0);
    CGImageDestinationRef outputDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data, CGImageSourceGetType(outputImageSource), 1, NULL);
    
    // add the image data to the destination
    //CGImageDestinationRef imageDestinationRef = CGImageDestinationCreateWithURL((__bridge CFURLRef)directoryURL, kUTTypeJPEG, 1, NULL);
    CFDictionaryRef dict = (__bridge CFDictionaryRef)self.metadata;
    CGImageDestinationAddImageFromSource(outputDestination, imageSource, 0, dict);
    
    if (CGImageDestinationFinalize(outputDestination)) {
        NSLog(@"Successful image creation.");
        // process the image rendering, adjustment data creation and finalize the asset edit.
        
        //        NSString *dataPath = [self pathForPanolsDirectory]; // Get documents folder
        //
        //        NSString *fullPath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.jpg", [NSDate date]]]; //add our image to the path
        //
        //        [dest_data writeToFile:fullPath atomically:YES];
        
        [self saveToAlbum:dest_data];
        
        
    } else {
        NSLog(@"Image creation failed.");
    }
    
    CFRelease(imageSource);
    CFRelease(outputImageSource);
    //CFRelease(jpegData);
    CFRelease(outputDestination);
    CFRelease(dict);
}

//
//- (void)saveImageToPanolsGallery:(UIImage*)image {
//    __block PHFetchResult *photosAsset;
//    __block PHAssetCollection *collection;
//    __block PHObjectPlaceholder *placeholder;
//
//     NSData *imageDate = UIImagePNGRepresentation(image);
//
//    // Find the album
//    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
//    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"Panols Gallery"];
//    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
//                                                          subtype:PHAssetCollectionSubtypeAny
//                                                          options:fetchOptions].firstObject;
//    // Create the album
//    if (!collection)
//    {
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            PHAssetCollectionChangeRequest *createAlbum = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Panols Gallery"];
//            placeholder = [createAlbum placeholderForCreatedAssetCollection];
//        } completionHandler:^(BOOL success, NSError *error) {
//            if (success)
//            {
//                PHFetchResult *collectionFetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[placeholder.localIdentifier]
//                                                                                                            options:nil];
//                collection = collectionFetchResult.firstObject;
//            }
//        }];
//    }
//
//    // Save to the album
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageWithData:imageDate]];
//        placeholder = [assetRequest placeholderForCreatedAsset];
//        photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
//        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection
//                                                                                                                      assets:photosAsset];
//        [albumChangeRequest addAssets:@[placeholder]];
//    } completionHandler:^(BOOL success, NSError *error) {
//        if (success)
//        {
//            NSString *UUID = [placeholder.localIdentifier substringToIndex:36];
//            //self.photo.assetURL = [NSString stringWithFormat:@"assets-library://asset/asset.PNG?id=%@&ext=JPG", UUID];
//            //[self savePhoto];
//        }
//        else
//        {
//            NSLog(@"%@", error);
//        }
//    }];
//}

#pragma mark --
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.panolImages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SRHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SRHomeTableCell"];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SRHomeTableCell" bundle:nil] forCellReuseIdentifier:@"SRHomeTableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SRHomeTableCell"];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRHomeTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // To-DO Remove this shit
    //    if (indexPath.row>0)
    //        cell.panolsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"temp%ld",indexPath.row]];
    //    else
    //        cell.panolsImageView.image = [UIImage imageNamed:@"panormaImage"];
    
    PHAsset *asset = self.panolImages[indexPath.row];
    //PHImageManager *imageManager;
    CGSize size = CGSizeMake(325.0, 101.0);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.panolsImageView.image = result;
    }];
    
    cell.imageName.text = _fakeNames[indexPath.row%6];
    
    cell.contentBackgroundView.layer.masksToBounds = YES;
    //cell.contentBackgroundView.layer.cornerRadius = 7.0;
    
    cell.panolsImageView.layer.cornerRadius = 5;
    cell.panolsImageView.layer.masksToBounds = YES;
    cell.contentBackgroundView.layer.masksToBounds = YES;
    cell.contentView.layer.masksToBounds = YES;
    cell.layer.masksToBounds = YES;
    
    cell.panolsImageView.layer.shadowOpacity = 1.00f;
    cell.panolsImageView.layer.shadowOffset = CGSizeMake(0,0);
    cell.panolsImageView.layer.shadowRadius = 20;
    cell.panolsImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.panolsImageView.bounds].CGPath;
    cell.panolsImageView.layer.shadowColor = [UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:0.3].CGColor;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.panolImages[indexPath.row];
    //PHImageManager *imageManager;
    //[self phpAssetMetadata:asset];
    SRPanoramaImageDetailsViewController *detailsController = [[SRPanoramaImageDetailsViewController alloc] initWithAsset:asset andImage:self.galleryImages[indexPath.row]];
    [self.navigationController pushViewController:detailsController animated:YES];
}

- (BOOL)saveToAlbum:(NSData*)data{
    __block BOOL retStat = false;
    //NSData *newImageSize = UIImageJPEGRepresentation(image, 1);
    UIImage *imageNew = [UIImage imageWithData:data];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHFetchResult *photosAsset;
        PHAssetCollection *collection = [self findAlbumAssetCollection:ALBUM_NAME];
        PHObjectPlaceholder *placeholder;
        placeholder = [[PHAssetChangeRequest creationRequestForAssetFromImage:imageNew] placeholderForCreatedAsset];
        photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection assets:photosAsset];
        [albumChangeRequest addAssets:@[placeholder]];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success){
            retStat = true;
        }
        else{
            NSLog(@"%@", error);
        }}];
    return  retStat;
}


- (PHAssetCollection*)findAlbumAssetCollection:(NSString*)albumName{
    PHAssetCollection *collection;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", ALBUM_NAME];
    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                          subtype:PHAssetCollectionSubtypeAny
                                                          options:fetchOptions].firstObject;
    return collection;
}

@end
