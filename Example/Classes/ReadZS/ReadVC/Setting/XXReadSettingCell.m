//
//  XXReadSettingCell.m
//  Novel
//
//  Created by xx on 2018/11/26.
//  Copyright © 2018 th. All rights reserved.
//

#import "XXReadSettingCell.h"

@implementation XXReadSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupViews {
    
    _switchView = [[UISwitch alloc] init];
    _switchView.hidden = YES;
    [self.contentView addSubview:_switchView];
    
    _lineView = [UIView newLine];
    [self.contentView addSubview:_lineView];
    
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-16));
        make.size.mas_equalTo(CGSizeMake(51, 31));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.mas_equalTo(klineHeight);
    }];
    
    [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}


- (void)switchAction:(UISwitch *)switchButton {
    
    BOOL isButtonOn = [switchButton isOn];
    
    if ([_delegate respondsToSelector:@selector(didClickSwitchByModel:isOpen:cell:)]) {
        [_delegate didClickSwitchByModel:_model isOpen:isButtonOn cell:self];
    }
}


- (void)setModel:(XXReadSettingModel *)model {
    _model = model;
    
    self.textLabel.text = model.title;
    if (model.desc.length > 0) {
        self.detailTextLabel.text = model.desc;
    }
    
    if (model.type == kReadSettingType_FullTap) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        _switchView.hidden = NO;
        [_switchView setOn:model.isOpen];
    }
    else {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _switchView.hidden = YES;
    }
}


@end
