import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

interface userInfo{
  id: number
  name: string,
  phone: number
}
interface user {
  firstName: string,
  lastName: string
}

//默认官方请求(@ohos.net.http)
//https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-http-V5#request-2
/**
 Axios ，是一个基于 promise 的网络请求库，可以运行 node.js 和浏览器中。本库基于Axios 原库v1.3.4版本进行适配，使其可以运行在 OpenHarmony，并沿用其现有用法和特性。
 [1] http 请求
 [2] Promise API
 [3] request 和 response 拦截器
 [4] 转换 request 和 response 的 data 数据
 [5] 自动转换 JSON data 数据
 * */
//https://gitee.com/openharmony-sig/ohos_axios
class AxiosDemo {

  //全局 axios 默认值
  private defaultConfig(){
    axios.defaults.baseURL = 'https://www.xxx.com';
    axios.defaults.headers.common['Authorization'] = "AUTH_TOKEN";
    axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';
  }

  private axiosGetRequest(){
    // 向给定ID的用户发起请求
    axios.get<userInfo, AxiosResponse<userInfo>, null>('/user?ID=12345')
      .then((response: AxiosResponse<userInfo>)=> {
        // 处理成功情况
        console.info("id" + response.data.id)
        console.info(JSON.stringify(response));
      })
      .catch((error: AxiosError)=> {
        // 处理错误情况
        console.info(JSON.stringify(error));
      })
      .then(()=> {
        // 总是会执行
      });

    // 上述请求也可以按以下方式完成（可选）
    axios.get<userInfo, AxiosResponse<userInfo>, null>('/user', {
      params: {
        ID: 12345
      }
    })
      .then((response:AxiosResponse<userInfo>) => {
        console.info("id" + response.data.id)
        console.info(JSON.stringify(response));
      })
      .catch((error:AxiosError) => {
        console.info(JSON.stringify(error));
      })
      .then(() => {
        // 总是会执行
      });
  }


  private axiosPostRequest(){
    axios.post<string, AxiosResponse<string>, user>('/user', {
      firstName: 'Fred',
      lastName: 'Flintstone'
    })
      .then((response: AxiosResponse<string>) => {
        console.info(JSON.stringify(response));
      })
      .catch((error:AxiosError) => {
        console.info(JSON.stringify(error));
      });
  }


  //拦截器
  private addInterceptors(){
    // 添加请求拦截器
    const myInterceptor = axios.interceptors.request.use((config:InternalAxiosRequestConfig) => {
      // 对请求数据做点什么
      return config;
    }, (error:AxiosError) => {
      // 对请求错误做些什么
      return Promise.reject(error);
    });


    // 添加响应拦截器
    axios.interceptors.response.use((response:AxiosResponse)=> {
      // 对响应数据做点什么
      return response;
    }, (error:AxiosError)=> {
      // 对响应错误做点什么
      return Promise.reject(error);
    });

    // 移除拦截器
    axios.interceptors.request.eject(myInterceptor);
  }

    // 支持async/await用法
  /*
    async function getUser() {
      try {
        const response:AxiosResponse = await axios.get<string, AxiosResponse<string>, null>(this.getUrl);
        console.log(JSON.stringify(response));
      } catch (error) {
        console.error(JSON.stringify(error));
      }
  }*/


  //官方请求(@ohos.net.http)
  private request(){
    //简单使用
    let httpRequest1 = http.createHttp();
    httpRequest1.request("EXAMPLE_URL", (err: Error, data: http.HttpResponse) => {
      if (!err) {
        console.info('Result:' + data.result);
        console.info('code:' + data.responseCode);
        console.info('type:' + JSON.stringify(data.resultType));
        console.info('header:' + JSON.stringify(data.header));
        console.info('cookies:' + data.cookies); // 自API version 8开始支持cookie
      } else {
        console.info('error:' + JSON.stringify(err));
      }
    });


    // 每一个httpRequest对应一个HTTP请求任务，不可复用
    let httpRequest = http.createHttp();
    // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
    // 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。 8+
    httpRequest.on('headersReceive', (header: Object) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(// 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      "EXAMPLE_URL",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
        extraData: 'data to send',
        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
        usingCache: true, // 可选，默认为true
        priority: 1, // 可选，默认为1
        // 开发者根据自身业务需要添加header字段
        header: { 'Accept' : 'application/json' },
        readTimeout: 60000, // 可选，默认为60000ms
        connectTimeout: 60000, // 可选，默认为60000ms
        usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
        usingProxy: false, //可选，默认不使用网络代理，自API 10开始支持该属性
        caPath: '/path/to/cacert.pem', // 可选，默认使用系统预设CA证书，自API 10开始支持该属性
        clientCert: { // 可选，默认不使用客户端证书，自API 11开始支持该属性
          certPath: '/path/to/client.pem', // 默认不使用客户端证书，自API 11开始支持该属性
          keyPath: '/path/to/client.key', // 若证书包含Key信息，传入空字符串，自API 11开始支持该属性
          certType: http.CertType.PEM, // 可选，默认使用PEM，自API 11开始支持该属性
          keyPassword: "passwordToKey" // 可选，输入key文件的密码，自API 11开始支持该属性
        },
        certificatePinning: [ // 可选，支持证书锁定配置信息的动态设置，自API 12开始支持该属性
          {
            publicKeyHash: 'Pin1', // 由应用传入的证书PIN码，自API 12开始支持该属性
            hashAlgorithm: 'SHA-256' // 加密算法，当前仅支持SHA-256，自API 12开始支持该属性
          }, {
          publicKeyHash: 'Pin2', // 由应用传入的证书PIN码，自API 12开始支持该属性
          hashAlgorithm: 'SHA-256' // 加密算法，当前仅支持SHA-256，自API 12开始支持该属性
        }
        ],
        multiFormDataList: [ // 可选，仅当Header中，'content-Type'为'multipart/form-data'时生效，自API 11开始支持该属性
          {
            name: "Part1", // 数据名，自API 11开始支持该属性
            contentType: 'text/plain', // 数据类型，自API 11开始支持该属性
            data: 'Example data', // 可选，数据内容，自API 11开始支持该属性
            remoteFileName: 'example.txt' // 可选，自API 11开始支持该属性
          }, {
          name: "Part2", // 数据名，自API 11开始支持该属性
          contentType: 'text/plain', // 数据类型，自API 11开始支持该属性
          // data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.txt
          filePath: `${getContext(this).filesDir}/fileName.txt`, // 可选，传入文件路径，自API 11开始支持该属性
          remoteFileName: 'fileName.txt' // 可选，自API 11开始支持该属性
        }
        ]
      },
      (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          // data.result为HTTP响应内容，可根据业务需要进行解析
          console.info('Result:' + JSON.stringify(data.result));
          console.info('code:' + JSON.stringify(data.responseCode));
          console.info('type:' + JSON.stringify(data.resultType));
          // data.header为HTTP响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + JSON.stringify(data.cookies)); // 自API version 8开始支持cookie
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
          httpRequest.destroy();
        } else {
          console.info('error:' + JSON.stringify(err));
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
          httpRequest.destroy();
        }
      });
  }
}