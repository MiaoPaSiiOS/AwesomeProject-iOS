//
//  T1StatusLayout.h
//  YYKitExample
//
//  Created by guoyaoyuan on 15/10/10.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import <YYText/YYText.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "T1Model.h"


#define kT1CellPadding 12
#define kT1CellInnerPadding 6
#define kT1CellExtendedPadding 30
#define kT1AvatarSize 48
#define kT1ImagePadding 4
#define kT1ConversationSplitHeight 25
#define kT1ContentLeft (kT1CellPadding + kT1AvatarSize + kT1CellInnerPadding)
#define kT1ContentWidth ((DSDeviceInfo.screenWidth) - 2 * kT1CellPadding - kT1AvatarSize - kT1CellInnerPadding)
#define kT1QuoteContentWidth (kT1ContentWidth - 2 * kT1CellPadding)
#define kT1ActionsHeight 6
#define kT1TextContainerInset 4

#define kT1UserNameFontSize 14
#define kT1UserNameSubFontSize 12
#define kT1TextFontSize 14
#define kT1ActionFontSize 12

#define kT1UserNameColor [DSHelper colorWithHexString:@"0x292F33"]
#define kT1UserNameSubColor [DSHelper colorWithHexString:@"0x8899A6"]
#define kT1CellBGHighlightColor [UIColor colorWithWhite:0.000 alpha:0.041]
#define kT1TextColor [DSHelper colorWithHexString:@"0x292F33"]
#define kT1TextHighlightedColor [DSHelper colorWithHexString:@"0x1A91DA"]
#define kT1TextActionsColor [DSHelper colorWithHexString:@"0x8899A6"]
#define kT1TextHighlightedBackgroundColor [DSHelper colorWithHexString:@"0xebeef0"]

#define kT1TextActionRetweetColor [DSHelper colorWithHexString:@"0x19CF86"]
#define kT1TextActionFavoriteColor [DSHelper colorWithHexString:@"0xFAB81E"] 


@interface T1StatusLayout : NSObject

@property (nonatomic, strong) T1Tweet *tweet;
@property (nonatomic, strong) T1Conversation *conversation;
- (void)layout;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat textTop;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat imagesTop;
@property (nonatomic, assign) CGFloat imagesHeight;
@property (nonatomic, assign) CGFloat quoteTop;
@property (nonatomic, assign) CGFloat quoteHeight;

@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL isConversationSplit;
@property (nonatomic, assign) BOOL showConversationTopJoin;
@property (nonatomic, assign) BOOL showConversationBottomJoin;

@property (nonatomic, strong) YYTextLayout *socialTextLayout;
@property (nonatomic, strong) YYTextLayout *nameTextLayout;
@property (nonatomic, strong) YYTextLayout *dateTextLayout;
@property (nonatomic, strong) YYTextLayout *textLayout;

@property (nonatomic, strong) YYTextLayout *quotedNameTextLayout;
@property (nonatomic, strong) YYTextLayout *quotedTextLayout;

@property (nonatomic, strong) YYTextLayout *retweetCountTextLayout;
@property (nonatomic, strong) YYTextLayout *favoriteCountTextLayout;

@property (nonatomic, strong) NSArray<T1Media *> *images;
@property (nonatomic, readonly) T1Tweet *displayedTweet;

- (YYTextLayout *)retweetCountTextLayoutForTweet:(T1Tweet *)tweet;
- (YYTextLayout *)favoriteCountTextLayoutForTweet:(T1Tweet *)tweet;
@end
