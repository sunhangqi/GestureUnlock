
//
//  ClockView.m
//  手势识别
//
//  Created by Macbook on 2017/5/18.
//  Copyright © 2017年 Macbook. All rights reserved.
//

#import "ClockView.h"

@interface ClockView()

//存放当前选中的按钮
@property (nonatomic, strong) NSMutableArray *selectBtnArray;

//当前手指所在的点
@property (nonatomic, assign) CGPoint curP;
@end

@implementation ClockView

- (NSMutableArray *)selectBtnArray {
    if (_selectBtnArray == nil) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    for (int i = 0; i < 9; i++) {
        //创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        
        //设置不能处理事件，由父控件处理
        btn.userInteractionEnabled = NO;
        
        
        //设置按钮图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //当前的手指所在点在按钮上
    CGPoint point = [self getCurrentPoint:touches];
    //判断点是否在按钮上
    //取出所有按钮
    UIButton *btn = [self btnContainsPoint:point];
    if(btn && btn.selected == NO){
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];

    }
    
//    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [self getCurrentPoint:touches];
    self.curP = point;
    //判断点是否在按钮上
    //取出所有按钮
    UIButton *btn = [self btnContainsPoint:point];
    if(btn && btn.selected == NO){
        btn.selected = YES;
        [self.selectBtnArray addObject: btn];
        
    }
    [self setNeedsDisplay];

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //1.取消所有选中的按钮
     NSMutableString *str = [NSMutableString string];
    for(UIButton *btn in self.selectBtnArray) {
//        NSLog(@"%ld",btn.tag);
        btn.selected = NO;
        [str appendFormat:@"%ld",btn.tag];

    }
    //2.清空路径
    [self.selectBtnArray removeAllObjects];
    [self setNeedsDisplay];
    
    //3.查看顺序
    NSLog(@"%@",str);
}

- (void)drawRect:(CGRect)rect {
    
    
   
    if (self.selectBtnArray.count) {
        //1.创建路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        //2.取出所有保存的选中的按钮
        for(int i = 0; i < self.selectBtnArray.count; i++) {
            UIButton *btn = self.selectBtnArray[i];
            
            //判断当前按钮是否为第一个按钮
            if(i==0){
                //如果是，设置成路径的起点
                [path moveToPoint:btn.center];
                NSLog(@"%f",btn.center.x);
            }else{
                [path addLineToPoint:btn.center];
                
            }
        }
        
        [path addLineToPoint:self.curP];
        [path setLineWidth:10];
        [path setLineJoinStyle:kCGLineJoinRound];
        [[UIColor redColor] set];
        
        //3.绘制路径
        [path stroke];
    }
    
}


//获取当前手指所在点
- (CGPoint)getCurrentPoint:(NSSet *)touches {
    //当前的手指所在点在按钮上
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}
//给定点是否在按钮里，如果在返回nil
- (UIButton *)btnContainsPoint:(CGPoint)point{
    for (UIButton *btn in self.subviews) {
        if(CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnHW = 74;
    
    //总共有多少列
    int column = 3;
    CGFloat margin = (self.bounds.size.width - (btnHW * column)) / (column + 1);
    
    int curColumn = 0;
    int curRow    = 0;
    for(int i = 0; i < self.subviews.count; i++) {
        
        curColumn = i % column;
        curRow = i / column;
        
        x = margin + (btnHW + margin) * curColumn;
        y = margin + (btnHW + margin) * curRow;
        //取出每一个按钮
        UIButton *btn = self.subviews[i];
        
        
        //设置按钮的frame
        btn.frame = CGRectMake(x, y, btnHW, btnHW);
    }
}

@end
