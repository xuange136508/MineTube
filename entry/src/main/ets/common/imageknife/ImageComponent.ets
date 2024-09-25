import { ImageKnifeComponent } from '@ohos/imageknife'
import { ImageOption } from './ImageOption'

@Component
export struct ImageComponent {
  imageOption: ImageOption = new ImageOption()
  @State objectFIt: ImageFit = ImageFit.Cover
  @Prop loadSrc: string | PixelMap | Resource
  @State connerRadius: number = 0
  @State colorString: string = '#00000000'
  @State radiusWidth: number = 0

  build() {
    ImageKnifeComponent({
      imageKnifeOption: {
        loadSrc: this.loadSrc,
        objectFit: this.objectFIt,
        placeholderSrc: this.imageOption.noErrorSrc ? undefined : this.imageOption.placeholderSrc,
        placeholderObjectFit: ImageFit.Fill,
        errorholderSrc: this.imageOption.noErrorSrc ? undefined : this.imageOption.errorholderSrc,
        errorholderObjectFit: ImageFit.Fill,
        // 绘制圆角30，边框5，边框"#ff00ff".用户自定义绘制（可选）
        border: { radius: this.connerRadius },
      }
    })
  }
}