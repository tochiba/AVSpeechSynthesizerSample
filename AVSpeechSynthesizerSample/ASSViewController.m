//
//  ASSViewController.m
//  AVSpeechSynthesizerSample
//
//  Created by 千葉 俊輝 on 2013/11/26.
//  Copyright (c) 2013年 Toshiki Chiba. All rights reserved.
//

#import "ASSViewController.h"

@interface ASSViewController ()
@property (nonatomic,strong)AVSpeechSynthesizer *speechSynthesizer;
- (void)setUpPauseButton;
- (void)initilaizeButtonAndText;
@end

@implementation ASSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // initialize AVSpeechSynthesizer インスタンスを作成し、デリゲートを設定する
    _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    _speechSynthesizer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {
    // AVSpeechUtteranceに再生テキストを設定し、インスタンス作成
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[[self textView] text]];
    // 英語に設定し、AVSpeechSynthesisVoiceのインスタンス作成
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    // AVSpeechSynthesisVoiceをAVSpeechUtterance.voiceに指定。
    utterance.voice =  voice;
    // デフォルトは早すぎるので
    utterance.rate = 0.2;
    // 男性ぽく
    utterance.pitchMultiplier = 0.5;
    // 0.2秒のためを作る
    utterance.preUtteranceDelay = 0.2f;
    // 再生開始
    [self.speechSynthesizer speakUtterance:utterance];
}

- (IBAction)pause:(id)sender {
    // 停止していたら再開、停止していなかったら停止
    self.speechSynthesizer.paused?
    [self.speechSynthesizer continueSpeaking]:
    [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (IBAction)finish:(id)sender {
    // 直ちに停止
    [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

-(void)setUpPauseButton {
    // 再生状況でボタンのタイトルを変える
    NSString *buttonTitle = self.speechSynthesizer.paused? @"再開":@"一時停止";
    [self.pauseButton setTitle:buttonTitle forState:UIControlStateNormal];
}

-(void)initilaizeButtonAndText {
    // ボタンとテキストを初期化する
    [self.pauseButton setTitle:@"一時停止" forState:UIControlStateNormal];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
    [self.textView setAttributedText:attrStr];
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"読み上げを開始しました");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    [self initilaizeButtonAndText];
    NSLog(@"読み上げを終了しました");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    [self setUpPauseButton];
    NSLog(@"読み上げを一時停止しました");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    [self setUpPauseButton];
    NSLog(@"読み上げを再開しました");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    [self initilaizeButtonAndText];
    NSLog(@"読み上げを停止しました");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
    // 読み上げ中の単語の文字色、文字の大きさを設定
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:NSMakeRange((unsigned long)characterRange.location, characterRange.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura-CondensedMedium" size:20.] range:NSMakeRange((unsigned long)characterRange.location, characterRange.length)];
    [self.textView setAttributedText:attrStr];
}
@end
