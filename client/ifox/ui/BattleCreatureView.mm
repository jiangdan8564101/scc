//
//  BattleCreatureView.m
//  sc
//
//  Created by fox on 13-9-2.
//
//

#import "BattleCreatureView.h"

@implementation BattleCreatureView


// 1返回一个使用RGBA通道的位图上下文
static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow = (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease( colorSpace );
    return context;
}
// 2返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
static unsigned char *RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = (unsigned char*)CGBitmapContextGetData (cgctx);
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return data;
}

//3修改RGB的值
static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f){
    int redV=*red;
    int greenV=*green;
    int blueV=*blue;
    int alphaV=*alpha;
    *red=f[0]*redV+f[1]*greenV+f[2]*blueV+f[3]*alphaV+f[4];
    *green=f[0+5]*redV+f[1+5]*greenV+f[2+5]*blueV+f[3+5]*alphaV+f[4+5];
    *blue=f[0+5*2]*redV+f[1+5*2]*greenV+f[2+5*2]*blueV+f[3+5*2]*alphaV+f[4+5*2];
    *alpha=f[0+5*3]*redV+f[1+5*3]*greenV+f[2+5*3]*blueV+f[3+5*3]*alphaV+f[4+5*3];
    if (*red>255) {
        *red=255;
    }
    if(*red<0){
        *red=0;
    }
    if (*green>255) {
        *green=255;
    }
    if (*green<0) {
        *green=0;
    }
    if (*blue>255) {
        *blue=255;
    }
    if (*blue<0) {
        *blue=0;
    }
    if (*alpha>255) {
        *alpha=255;
    }
    if (*alpha<0) {
        *alpha=0;
    }
}

+ (UIImage*)processImage:(UIImage*)inImage withColorMatrix:(const float*) f
{
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    GLuint w = CGImageGetWidth(inImageRef);
    GLuint h = CGImageGetHeight(inImageRef);
    int wOff = 0;
    int pixOff = 0;
    //双层循环按照长宽的像素个数迭代每个像素点
    for(GLuint y = 0;y< h;y++)
    {
        pixOff = wOff;
        
        for (GLuint x = 0; x<w; x++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha=(unsigned char)imgPixel[pixOff+3];
            
            changeRGBA(&red, &green, &blue, &alpha, f);
            //回写数据
            imgPixel[pixOff] = red;
            imgPixel[pixOff+1] = green;
            imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            
            //将数组的索引指向下四个元素
            pixOff += 4;
        }
        wOff += w * 4;
    }
    
    NSInteger dataLength = w*h* 4;
    //下面的代码创建要输出的图像的相关参数
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    //创建要输出的图像
    CGImageRef imageRef = CGImageCreate(w, h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL, NO, renderingIntent);
    
    UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return my_Image;
}





- ( void ) setData:( CreatureCommonData* )c
{
    NSString* str = [ NSString stringWithFormat:@"CB%@B" , c.Action ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:HEAD_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    [ imageNormal release ]; imageNormal = image.retain;
    
    [ imageView setImage:image ];
    
    const float colormatrix_huajiu[] = {
        0.2f,0.5f, 0.1f, 0, 40.8f,
        0.2f, 0.5f, 0.1f, 0, 40.8f,
        0.2f,0.5f, 0.1f, 0, 40.8f,
        0, 0, 0, 1, 0 };
    
    [ imageDead release ];
    imageDead = [ BattleCreatureView processImage:imageView.image withColorMatrix:colormatrix_huajiu ];
    imageDead = imageDead.retain;
    
    [ self updateData:c ];
}

- ( void ) updateData:( CreatureCommonData* )c
{
    CGRect f = hpView.frame;
    f.size.width = bgView.frame.size.width * ( c.RealBaseData.HP / ( c.RealBaseData.MaxHP + 0.001f ) );
    
    if ( f.size.width < 0.05f )
    {
        f.size.width = 0.0f;
    }
    if ( f.size.width > bgView.frame.size.width )
    {
        f.size.width = bgView.frame.size.width;
    }
    [ hpView setFrame:f ];
    
    f = spView.frame;
    f.size.width = bgView.frame.size.width * ( c.RealBaseData.SP / ( c.RealBaseData.MaxSP + 0.001f ) );
    
    if ( f.size.width < 0.05f )
    {
        f.size.width = 0.0f;
    }
    if ( f.size.width > bgView.frame.size.width )
    {
        f.size.width = bgView.frame.size.width;
    }
    [ spView setFrame:f ];
    
    f = fsView.frame;
    f.size.width = bgView.frame.size.width * ( c.RealBaseData.FS / ( c.RealBaseData.MaxFS + 0.001f ) );
    
    if ( f.size.width < 0.05f )
    {
        f.size.width = 0.0f;
    }
    if ( f.size.width > bgView.frame.size.width )
    {
        f.size.width = bgView.frame.size.width;
    }
    [ fsView setFrame:f ];
    
    [ lvLabel setLabelText:[ NSString stringWithFormat:@"LV:%d" , c.Level ] ];
    [ hpLabel setLabelText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.HP , (int)c.RealBaseData.MaxHP ] ];
    [ spLabel setLabelText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.SP , (int)c.RealBaseData.MaxSP ] ];
    [ fsLabel setLabelText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.FS , (int)c.RealBaseData.MaxFS ] ];
    
//    if ( c.Dead )
//    {
//        UIGraphicsBeginImageContext( imageView.frame.size );
//        
//        [ imageView.image drawInRect:imageView.frame blendMode:kCGBlendModeLuminosity alpha:1.0f ];
//        
//        UIImage* resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//        
//        imageView.image = resultingImage;
//        
//        UIGraphicsEndImageContext();
//    }
    
    
    imageView.image = !c.Dead ? imageNormal : imageDead;
    //[ deadMask setHidden:!c.Dead ];
}

