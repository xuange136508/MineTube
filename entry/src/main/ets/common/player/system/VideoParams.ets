
export class VideoParams {
  videos: VideosBean[] = [];

  constructor(videos:VideosBean[]) {
    this.videos = videos
  }
}

export class VideosBean {

  constructor(url?: string, width?: number, height?: number,duration?: number,cover?: string) {
    this.url = url
    this.width = width
    this.height = height
    this.duration = duration
    this.cover = cover
  }

  /** 视频url */
  url?: string;

  /** 宽 */
  width?: number;

  /** 高 */
  height?: number;

  /** 视频时长 */
  duration?: number;

  /** 视频封面 */
  cover?: string;
}

