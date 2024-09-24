/**
 * 数据返回类
 */
export interface Response<T>{
  code: number
  status: number
  msg: string
  errmsg:ErrorMsg
  data: T
}
export class ErrorMsg{
  errno:number
  msg?:string
  constructor(errno:number,msg:string) {
    this.errno = errno
    this.msg = msg
  }
}