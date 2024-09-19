

/**
 * 页面名 name
 */
export enum PageName {
  /**
   * 播放详情页
   */
  PagePlayDetail = 'PagePlayDetail',

}

export class PageParam{
  map:Map<string,Object>
  constructor(map: Map<string,Object>) {
    this.map = map
  }
}