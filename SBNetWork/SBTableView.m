

#import "SBTableView.h"
#import <UIKit/UIKit.h>
#import "SBDetailsViewController.h"

#import <SBNetWorking/SBNetWorking.h>

#define ROW_HEIGHT 115.0
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define HEADER_COLOR                [UIColor colorWithRed:56.0/255 green:185.0/255 blue:158.0/255 alpha:1]

@interface SBTableView () < UITableViewDelegate, UITableViewDataSource > {
    
    NSMutableArray *fileArray;
    UITableView *tblView;
    SBDownloadFileType sBDownloadFileType;
}

@end

@implementation SBTableView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpUserInterface];
    }
    return self;
    
}

#pragma mark SetUp User Interface
-(void)setUpUserInterface {
    
    tblView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tblView.delegate = self;
    tblView.dataSource = self;
    tblView.showsVerticalScrollIndicator = NO;
    tblView.backgroundColor = [UIColor clearColor];
    tblView.tableHeaderView.userInteractionEnabled = YES;
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tblView];
    
}

-(void)setFileArrayValue:(NSArray*)fileArrayValue sbDownloadFileType:(SBDownloadFileType)sbDownloadFileType {
    
    fileArray = [[NSMutableArray alloc] init];
    [fileArray addObjectsFromArray:fileArrayValue];
    sBDownloadFileType = sbDownloadFileType;
    
    [tblView reloadData];
    
}
#define LABEL1_TAG                      1
#define IMAGE_TAG                       2
#define INDICATOR_TAG                   3
#define PROGRESS_VIEW_D_TAG             4
#define PAUSE_RESUME_FILE_TAG           5
#define DELETE_FILE_TAG                 6

