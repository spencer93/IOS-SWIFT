//
//  GoogleMobAd.swift
//  DodgeGame
//
//  Created by spencer maas on 3/12/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension GoogleMobAd {
    static var ad = GoogleMobAd()
}
class GoogleMobAd: NSObject, GADInterstitialDelegate {

    /// The interstitial ad.
    private var interstitial: GADInterstitial!
    var view: UIViewController!
    private var uninterruptedPlays = 1
    private var adIndex = 0
    
    override init() {
        super.init()
        self.interstitial = createAndLoadInterstitial()
    }
    
    func displayAd() {
        if shouldDisplayAd() {
            interstitial.present(fromRootViewController: view) 
        }
    }
    
    private func shouldDisplayAd() -> Bool {
        if uninterruptedPlays < GameplayConfiguration.Advertisement.frequency[adIndex] {
            // dont play the ad this time
            uninterruptedPlays += 1
            return false
        }
        else {
            if adIndex == GameplayConfiguration.Advertisement.frequency.count-1 {
                adIndex = 0
            }
            else {
                adIndex += 1
            }
            uninterruptedPlays = 0
            return true
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        //let request = GADRequest()
        //request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9a" ]
        //request.testDevices = [ "71bc3d63bbf2d4ed0d4ced07746524aa" ];
        interstitial.load(GADRequest())
        return interstitial
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        // Load a new ad so it is prepared for next time ensuring no delay
        interstitial = createAndLoadInterstitial()
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
}
