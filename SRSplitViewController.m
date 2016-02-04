//
//  SRSplitViewController.m
//  Splitarama
//
//  Created by Dinesh Garg on 2/2/16.
//  Copyright © 2016 Panols. All rights reserved.
//

#import "SRSplitViewController.h"
#import "SRImageMetadata.h"

@interface SRSplitViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *navHeader;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) CGImageRef inputCGImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat aspectRatio;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (weak, nonatomic) IBOutlet UIView *scrollViewTopView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *splitCropView;
@property (strong, nonatomic) IBOutlet UIView *translucentView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation SRSplitViewController

- (instancetype)initWithWithData:(SRImageMetadata*)metaData andCGImage:(CGImageRef)cgImage; {
    self = [super init];
    
    if (self != nil)
    {
        self.inputCGImage = cgImage;
        self.image = metaData.image;
        
        self.width = CGImageGetWidth(self.inputCGImage);
        self.height = CGImageGetHeight(self.inputCGImage);
        self.aspectRatio = self.width/self.height;
    }
    
    return self;
}

- (void)dealloc{
    CFRelease(self.inputCGImage);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.imageView.image = self.image;
    
    self.contentView.frame = CGRectMake(0.0, 87.0, self.view.frame.size.width, self.view.frame.size.height-107-self.tabBarView.frame.size.height+20.0);
    
    self.scrollView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [self.scrollView setContentSize:(CGSizeMake(self.scrollView.frame.size.height*self.aspectRatio, self.view.frame.size.height))];
    
    self.imageView.frame = CGRectMake(0.0, 0.0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.scrollViewTopView.frame = CGRectMake(0.0, 0.0, self.scrollView.contentSize.width, self.scrollViewTopView.frame.size.height);
    self.scrollViewBottomView.frame = CGRectMake(0.0, self.scrollViewBottomView.frame.origin.y, self.scrollView.contentSize.width, self.scrollViewBottomView.frame.size.height);
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.translucentView];
    //self.scrollView.center = self.view.center;
    self.imageView.center = self.scrollView.center;
    self.translucentView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.scrollViewTopView.frame = CGRectMake(0.0, 0.0, self.translucentView.frame.size.width, (self.translucentView.frame.size.height-self.splitCropView.frame.size.height)/2);
    self.scrollViewBottomView.frame = CGRectMake(0.0, self.scrollViewTopView.frame.size.height+self.splitCropView.frame.size.height, self.translucentView.frame.size.width, (self.translucentView.frame.size.height-self.splitCropView.frame.size.height)/2);
    self.splitCropView.center = self.translucentView.center;
    self.imageView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y);
    //self.translucentView.center = self.view.center;
    [self.view bringSubviewToFront:self.tabBarView];
    [self.view bringSubviewToFront:self.navHeader];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --

- (IBAction)backButtontapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)straightenButtonTapped:(id)sender {
}

- (IBAction)fillButtonTapped:(id)sender {
}

- (IBAction)exportButtonTapped:(id)sender {
}

#pragma mark --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat diff = scrollView.contentOffset.x;
//    float height = self.scrollViewTopView.frame.size.height + diff;
//    self.scrollViewTopView.frame = CGRectMake(self.scrollViewTopView.frame.origin.x, self.scrollViewTopView.frame.origin.y, self.scrollViewTopView.frame.size.width, height);
//    
//    height = self.scrollViewBottomView.frame.size.height - diff;
//    self.scrollViewBottomView.frame = CGRectMake(self.scrollViewBottomView.frame.origin.x, self.scrollViewBottomView.frame.origin.y - diff, self.scrollViewBottomView.frame.size.width, self.scrollViewBottomView.frame.size.height-diff);
//    NSLog(@"diff is %f:", diff);
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