#pragma mark TableView Delegate And DataSource Function
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [fileArray count];
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
    UIProgressView *progressView;
    UIButton *pauseResumeFileButton, *deleteFileButton;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //add AsyncImageView to cell
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
        
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + 8, 3.0, tblView.frame.size.width - (imageView.frame.size.width + 16 + 40), ROW_HEIGHT)];
        label1.tag = LABEL1_TAG;
        label1.textColor = HEADER_COLOR;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = [NSString stringWithFormat:@"INDEX %ld",(long)indexPath.section];
        [cell.contentView addSubview:label1];
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [progressView setProgress: 0.0 animated:YES];
        progressView.tag = PROGRESS_VIEW_D_TAG;
        [cell.contentView addSubview:progressView];
        
        pauseResumeFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pauseResumeFileButton.tag = PAUSE_RESUME_FILE_TAG;
        [pauseResumeFileButton addTarget:self action:@selector(performPauseResumeFileButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:pauseResumeFileButton];
        
        deleteFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteFileButton.tag = DELETE_FILE_TAG;
        [deleteFileButton addTarget:self action:@selector(performDeleteFileButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteFileButton];
        
        
        
    }
    
    
    label1      = (UILabel*)[cell.contentView viewWithTag:LABEL1_TAG];
    label1.text = [NSString stringWithFormat:@"INDEX %ld",(long)indexPath.section];
    
    imageView = (UIImageView*)[cell viewWithTag:IMAGE_TAG];
    imageView.image = [[self tableViewCellImageType:sBDownloadFileType] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.tintColor = HEADER_COLOR;
    
    [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] startAnimating];
    
    ((UIProgressView *)[cell.contentView viewWithTag:PROGRESS_VIEW_D_TAG]).frame=CGRectMake(2, ROW_HEIGHT , tblView.frame.size.width - 4, 20);
    
    ((UIProgressView *)[cell.contentView viewWithTag:PROGRESS_VIEW_D_TAG]).hidden = NO;
    ((UIProgressView *)[cell.contentView viewWithTag:PROGRESS_VIEW_D_TAG]).progress = 0.0;
    
    [((UIButton *)[cell.contentView viewWithTag:PAUSE_RESUME_FILE_TAG]) setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
    [((UIButton *)[cell.contentView viewWithTag:PAUSE_RESUME_FILE_TAG]) setImage:[UIImage imageNamed:@"Resume"] forState:UIControlStateSelected];
    [((UIButton *)[cell.contentView viewWithTag:DELETE_FILE_TAG]) setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    ((UIButton *)[cell.contentView viewWithTag:DELETE_FILE_TAG]).frame=CGRectMake(tblView.frame.size.width - 45, 12 , 38, 38);
    ((UIButton *)[cell.contentView viewWithTag:PAUSE_RESUME_FILE_TAG]).frame=CGRectMake(tblView.frame.size.width - 45, 62 , 38, 38);
    
    ((UIButton *)[cell.contentView viewWithTag:PAUSE_RESUME_FILE_TAG]).hidden = NO;
    ((UIButton *)[cell.contentView viewWithTag:DELETE_FILE_TAG]).hidden= NO;
    
    // Download Task Request For Files Download, Without Cache
    //    [[SBManager sharedInstance] performDownloadTaskWithDownlaodFileURL:fileArray [indexPath.section]
    //                                                    onDownloadTaskData:^(NSData *data) {
    //
    //
    //                                                    } onFailure:^(NSError *error) {
    //
    //
    //                                                    } onDownloadProgress:^(double progressValue) {
    //
    //                                                    }];
    //
    
    // Download Task Request For Files Download, With Cache - Default System Cache Time
    //    [[SBManager sharedInstance] performDownloadTaskWithCacheAndDownlaodFileURL:fileArray [indexPath.section]
    //                                                            onDownloadTaskData:^(NSData *data) {
    //
    //                                                            } onFailure:^(NSError *error) {
    //
    //                                                            } onDownloadProgress:^(double progressValue) {
    //
    //                                                            }];
    
    
    // Download Task Request For Files Download, With Cache - File Cache Time will be different for Each Request
      [[SBManager sharedInstance] performDownloadTaskWithCacheAndDownlaodFileURL:fileArray [indexPath.section]
                                                       cacheExpireTimeInMinutes:10
                                                    onDownloadTaskData:^(NSData *data) {
                                                        
                                                        ((UIProgressView *)[cell.contentView viewWithTag:PROGRESS_VIEW_D_TAG]).hidden = YES;
                                                        [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] stopAnimating];
                                                        ((UIButton *)[cell.contentView viewWithTag:PAUSE_RESUME_FILE_TAG]).hidden = YES;
                                                        ((UIButton *)[cell.contentView viewWithTag:DELETE_FILE_TAG]).hidden= YES;
                                                        
                                                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                                                        
                                                        
                                                        switch (sBDownloadFileType) {
                                                                
                                                            case SBDownloadFileTypeImage: {
                                                                
                                                                cell.accessoryType = UITableViewCellAccessoryNone;
                                                                
                                                                UIImage *image = [UIImage imageWithData:data];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    ((UIImageView*)[cell viewWithTag:IMAGE_TAG]).image = image;
                                                                    
                                                                });
                                                                
                                                            }
                                                                
                                                                break;
                                                                
                                                            case SBDownloadFileTypeVideo: {
                                                                
                                                                [self addFilesInDocumentDirectory:data
                                                                                         fileName:[NSString stringWithFormat:@"Video%ld.mp4",(long)indexPath.section] fileType:@"VIDEOS"];
                                                                
                                                            }
                                                                
                                                                break;
                                                                
                                                            case SBDownloadFileTypeAudio: {
                                                                [self addFilesInDocumentDirectory:data
                                                                                         fileName:[NSString stringWithFormat:@"Audio%ld.mp3",(long)indexPath.section] fileType:@"AUDIOS"];
                                                                
                                                            }
                                                                
                                                                
                                                                break;
                                                                
                                                            case SBDownloadFileTypePDF: {
                                                                
                                                                [self addFilesInDocumentDirectory:data
                                                                                         fileName:[NSString stringWithFormat:@"PDF%ld.PDF",(long)indexPath.section] fileType:@"PDFS"];
                                                                
                                                            }
                                                                
                                                                
                                                                break;
                                                                
                                                            default:
                                                                break;
                                                        }
                                                        
                                                        
                                                    } onFailure:^(NSError *error) {
                                                        
                                                        NSLog(@"ERROR DOWN %@",error.localizedDescription);
                                                        
                                                    } onDownloadProgress:^(double progressValue) {
                                                        
                                                        NSLog(@"progressValue %f \n SBDownlaodTaskType %ld",progressValue, (long)sBDownloadFileType);
                                                        
                                                        ((UIProgressView *)[cell.contentView viewWithTag:PROGRESS_VIEW_D_TAG]).progress = progressValue;
                                                        
                                                    }];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fileType = @"";
    NSString *fileName = @"";
    
    switch (sBDownloadFileType) {
            
        case SBDownloadFileTypeVideo:
            fileType = @"VIDEOS";
            fileName = [NSString stringWithFormat:@"/Video%ld.mp4",(long)indexPath.section];
            break;
            
        case SBDownloadFileTypeAudio:
            fileType = @"AUDIOS";
            fileName = [NSString stringWithFormat:@"/Audio%ld.mp3",(long)indexPath.section];
            break;
            
        case SBDownloadFileTypePDF:
            fileType = @"PDFS";
            fileName = [NSString stringWithFormat:@"/PDF%ld.PDF",(long)indexPath.section];
            break;
            
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFileType:filePath:)]) {
        
        NSString *filePath = [[self createDocumentDirectoryPath:fileType] stringByAppendingString:fileName];
        
        [self.delegate selectedFileType:sBDownloadFileType
                               filePath:filePath];
    }
    
    
}

