import { AxiosResponse } from '@ohos/axios';
import axiosHelper from './AxiosHelper';
import { ErrorMsg } from './ErrorMsg';
import { Response } from './Response';


class AxiosHelperDemo {


  //封装后的AxiosHelper使用
  private testAxiosHelper(){
    this.getAppInit().then((response: object) => {

    })
  }

  getAppInit(): Promise<object> {
    return new Promise(async (resolve, reject) => {
      let map = new Map<string, string>()
      let url = await this.buildGetParams(UrlPath.API_INIT, map)
      axiosHelper.getAxios<object>().get<Response<object>, AxiosResponse<Response<object>>, null>(url)
        .then((response: AxiosResponse<Response<object>>) => {
          // 处理成功情况
          console.info("response.data" + JSON.stringify(response.data.status))
          resolve(response.data.data)
        }).catch((error:ErrorMsg) => {
        // 处理失败情况
        console.info("response error:code:" + error.code +' msg:'+ error.msg);
        reject(error)
      })
    })
  }

  async buildGetParams(url: string, params?: Map<string, Object>): Promise<string> {
    return ""
  }

}

export const PATH_HEAD = 'https://papi.mama.cn/';

export class UrlPath {
  static readonly API_INIT: string = `${PATH_HEAD}api/init/index`
}