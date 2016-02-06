
#import "SBImageDownloadViewController.h"
#import <SBNetWorking/SBManager.h>

#define ROW_HEIGHT 115.0

@interface SBImageDownloadViewController () < UITableViewDelegate, UITableViewDataSource > {
    
    NSMutableArray *imageArray;
    UITableView *tblView;    
}


@end

@implementation SBImageDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SBIMAGE DOWNLOAD";
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageArray = [[NSMutableArray alloc] init];
    [imageArray addObject:@"https://www.gstatic.com/webp/gallery3/5.png"];
    [imageArray addObject:@"http://oi44.tinypic.com/16hvtok.jpg"];
    [imageArray addObject:@"http://www.google.com/intl/en_ALL/images/logo.png"];
    [imageArray addObject:@"https://www.gstatic.com/webp/gallery3/1.png"];
    [imageArray addObject:@"https://www.gstatic.com/webp/gallery3/2.png"];

    [self setUpUserInterface];

}

#pragma mark SetUp User Interface
-(void)setUpUserInterface {
    
    tblView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tblView.delegate = self;
    tblView.dataSource = self;
    tblView.showsVerticalScrollIndicator = NO;
    tblView.backgroundColor = [UIColor clearColor];
    tblView.tableHeaderView.userInteractionEnabled = YES;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tblView];
    [tblView reloadData];
    
    
}

#define LABEL1_TAG      1
#define IMAGE_TAG       2
#define INDICATOR_TAG   3

#pragma mark TableView Delegate And DataSource Function
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [imageArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"CELL-IDENTIFIER";

    UILabel *label1;
    UIImageView *imageView;
    UIActivityIndicatorView * indicator;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;


        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 8, 100, 100)];
        imageView.tag = IMAGE_TAG;
        [cell addSubview:imageView];
        
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.frame = CGRectMake(0, 0, 25, 25);
        indicator.color = [UIColor blackColor];
        indicator.tag = INDICATOR_TAG;
        [indicator hidesWhenStopped];
        indicator.center = CGPointMake(imageView.frame.size.width / 2 , imageView.frame.size.height / 2 - 5);
        [indicator startAnimating];
        [imageView addSubview:indicator];
        
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + 8, 3.0, tblView.frame.size.width - (imageView.frame.size.width + 16), ROW_HEIGHT)];
        label1.tag = LABEL1_TAG;
        label1.textColor = [UIColor purpleColor];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = [NSString stringWithFormat:@"IndexPath Section Is %ld",(long)indexPath.section];
        [cell.contentView addSubview:label1];


    }
    
    label1      = (UILabel*)[cell.contentView viewWithTag:LABEL1_TAG];
    label1.text = [NSString stringWithFormat:@"IndexPath Section Is %ld",(long)indexPath.section];
    
    imageView = (UIImageView*)[cell viewWithTag:IMAGE_TAG];
    imageView.image = [[UIImage imageNamed:@"D_Image"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.tintColor = [UIColor purpleColor];
    
    [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] startAnimating];
    
// ******** Data Task Request For Image Download, Without Cache ******** //
//    [[SBManager sharedInstance] performDataTaskWithDownlaodImageURL:imageArray[indexPath.section]
//                                                             onImageSuccess:^(UIImage *image) {
//                                                                 
//                                                                 imageView.image = image;
//                                                                 [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] stopAnimating];
//                                                                 
//                                                             } onFailure:^(NSError *error) {
//                                                                 
//                                                             }];

// ******** Data Task Request For Image Download, With Cache - Default System Cache Time ******** //
//    [[SBManager sharedInstance] performDataTaskWithCacheAndDownlaodImageURL:imageArray[indexPath.section]
//                                                             onImageSuccess:^(UIImage *image) {
//                                                                 
//                                                                 imageView.image = image;
//                                                                 [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] stopAnimating];
//                                                                 
//                                                             } onFailure:^(NSError *error) {
//                                                                 
//                                                             }];


// ******** Data Task Request For Image Download, With Cache - Image Cache Time will be different for Each Request ******** //
    [[SBManager sharedInstance] performDataTaskWithCacheAndDownlaodImageURL:imageArray[indexPath.section]
                                                   cacheExpireTimeInMinutes:10
                                                             onImageSuccess:^(UIImage *image) {
                                                                
                                                                 imageView.image = image;
                                                                 [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] stopAnimating];
                                                                 
                                                             } onFailure:^(NSError *error) {
                                                                 
                                                             }];

    
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
