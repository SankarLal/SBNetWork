
#import <UIKit/UIKit.h>

typedef NS_ENUM ( NSInteger, SBDownloadFileType ) {
    SBDownloadFileTypeImage =0,
    SBDownloadFileTypeVideo,
    SBDownloadFileTypeAudio,
    SBDownloadFileTypePDF
};

@protocol SBDetailDelegate <NSObject>

-(void)selectedFileType:(SBDownloadFileType)fileType filePath:(NSString *)filePath;

@end


@interface SBTableView : UIView

-(void)setFileArrayValue:(NSArray*)fileArrayValue sbDownloadFileType:(SBDownloadFileType)sbDownloadFileType;
@property (strong, nonatomic) id <SBDetailDelegate> delegate;

@end
