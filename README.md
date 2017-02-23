
#LDPressButton

###说明
本demo是使用swift3.0仿写的微信小视频拍摄按钮, 只是一个简单长按按时计时, 附带环形进度条的小控件

###介绍
属性介绍: 对外公开的属性十分简单, 主要是一些简单的设置, 都设有默认值

```
/// 计时时长
var interval: Float = 10.0
/// 按钮样式
var style: LDProgressButtonStyle = .White
/// 中间圆心颜色
var centerColor: UIColor!
/// 圆环颜色
var ringColor: UIColor!
/// 进度条颜色
var progressColor
```

对外公开的方法只有一个, 用于接收回调的事件:
```
/// 响应事件
func actionWithClosure(_ closure: @escaping actionState) 
```
另外设置了两个枚举
```
/// 按钮的样式
enum LDProgressButtonStyle {
    
    case White
    case Gray
    case Black
}
/// 按钮的状态, 即事件
enum LDProgressButtonState {
    case Begin //开始点击
    case Moving // 手指移动
    case WillCancel // 当移动超出环形范围, 处于即将取消
    case DidCancel  // 松开手指, 取消
    case End // 正常结束
    case Click // 单击事件
}
```

###使用
控件继承自UIView, 可以添加到任意视图上, 使用非常简单, 这里直接给出示例代码
这里直接使用的默认属性设置, 可根据自己的需求来设置
```
// 初始化控件
let press = LDPressButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
// 添加控件
        
self.view.addSubview(press)
// 控件事件响应, 使用闭包回调, 参数是各种状态
press.actionWithClosure { (state) in
            
            switch state {
                
            case .Begin:
                print("begin")
            case .Moving:
                print("moving")
            case .WillCancel:
                print("willCancel")
            case .DidCancel:
                print("didCancel")
            case .End:
                print("end")
            case .Click:
                print("click")
            }
        }
```

#注意
在测试时, 请使用真机, 模拟器会导致计时不准确, 因为使用的是CADisplayLink来计时的, 其频率是同iPhone设备同步的
               
#示意图
![](https://github.com/LQQZYY/LDPressButton/blob/master/pic1.gif)
