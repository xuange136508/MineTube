/**
 * 网络错误信息
 */
export class ErrorMsg {
  code?:number
  msg?:string

  constructor(code?:number,msg?:string) {
    this.code = code;
    this.msg = msg;
  }
}