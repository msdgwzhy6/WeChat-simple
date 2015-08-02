//
//  MessageTableViewCell.m
//  微信
//
//  Created by 弄潮者 on 15/7/15.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageModal.h"

#define kwidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _createView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)_createView {
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_iconImageView];

    _backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_backGroundImageView];
   
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.numberOfLines = 0;
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor blackColor];
    [self.contentView addSubview:_label];
    
}

- (void)layoutSubviews {
    
    //背景图片设置
    UIImage *chatfromImage = [UIImage imageNamed:@"chatfrom_bg_normal"];
    UIImage *chattoImage = [UIImage imageNamed:@"chatto_bg_normal"];
    
    UIImage *chatImage = self.message.isSelf?chattoImage:chatfromImage;
//    NSLog(@"%d",self.message.isSelf);
    //图片拉伸，该方法是部分拉伸
    chatImage = [chatImage stretchableImageWithLeftCapWidth:chatImage.size.width*0.5 topCapHeight:chatImage.size.height*0.7];
    _backGroundImageView.image = chatImage;

    _iconImageView.image = [UIImage imageNamed:self.message.icon];
    
    _label.text = self.message.content;
    
    //换行高度设置
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    CGSize contenSize = [self.message.content boundingRectWithSize:CGSizeMake(kwidth-140 , 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    //左右情况布局
    if (self.message.isSelf) {
        _iconImageView.frame = CGRectMake(kwidth-10-40, 10, 40, 40);
        _backGroundImageView.frame = CGRectMake(kwidth-(10+40+10)-(contenSize.width+50), 10, contenSize.width+40, contenSize.height+30);
        _label.frame = CGRectMake(kwidth-(60+10)-(contenSize.width+10+10+5), 10+10, contenSize.width, contenSize.height);
    }else {
        _iconImageView.frame = CGRectMake(10, 10, 40, 40);
        _backGroundImageView.frame = CGRectMake(10+40+10, 10, contenSize.width+50, contenSize.height+30);
        _label.frame = CGRectMake(60+20+5, 10+10+2.5, contenSize.width+20, contenSize.height);
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
