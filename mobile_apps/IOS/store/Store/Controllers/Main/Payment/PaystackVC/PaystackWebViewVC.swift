import UIKit
import WebKit

class PaystackWebViewVC: BaseVC {
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var htmlDataString: String!

    var gotPayUResopnse: ((_ message: String, _ isCallIntentAPI:Bool, _ showPaymentRetryDialog: Bool) -> Void)?
    var iSFrom : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }

    func initialViewSetup() {
        lblTitle.text = "TXT_PAYMENT".localized
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.medium)
        self.btnBack.isHidden = false
//        btnBack.setupBackButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        wsGetStripeIntentPayStack()
    }

    @IBAction func onClickBtnMenu(_ sender: Any) {
        self.gotPayUResopnse?("Payment Failed.", false, true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension PaystackWebViewVC: WKNavigationDelegate {
    //MARK:- Get Stripe Intent
    func wsGetStripeIntentPayStack() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
             PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken(),
             PARAMS.TYPE : CONSTANT.TYPE_STORE,
             PARAMS.PAYMENT_ID : Payment.PAYSTACK]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_STRIPE_ADD_CARD_INTENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        {
            (response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                Utility.hideLoading()
                print(response["authorization_url"] as? String)
                let pstkUrl = response["authorization_url"] as? String
                let urlRequest = URLRequest.init(url: URL.init(string: pstkUrl!)!)
                self.view.addSubview(self.webView)
                self.view.bringSubviewToFront(self.webView)
                self.webView.load(urlRequest)
                self.webView.navigationDelegate = self
            } else {
                Utility.hideLoading()
            }
        }
    }

    //This is helper to get url params
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    // This is a WKNavigationDelegate func we can use to handle redirection
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void))  {
        if let url = navigationAction.request.url {
            /*
             We control here when the user wants to cancel a payment.
             By default a cancel action redirects to http://cancelurl.com/.
             Based on our workflow we can for example remove the webview or push
             another view to the user.
             */
            print("reference url \(url)")
            
            if url.absoluteString.contains("add_card_success") {
                self.navigationController?.popViewController(animated: true)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.cancel)
        }

        //After a successful transaction we can check if the current url is the callback url
        //and do what makes sense for our workflow. We can get the transaction reference for example.
        //            if url.absoluteString.hasPrefix("\(WebService.BASE_URL)paystack_add_card_callback"){
        //            if url.absoluteString.contains("paystack_add_card_callback"){
        //                let reference = getQueryStringParameter(url: url.absoluteString, param: "reference")
        //                print("reference \(reference)")
        //            }
    }
}