- ( void ) initBattleCreatureView
{
    numberViewOri = ( BattleNumberView* )[ self viewWithTag:200 ];
    imageView = ( UIImageView* )[ self viewWithTag:100 ];
    
    view = ( UIView* )[ self viewWithTag:110 ];
    
    
    hpView = ( UIImageView* )[ self viewWithTag:300 ];
    spView = ( UIImageView* )[ self viewWithTag:301 ];
    fsView = ( UIImageView* )[ self viewWithTag:302 ];
    bgView = ( UIImageView* )[ self viewWithTag:310 ];
    
    hpLabel = ( UILabelStroke* )[ self viewWithTag:320 ];
    spLabel = ( UILabelStroke* )[ self viewWithTag:321 ];
    fsLabel = ( UILabelStroke* )[ self viewWithTag:322 ];
    lvLabel = ( UILabelStroke* )[ self viewWithTag:323 ];
    
    effect = (UIEffectAction*)[ self viewWithTag:400 ];
    [ effect initUIEffect:self :@selector( onEffectOver: ) ];
    
    deadMask = [ self viewWithTag:500 ];
    deadMask.hidden = YES;
}


- ( void ) releaseBattleCreatureView
{
    
}

- ( void ) startFight
{
    [ UIView animateWithDuration:0.05f
                      animations:^{
                          view.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                      }completion:^(BOOL finish){
                          [ UIView animateWithDuration:0.70f
                                            animations:^{
                                                view.transform = CGAffineTransformMakeScale(1.101f, 1.101f);
                                                //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                            }completion:^(BOOL finish){
                                                [ UIView animateWithDuration:0.1f
                                                                  animations:^{
                                                                      view.transform = CGAffineTransformMakeScale(1, 1);
                                                                      
                                                                  }completion:^(BOOL finish){
                                                                      
                                                                  }];
                                            }];
                      }];
}


- ( void ) onEffectOver:( NSString* )eff
{

}

- ( void ) fightF:( float )f :( NSString* )eff :( BOOL )sound
{
    if ( f > 0 )
    {
        
    }
    else if ( f < 0 )
    {
        
    }
    else
    {
        return;
    }
    
    if ( eff )
    {
        effect.PlaySound = sound;
        [ effect playEffect:eff ];
    }
}


- ( void ) fight:( int )hp :( int )hit :( NSString* )eff :( BOOL )sound
{
    [ self.layer removeAllAnimations ];
    
    if ( numberView )
    {
        [ numberView removeFromSuperview ];
    }
    
    numberView =  [ NSKeyedUnarchiver unarchiveObjectWithData:
                   [ NSKeyedArchiver archivedDataWithRootObject:numberViewOri ] ];
    
    [ numberViewOri.superview addSubview:numberView ] ;
    
    if ( hp > 0 )
    {
        [ numberView initView:@"c" :31 :46 ];
        [ numberView setNumber:hp ];
    }
    else if ( hp < 0 )
    {
        if ( hit == BRHS_HIT1 )
        {
            [ numberView initView:@"bbb" :31 :46 ];
            [ numberView setNumber:hp ];
        }
        else if( hit == BRHS_HIT5 )
        {
            [ numberView initView:@"bb" :31 :46 ];
            [ numberView setNumber:hp ];
        }
        else
        {
            [ numberView initView:@"b" :31 :46 ];
            [ numberView setNumber:hp ];
        }
    }
    else
    {
        [ numberView removeFromSuperview ];
        numberView = NULL;
        return;
    }
    
    if ( eff )
    {
        effect.PlaySound = sound;
        [ effect playEffect:eff ];
    }
    
    
    if ( hp < 0 )
    {
        CALayer* viewLayer = [ self layer ];
        CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.08f / GAME_SPEED;
        animation.repeatCount = 3;
        animation.autoreverses=YES;
        animation.fromValue=[ NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, -0.03, 0.0, 0.0, 0.03 ) ];
        animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, 0.03, 0.0, 0.0, 0.03) ];
        [viewLayer addAnimation:animation forKey:@"wiggle" ];
        
//        [ UIView animateWithDuration:0.15f
//                          animations:^{
//                              view.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
//                          }completion:^(BOOL finish){
//                              [ UIView animateWithDuration:0.10f
//                                                animations:^{
//                                                    view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//                                                    //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
//                                                }completion:^(BOOL finish){
//                                                    
//                                                }];
//                          }];
    }
    
    
    [ UIView animateWithDuration:0.2f / GAME_SPEED
                      animations:^{
                          numberView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                          //nv.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                      }completion:^(BOOL finish){
                          [ UIView animateWithDuration:0.15f / GAME_SPEED
                                            animations:^{
                                                numberView.transform = CGAffineTransformMakeScale(0.99f, 0.99f );
                                                //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                            }completion:^(BOOL finish){
                                                [ UIView animateWithDuration:0.3f / GAME_SPEED
                                                                  animations:^{
                                                                      numberView.transform = CGAffineTransformMakeScale(1, 1);
                                                                      //nv.transform = CGAffineTransformMakeScale(1, 1);
                                                                  }completion:^(BOOL finish){
                                                                      [ numberView clearNumber ];
                                                                      [ numberView removeFromSuperview ];
                                                                      numberView = NULL;
                                                                  }];
                                            }];
                      }];
    
}


- ( void ) update:( float )d
{
    [ effect update:d ];
    [ numberView update:d ];
}

@end