#pragma mark - Perform Pause OR Resume File Button
-(void)performPauseResumeFileButton:(UIButton *)sender {
    
    if (sender.selected == FALSE) {
        sender.selected = TRUE;
    } else {
        sender.selected = FALSE;
    }
    
    NSUInteger indexPathSection = [self getIndexPath:sender];
    [[SBManager sharedInstance] pauseResumeRequestedURL: fileArray [indexPathSection]];
}

#pragma mark - Perform Delete File Button
-(void)performDeleteFileButton:(UIButton *)sender {
    
    NSUInteger indexPathSection = [self getIndexPath:sender];
    [[SBManager sharedInstance] cancelDownloadingRequestedURL: fileArray [indexPathSection]];
    
    if ([fileArray count]) {
        [fileArray removeObjectAtIndex:indexPathSection];
    }
    
    [tblView reloadData];
    
}

-(NSUInteger)getIndexPath:(UIButton *)sender {
    
    CGPoint pointInSuperview = [sender.superview convertPoint:sender.center toView:tblView];
    NSIndexPath *tempPath = [tblView indexPathForRowAtPoint:pointInSuperview];
    return tempPath.section;
    
}

#pragma mark - Sotring / Retriving Files In Document Directory
-(BOOL)addFilesInDocumentDirectory:(NSData *)responseData fileName:(NSString*)fileName fileType:(NSString *)fileType{
    
    NSString *filePath = [[self createDocumentDirectoryPath:fileType] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    if([responseData writeToFile:filePath atomically:YES])
        return YES;
    else
        return NO;
}

-(NSString *)createDocumentDirectoryPath:(NSString *)fileType {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileType]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return dataPath;
}

-(UIImage *)tableViewCellImageType:(SBDownloadFileType)fileType {
    
    switch (fileType) {
        case SBDownloadFileTypeImage:
            return [UIImage imageNamed:@"D_Image"];
            break;
            
        case SBDownloadFileTypeVideo:
            return [UIImage imageNamed:@"D_Video"];
            break;
            
        case SBDownloadFileTypeAudio:
            return [UIImage imageNamed:@"D_Audio"];
            break;
            
        case SBDownloadFileTypePDF:
            return [UIImage imageNamed:@"D_PDF"];
            break;
            
        default:
            break;
    }
}
@end
