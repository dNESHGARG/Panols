//
//  SRHomwViewController.m
//  Splitarama
//
//  Created by Dinesh Garg on 10/1/15.
//  Copyright © 2015 Dinesh Garg. All rights reserved.
//

#import "SRHomeViewController.h"

@interface SRHomeViewController () <UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *customButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (weak, nonatomic) IBOutlet UIView *panelsBackgroundView;
@property (nonatomic, strong) UIImage* leftImage;
@property (nonatomic, strong) UIImage* middleImage;
@property (nonatomic, strong) UIImage* rightImage;
@property (nonatomic, assign) CGImageRef inputCGImage;

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
@property (weak, nonatomic) IBOutlet UILabel *addImageLabel;

// Check the commits

@end

@implementation SRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.panelsBackgroundView.backgroundColor = [UIColor colorWithRed:242./255. green:243./255. blue:244./255. alpha:0.8];
    self.imageView.userInteractionEnabled = YES;
    self.customButton.enabled = NO;
    
    self.navigationController.navigationBar.hidden = true;
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
    

    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.imageView.center.y - self.imageView.image.size.height/2, self.imageView.frame.size.width/3, self.imageView.image.size.height)];
    leftButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.imageView addSubview:leftButton];
    [leftButton setTitle:@"3" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *middleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width/3, self.imageView.center.y - self.imageView.image.size.height/2, self.imageView.frame.size.width/3, self.imageView.image.size.height)];
    middleButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];;
    [self.imageView addSubview:middleButton];
    [middleButton setTitle:@"2" forState:UIControlStateNormal];
    [middleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [middleButton addTarget:self action:@selector(middleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(2*self.imageView.frame.size.width/3, self.imageView.center.y - self.imageView.image.size.height/2, self.imageView.frame.size.width/3, self.imageView.image.size.height)];
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
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.imageView.image = image;
        self.inputCGImage = [image CGImage];
        self.addImageLabel.hidden = YES;
        self.customButton.enabled = YES;
    }];
}



@end
