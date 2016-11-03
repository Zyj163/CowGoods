//
//  Router.swift
//  CowGoods
//
//  Created by ddn on 16/6/14.
//  Copyright © 2016年 ddn. All rights reserved.
//
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = baseUrl
    
    /**
     *  获取验证码
     *
     *  @param String 手机号
     *
     *  @return 路由
     */
    case Authcode(tel: String)
    /**
     *  获取动态密码
     *
     *  @param String 手机号
     *
     *  @return 路由
     */
    case DynamicPassword(tel: String)
    /**
     *  注册
     *
     *  @param String 手机号
     *  @param String 验证码
     *  @param String 密码
     *  @param String 邀请码
     *
     *  @return 路由
     */
    case Register(tel: String, authcode: String, password: String, inviteCode: String)
    /**
     *  登录
     *
     *  @param String 手机号
     *  @param String 密码
     *  @param String 动态密码
     *  @param String 设备标志符
     *
     *  @return 路由
     */
    case Login(tel: String, password: String, dynamicPassword: String, cid: String)
    /**
     *  获取商品列表
     *
     *  @param String 分类ID
     *  @param String 品牌ID
     *  @param String 当前页
     *  @param String 每页大小
     *
     *  @return 路由
     */
    case GoodsList(cat_id: String, brand_id: String, currentPage: String, pageSize: String)
    /**
     *  获取云仓列表
     *
     *  @param String 用户唯一标示
     *  @param String 当前页
     *  @param String 每页大小
     *
     *  @return 路由
     */
    case CloudHouse(token: String, currentPage: String, pageSize: String)
    /**
     *  获取进货单列表
     *
     *  @param String 用户唯一标示
     *  @param String 当前页
     *  @param String 每页大小
     *  @param String 支付状态
     *
     *  @return 路由
     */
    case OrderList(token: String, currentPage: String, pageSize: String)
    /**
     *  上传实名认证图片
     *
     *  @return 路由
     */
    case UploadCard()
    /**
     *  实名认证
     *
     *  @param String 用户唯一标示
     *  @param String 姓名
     *  @param String 身份证号
     *  @param String 正面照服务器相对路径
     *  @param String 反面照服务器想对路径
     *
     *  @return 路由
     */
    case MakeAuth(token: String, name: String, National_ID: String, card_a: String, card_b: String)
    /**
     *  获取分类列表
     *
     *  @param String 级别id，0表示1级，null表示所有
     *
     *  @return 路由
     */
    case CategoryList(cat_id: String)
    /**
     *  获取商品详细信息
     *
     *  @param String 商品id
     *
     *  @return 路由
     */
    case GoodsDetail(token:String, good_id: String)
    /**
     *  加入购物车
     *
     *  @param String 用户标示
     *  @param String 商品id
     *  @param String 购买数量
     *  @param String 商品规格
     *
     *  @return 路由
     */
    case AddToCart(token: String, goods_id: String, goods_number: String, goods_spec: String)
    /**
     *  获取购物车列表
     *
     *  @param String 用户标示
     *  @param String 当前页
     *  @param String 每页大小
     *
     *  @return 路由
     */
    case CartList(token: String, current_page: String, page_size: String)
    case Search(keywords: String)
    /**
     *  反馈
     *
     *  @param String 用户标示
     *  @param String 反馈内容
     *
     *  @return 路由
     */
    case Feedback(token: String, content: String)
    /**
     *  获取收藏列表
     *
     *  @param String 用户标示
     *  @param String 当前页
     *  @param String 每页大小
     *
     *  @return 路由
     */
    case CollectList(token: String, current_page: String, page_size: String)
    /**
     *  收藏或取消收藏
     *
     *  @param String 用户标示
     *  @param String 商品id
     *  @param String type  可以不传或传 0         则为收藏  1为取消收藏
     *
     *  @return 路由
     */
    case CollectAction(token: String, goods_id: String, collect_type: String)
    
    var URLRequest: NSMutableURLRequest {
        var URL = NSURL(string: Router.baseURLString)!
        if let path = path {
            URL = URL.URLByAppendingPathComponent(path)
        }
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "POST"
        mutableURLRequest.timeoutInterval = 5
        
        switch self {
        case .Search:
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        }
    }
}

//Path
extension Router {
    
    var path: String? {
        switch self {
        case .Authcode:
            return "api/user/authcode"
        case .DynamicPassword:
            return "api/user/authcode"
        case .Register:
            return "api/user/register"
        case .Login:
            return "api/user/login"
        case .GoodsList:
            return "api/goods/listGoods"
        case .OrderList:
            return "api/user/userLibrary"
        case .UploadCard:
            return "api/user/uploadCard"
        case .MakeAuth:
            return "api/user/auth"
        case .CloudHouse:
            return "api/user/userLibrary"
        case .CategoryList:
            return "api/goods/category"
        case .GoodsDetail:
            return "api/goods/goodsSpec"
        case .AddToCart:
            return "api/cart/addCart"
        case .CartList:
            return "api/cart/cartList"
        case .Search:
            return "api/goods/goodsList"
        case .Feedback:
            return "api/user/userFeedback"
        case .CollectList:
            return "api/goods/collectList"
        case .CollectAction:
            return "api/goods/collectGoods"
        }
    }
}


//parameters
extension Router {
    var parameters: [String : String]? {
        switch self {
        case let .Authcode(tel):
            return ["t" : tel]
        case let .DynamicPassword(tel):
            return ["t" : tel]
        case .Register(let tel, let authcode, var password, let inviteCode):
            if !password.isEmpty {
                let p = password as NSString
                password = p.md5String()!
            }
            return ["t" : tel, "au" : authcode, "p" : password, "l" : inviteCode]
        case let .Login(tel, password, dynamicPassword, cid):
            return ["t" : tel, "p" : password, "au" : dynamicPassword, "cid" : cid]
        case let .GoodsList(cat_id, brand_id, currentPage, pageSize):
            return ["cat_id" : cat_id, "brand_id" : brand_id, "cp" : currentPage, "ps" : pageSize]
        case let .OrderList(token, currentPage, pageSize):
            return ["token" : token, "cp" : currentPage, "ps" : pageSize]
        case .UploadCard():
            return nil
        case let .MakeAuth(token, name, National_ID, card_a, card_b):
            return ["token" : token, "name" : name, "number" : National_ID, "card_a" : card_a, "card_b" : card_b]
        case let .CloudHouse(token, currentPage, pageSize):
            return ["token" : token, "cp" : currentPage, "ps" : pageSize]
        case let .CategoryList(cat_id):
            return ["cat_id" : cat_id]
        case let .GoodsDetail(token, good_id):
            return ["token" : token, "gd" : good_id]
        case let .AddToCart(token, goods_id, goods_number, goods_spec):
            return ["token" : token, "gd" : goods_id, "gn" : goods_number, "gc" : goods_spec]
        case let .CartList(token, current_page, page_size):
            return ["token" : token, "cp" : current_page, "ps" : page_size]
        case let .Search(keywords):
            return ["keywords" : keywords]
        case let .Feedback(token, content):
            return ["token" : token, "content" : content]
        case let .CollectList(token, current_page, page_size):
            return ["token" : token, "cp" : current_page, "ps" : page_size]
        case let .CollectAction(token, goods_id, collect_type):
            return ["token" : token, "goods_id" : goods_id, "type" : collect_type]
        }
    }
}














