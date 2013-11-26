//
//  ASSViewController.h
//  AVSpeechSynthesizerSample
//
//  Created by 千葉 俊輝 on 2013/11/26.
//  Copyright (c) 2013年 Toshiki Chiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ASSViewController : UIViewController <AVSpeechSynthesizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)start:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)finish:(id)sender;

@end
