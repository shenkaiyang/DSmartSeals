//
//  ViewController.m
//  AnimationDemo
//
//  Created by shenkaiyang on 2018/10/31.
//  Copyright © 2018年 shenkaiyang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong)CAEmitterLayer *emitterLayer;
@property (nonatomic,strong)UILabel *nameLabel;
@end

@implementation ViewController

- (CAEmitterLayer *)emitterLayer {
    if (nil == _emitterLayer) {
        _emitterLayer = [[CAEmitterLayer alloc]init];
    }
    return _emitterLayer;
}
- (UILabel *)nameLabel {
    if (nil == _nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor redColor];
    }
    return _nameLabel;
   
}

//将view转换成图片

- (UIImage *)imageWith:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)waterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed{
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字 
    [text drawAtPoint:point withAttributes:attributed];
    //从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
    
}

- (UIImage *)clipCircleImageWith:(UIImage *)image circleRect:(CGRect)rect borderWidt:(CGFloat)borderW borderColor:(UIColor *)borderColor {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [borderColor setFill];
    [bezierPath fill];

    //3、设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x + borderW , rect.origin.x + borderW , rect.size.width - borderW * 2, rect.size.height - borderW *2)];
    [clipPath addClip];
    //3、绘制图片
    [image drawAtPoint:CGPointZero];
    //4、获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5、关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



- (UIImage *)waterImageWith:(UIImage *)image water:(UIImage *)waterImage WithWaterRect:(CGRect)rect
{
    /*
     * 参数一: 指定将来创建出来的bitmap的大小
     * 参数二: 设置透明YES代表透明，NO代表不透明
     * 参数三: 代表缩放,0代表不缩放
     */
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //绘制背景图
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //将水印图绘制到当前图上
    [waterImage drawInRect:rect];
    //从上下文中获取新图片
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束图形上线
    UIGraphicsEndImageContext();
    return currentImage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *imahge = [self clipCircleImageWith:[UIImage imageNamed:@"image"] circleRect:CGRectMake(0, 0, 200, 200) borderWidt:1 borderColor:[UIColor redColor]];
    UIImageView *MabelView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 200, 200, 200)];
    MabelView.image = imahge;
    [self.view addSubview:MabelView];
    
    
    [self.view.layer addSublayer:self.emitterLayer];
    //当前撒花的中心点坐标
    self.emitterLayer.emitterPosition = self.view.center;
    //每秒发射的粒子数量
    self.emitterLayer.birthRate = 2.0f;
    //粒子发射器的样式
    self.emitterLayer.renderMode = kCAEmitterLayerPoint;
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    NSString *tit = [NSString stringWithFormat:@"%ld",(long)((arc4random()% 500) + 500)];
    self.nameLabel.text = tit;
    cell.contents = (__bridge id _Nullable)([(id)self imageWith:self.nameLabel].CGImage);//他所需要对象类型的和图层类似

    //接着设置cell的属性
    //    粒子的出生量
    cell.birthRate = 20;
    //    存活时间
    cell.lifetime = 3;
    cell.lifetimeRange = 1;
    //    设置粒子发送速度
    cell.velocity = 100;
    cell.velocityRange = 30;
    //    粒子发送的方向
    cell.emissionLatitude = -360*M_PI/180;
    //    发送粒子的加速度
    cell.xAcceleration = 100;
    
    //    散发粒子的范围  ->  弧度
    cell.emissionRange = 360*M_PI/180;
    
    //最后把粒子的cell添加到粒子发送器  数组内可以添加多个cell对象
    self.emitterLayer.emitterCells = @[cell];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
