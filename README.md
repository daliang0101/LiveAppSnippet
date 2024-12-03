## 简介：直播App房间基本能力的一种代码设方案
* 厂商直播SDK封装（LiveEngine, 只封装部分接口）
  
* App基础网络请求（WebEngine, 只提供一个类，不提供实现）
* 房间直播服务（RoomLiveService，基于LiveEngine）
* 房间网络请求服务（RoomWebService，基于WebEngine）
* 房间组件化（ComponentManager， Room/ComponentManager）


### 提示：项目只为展示直播房基础服务的代码结构设计，相关数据模型只为说明问题
