import UIKit

class ViewController: UIViewController {

    // declare adView and button
    @IBOutlet weak var myAdView: UIView!
    @IBOutlet weak var myButton: UIButton!

    // declare TKAdNative object
    var myAdNative: TKAdNative?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create TKAdNative object
        self.myAdNative = TKAdNative.init(place: "bc47b614-7b24-4eb1-aae2-65e8de8e96de", category: "")

        // register current presenting view controller
        self.myAdNative?.registerPresenting(self)

        // set delegate
        self.myAdNative?.delegate = self

        // fetch Ad data from API
        self.myAdNative?.fetchAd()
        
        // Set User When Login
            AotterTrek.sharedAPI().setCurrentUserWithEmail("a111111@gmail.com",
                phone: "09XXXXXXXXX",
                fbId: "user_fbId",
                gender: "true",
                birthday: "YYYY/MM/DD",
                addtionalMeta: ["meta":"meta"])
        
        AotterTrek.sharedAPI().updateCurrentUser(withValue: true, for: TKUserKeyGender)
        
        AotterTrek.sharedAPI().removeCurrentUser()
        
        

        //create location object (optional)
        let user_location_lat: Double = 191.232323;
        let user_location_lng: Double = 244.232323;
        let locationObject = TKTracker.helper_locationObject(withLocationId: "<your_location_id>", title: nil, url: "", categories: ["user_location"], address: nil, lat: user_location_lat, lng: user_location_lng, additonalMeta: nil)
        
    }

    // remove and release data when view controller is destroyed
    deinit {
        self.myAdNative?.destroy()
    }
    func engageItemAndSend(){
      let entityObject = TKTracker.helper_entityObject(withTypePOST: "myPostId", title: "post title", url: "https://foo.bar", tags: nil, categories: ["news"], reference: nil, publishedDate: nil, imageUrl: nil, author: nil, meta: nil)
        
      let userObject = TKTracker.helper_userObject(withEmail: "current_user-email", phone: "current_user_phone", fbId: "current_user_fbId", gender: "F or M for current User", birthday: "", addtionalMeta: nil)
      
      TKTracker.sharedAPI().trackerEngageItem(withItemId: "myPostId", type: kTKTTypeREAD_POST, userObject: userObject, entityObject: entityObject, locationObject: nil)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          TKTracker.sharedAPI().trackerExitItem("myPostId")
          TKTracker.sharedAPI().trackerSendItems()
      }
   }
}

extension ViewController: TKAdNativeDelegate {

    func tkAdNative(_ ad: TKAdNative!, didReceivedAdWithData adData: [AnyHashable : Any]!) {
        // Get ad data parameter
        let advertiserName = adData["advertiserName"]
        let title = adData["title"]
        let text = adData["text"]
        let imgMain = adData["img_main"]
        let imageIcon = adData["img_icon"]
        let imageIconHd = adData["img_icon_hd"]
        let callToAction = adData["callToAction"]
        let sponsor = adData["sponser"]

        // register ad view.
        self.myAdNative?.registerAdView(self.myAdView)

        // render ad data
        let adData = ad.adData

        // {render views...}

        // set Action button
        self.myAdNative?.registerCall(toActionButton: self.myButton)
    }

    func tkAdNative(_ ad: TKAdNative!, fetchError error: TKAdError!) {
        print("TKAdNative fetch error" + error.message)
    }
}

