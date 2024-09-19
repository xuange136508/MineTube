import { PageName, PageParam } from './PageRouter';

export class PageRouterUtils {
  private constructor() {
  }

  private static instance: PageRouterUtils;

  public static getInstance(): PageRouterUtils {
    if (!PageRouterUtils.instance) {
      PageRouterUtils.instance = new PageRouterUtils();
    }
    return PageRouterUtils.instance;
  }

  demoByMap(map: Map<string, Object>) {
    let pageParam = new PageParam(map)
    const pageInfo: NavPathStack = this.getNavPathStack()
    pageInfo.pushPath({ name: 'demo', param: pageParam })
  }

  goToPlayDetail(playId: string | number, onPop?: (popInfo: PopInfo) => void) {
    let map: Map<string, Object> = new Map()
    map.set('play_id', playId + "")
    let pageParam = new PageParam(map)
    const pageInfo: NavPathStack = this.getNavPathStack()
    pageInfo.pushPath({
      name: PageName.PagePlayDetail, param: pageParam, onPop: (popInfo: PopInfo) => {
        if (onPop) {
          onPop(popInfo)
        }
      }
    })
  }

  private getNavPathStack():NavPathStack{
    return AppStorage.get("pageInfo") as NavPathStack;
  }
}