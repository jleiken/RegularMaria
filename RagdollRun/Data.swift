//
//  Data.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/10/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import SpriteKit

struct Physics {
    static let AVATAR_CONTACT_MASK = UInt32(0x0000000F)
    static let COIN_CONTACT_MASK = UInt32(0b1)
    
    static let WORLD_Z = CGFloat(5.0)
    static let TOP_Z = CGFloat(10.0)
}

struct SpriteNames {
    static let AVATAR_NAME = "avatar"
    static let GROUND_NAME = "ground"
    static let OBSTACLE_NAME = "obstacle"
    static let ENEMY_NAME = "enemy"
    static let COUNTER_NAME = "counter"

    static let MENU_NAME = "menuBut"
    static let PLAY_NAME = "playBut"
    static let BACK_NAME = "backBut"
    static let MUTE_NAME = "muteBut"
    static let COIN_NAME = "coins"
    static let SCORE_NAME = "scoreBut"
    static let NO_SOUND_NAME = "toggleSoundBut"
    static let CUSTOMIZE_NAME = "customizeBut"
    static let CI_NAME = "ci"
}

struct Formats {
    static let BACKGROUND = hexStringToUIColor("afe5fd")
    static let HIGHLIGHT = hexStringToUIColor("f4ac45")
    static let SHADOW_COLOR = SKColor.black
    static let SHADOW_ALPHA = 0.25
    static let SHADOW_STANDARD_OFFSET = CGPoint(x: 2.5, y: -2.5)
    static let TITLE_FONT = "AvenirNext-Heavy"
    static let EMPHASIS_FONT = "AvenirNext-Bold"
    static let LABEL_FONT = "AvenirNext-DemiBold"
}

struct AdMob {
    #if DEBUG
    static let bannerUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let rewardUnitID = "ca-app-pub-3940256099942544/1712485313"
    static let intersUnitID = "ca-app-pub-3940256099942544/4411468910"
    #else
    static let bannerUnitID = "ca-app-pub-1525379522124593/1839912973"
    static let rewardUnitID = "ca-app-pub-1525379522124593/9818840300"
    static let intersUnitID = "ca-app-pub-1525379522124593/4269950402"
    #endif
}

/// A structure of messages that will be displayed to users, from Apple's StoreKit demo
struct Messages {
    static let cannotMakePayments = "\(notAuthorized) \(installing)"
    static let couldNotFind = "Could not find resource file:"
    static let deferred = "Allow the user to continue using your app."
    static let deliverContent = "Deliver content for"
    static let emptyString = ""
    static let error = "Error: "
    static let failed = "failed."
    static let installing = "In-App Purchases may be restricted on your device."
    static let invalidIndexPath = "Invalid selected index path"
    static let noRestorablePurchases = "There are no restorable purchases.\n\(previouslyBought)"
    static let noPurchasesAvailable = "No purchases available."
    static let notAuthorized = "You are not authorized to make payments."
    static let okButton = "OK"
    static let previouslyBought = "Only previously bought non-consumable products and auto-renewable subscriptions can be restored."
    static let productRequestStatus = "Product Request Status"
    static let purchaseOf = "Purchase of"
    static let purchaseStatus = "Purchase Status"
    static let removed = "was removed from the payment queue."
    static let restorable = "All restorable transactions have been processed by the payment queue."
    static let restoreContent = "Restore content for"
    static let status = "Status"
    static let unableToInstantiateAvailableProducts = "Unable to instantiate an AvailableProducts."
    static let unableToInstantiateInvalidProductIds = "Unable to instantiate an InvalidProductIdentifiers."
    static let unableToInstantiateMessages = "Unable to instantiate a MessagesViewController."
    static let unableToInstantiateNavigationController = "Unable to instantiate a navigation controller."
    static let unableToInstantiateProducts = "Unable to instantiate a Products."
    static let unableToInstantiatePurchases = "Unable to instantiate a Purchases."
    static let unableToInstantiateSettings = "Unable to instantiate a Settings."
    static let unknownPaymentTransaction = "Unknown payment transaction case."
    static let unknownDestinationViewController = "Unknown destination view controller."
    static let unknownDetail = "Unknown detail row:"
    static let unknownPurchase = "No selected purchase."
    static let unknownSelectedSegmentIndex = "Unknown selected segment index: "
    static let unknownSelectedViewController = "Unknown selected view controller."
    static let unknownTabBarIndex = "Unknown tab bar index:"
    static let unknownToolbarItem = "Unknown selected toolbar item: "
    static let updateResource = "Update it with your product identifiers to retrieve product information."
    static let useStoreRestore = "Use Store > Restore to restore your previously bought non-consumable products and auto-renewable subscriptions."
    static let viewControllerDoesNotExist = "The main content view controller does not exist."
    static let windowDoesNotExist = "The window does not exist."
}
