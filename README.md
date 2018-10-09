# Training Program

E-mnread

## Requirements

### Build

Xcode 8.0 or later; iOS 10.0 SDK or later

### Runtime

iOS 10.0 or later on an iOS device

# Version

v1.0 增加数据显示表格，普通话支持和随机测试语句
v1.1 修正识别句子速度问题，增加手动输入数据模式
v1.2

//对话框refine 对话框大点 加入id 年龄，性别，出生日期
// subcontents里显示ID： 例如TW0001 - test1 - 自动
// 两次测试， 句子不要重复
// curve 红线不需要
// test1 + test2 表格里显示
// 表格里多加一行距离

// 同一用户保存在同一文件夹里

v1.3
1.    加多一個 “MNRead 示範”的版面,
2.    背景顏色中:     綠色→不要螢光綠
藍色→請用天藍色
3.    個人資料的輸入版面中, 請刪掉 “年齡” 一格
4.    加多一個選項﹕
測試次數: 1  2  3
如果選 “1” 的話, 就在57句中隨機抽取19句
如果選 “2” 的話, 就在57句中隨機抽取38句
如果選 “3” 的話, 就57句隨機出現
5.    加多兩個測試距離: 16cm, 13cm
6.    修正LogMar計算錯誤,
7.    隠藏 “test result” 版面的 “刪除” 標示
8.    把 “手動”, “國語”, “2008年”設定為默認


v1.4
1. 结果页面： 第几次测试：改为  测试
                    加入     语言：广东话 , 测试模式： 手动
2. 示例那里灰色直线修正
3. 保存录音, 在结果页面可以播放录音
4. 自动录音时错字有负数的问题
5. 手动时会自动显示那些错字
6. 蓝色太灰

v1.41
1.  服务器curve_fit，计算结果后返回, 修正回归曲线， UI的一些改变

v1.42

1. yvalue可能为-inf的情况(errorNum = 12仍记录? ), 可能直接跳过一个测试到另外个测试
(  可能问题 speechRecognizer.delegate 和 SFSpeechRecognizer.requestAuthorization 见官方文档)
2. 修正播放没有声音的问题（设置AVAudioSessionCategoryOptions.mixWithOthers）
3. log应该是10为底计算
4. 手动情况下最后一个没通过的测试仍放入计算
5. speechrecognition, code=203问题(disable OS_ACTIVITY_MODE)

v1.43
1.蓝色背景，曲线
2.输入错字时判断（停止时输入11和12才有效吧) 叠选择
3.全部测试通过时曲线是否有问题
4.同一天放在同一个folder
5y.值antilog
                    


