export class ImageOption{
  noErrorSrc ?:boolean  =  false
  placeholderSrc?: string | PixelMap | Resource= $r('app.media.default_image_res')
  errorholderSrc?:  PixelMap |  Resource= $r('app.media.default_image_res')
}