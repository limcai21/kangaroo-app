//
//  Products.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit

class Products {
    var poster: String
    var title: String
    var description: String
    var bg1: String
    var bg2: String
    var price: Double
    var platform: [String]
    var publisher: String
    var releaseDate: String
    var developer: String
    var logo: String
    var tags: [String]
    var shortD: String
    var bg3: String
    
    init(poster: String, title: String, description: String, bg1: String, bg2: String, price: Double, platform: [String], publisher: String, releaseDate: String, developer: String, logo: String, tags: [String], shortD: String, bg3: String) {
        self.poster = poster
        self.title = title
        self.description = description
        self.bg1 = bg1
        self.bg2 = bg2
        self.price = price
        self.platform = platform
        self.publisher = publisher
        self.releaseDate = releaseDate
        self.developer = developer
        self.logo = logo
        self.tags = tags
        self.shortD = shortD
        self.bg3 = bg3
    }
}

let allProducts: [Products] = [
    // xbox
    Products(poster: "forza poster", title: "Forza Horizon 5: Standard Edition", description: "Explore the vibrant and ever-evolving open world landscapes of Mexico with limitless, fun driving action in hundreds of the world’s greatest cars.", bg1: "forza bg", bg2: "forza bg2", price: 79.90, platform: ["xbox one", "xbox series x|s"], publisher: "Xbox Game Studios", releaseDate: "8 Novemeber 2021", developer: "Playground Games", logo: "forza logo", tags: ["xbox", "new", "multiplayer", "slider"], shortD: "Your Ultimate Horizon Adventure awaits!", bg3: "forza bg3"),
    Products(poster: "halo poster", title: "Halo Infinite (Campaign)", description: "When all hope is lost and humanity’s fate hangs in the balance, the Master Chief is ready to confront the most ruthless foe he’s ever faced. Step inside the armor of humanity’s greatest hero to experience an epic adventure and explore the massive scale of the Halo ring. To experience the campaign, purchase Halo Infinite (Campaign).", bg1: "halo bg", bg2: "halo bg2", price: 79.90, platform: ["xbox one", "xbox series x|s"], publisher: "Xbox Game Studios", releaseDate: "9 November 2021", developer: "343 Industries", logo: "halo logo", tags: ["xbox"], shortD: "The legendary Halo series returns with the most expansive Master Chief campaign yet and a ground-breaking free to play multiplayer experience.", bg3: "halo bg3"),
    Products(poster: "msfs poster", title: "Microsoft Flight Simulator: Standard Edition", description: "Microsoft Flight Simulator is the next generation of one of the most beloved simulation franchises. From light planes to wide-body jets, fly highly detailed and stunning aircraft in an incredibly realistic world. Create your flight plan and fly anywhere on the planet. Enjoy flying day or night and face realistic, challenging weather conditions.", bg1: "msfs bg", bg2: "msfs bg2", price: 75.00, platform: ["xbox series x|s"], publisher: "Xbox Game Studios", releaseDate: "19 Novemeber 2021", developer: "Asobo Studio", logo: "msfs logo", tags: ["xbox", "multiplayer"], shortD: "Take to the skies and experience the joy of flight in the next generation of Microsoft Flight Simulator. The world is at your fingertips.", bg3: "msfs bg3"),
    Products(poster: "ori poster", title: "Ori and the Will of the Wisps", description: "Discover Ori’s true destiny \nEmbark on a journey in a vast, exotic world where you’ll encounter towering enemies and challenging puzzles on your quest, in the must-play sequel, fully optimized for Xbox Series X and Xbox Series S. \n\nThe little spirit Ori is no stranger to peril, but when a fateful flight puts the owlet Ku in harm’s way, it will take more than bravery to bring a family back together, heal a broken land, and discover Ori’s true destiny. From the creators of the acclaimed action-platformer Ori and the Blind Forest comes an adventure through a beautiful world filled with friends and foes that come to life in stunning, hand-painted artwork. Set to a fully orchestrated original score, Ori and the Will of the Wisps continues the Moon Studios tradition of tightly crafted platforming action and deeply emotional storytelling.", bg1: "ori bg", bg2: "ori bg2", price: 39.75, platform: ["xbox one", "xbox series x|s"], publisher: "Xbox Game Studios", releaseDate: "11 March 2020", developer: "Moon Studios", logo: "ori logo", tags: ["xbox"], shortD: "Embark on an all-new adventure in a vast, exotic world where you’ll encounter towering enemies and challenging puzzles on your quest to discover Ori’s destiny.", bg3: "ori bg3"),
    Products(poster: "sot poster", title: "Sea of Thieves", description: "Sea of Thieves offers the essential pirate experience, from sailing and fighting to exploring and looting – everything you need to live the pirate life and become a legend in your own right. With no set roles, you have complete freedom to approach the world, and other players, however you choose. Whether you’re voyaging as a group or sailing solo, you’re bound to encounter other crews in this shared world adventure – but will they be friends or foes, and how will you respond?", bg1: "sot bg", bg2: "sot bg2", price: 49.50, platform: ["xbox one", "xbox series x|s"], publisher: "Microsoft Studios", releaseDate: "20 March 2018", developer: "Rare Ltd", logo: "sot logo", tags: ["xbox", "multiplayer"], shortD: "A shared-world adventure game that lets you be the pirate you’ve always dreamed of in a world of danger and discovery. Explore a vast ocean where any sail on the horizon could mean a ship filled with real players who may be friends or foes. Form a crew and voyage to treasure-filled islands, face legendary creatures and test your mettle in epic ship battles against other pirates.", bg3: "sot bg3"),

    // playstation
    Products(poster: "ds poster", title: "Death Stranding: Director’s Cut", description: "Sam Bridges must brave a world utterly transformed by the Death Stranding. Carrying the stranded remnants of the future in his hands, Sam embarks on a journey to reunite the shattered world one step at a time. What is the mystery of the Death Stranding? What will Sam discover on the road ahead? A genre defining gameplay experience holds these answers and more.", bg1: "ds bg", bg2: "ds bg2", price: 67.90, platform: ["ps5"], publisher: "PlayStation Studios", releaseDate: "29 Septemeber 2021", developer: "Kojima Productions", logo: "ds logo", tags: ["playstation", "multiplayer"], shortD: "Can you reunite the shattered world, one step at a time?", bg3: "ds bg3"),
    Products(poster: "dl poster", title: "Deathloop: Standard Edition", description: "DEATHLOOP is a next-gen first person shooter from Arkane Lyon, the award-winning studio behind Dishonored. In DEATHLOOP, two rival assassins are trapped in a mysterious timeloop on the island of Blackreef, doomed to repeat the same day for eternity. As Colt, the only chance for escape is to end the cycle by assassinating eight key targets before the day resets. Learn from each cycle - try new paths, gather intel, and find new weapons and abilities. Do whatever it takes to break the loop.", bg1: "dl bg", bg2: "dl bg2", price: 84.90, platform: ["ps5"], publisher: "Bethesda Softworks", releaseDate: "14 September 2021", developer: "Arkane Studios", logo: "dl logo", tags: ["playstation", "multiplayer"], shortD: "", bg3: "dl bg3"),
    Products(poster: "hfw poster", title: "Horizon Forbidden West™", description: "Explore distant lands, fight bigger and more awe-inspiring machines, and encounter astonishing new tribes as you return to the far-future, post-apocalyptic world of Horizon.\n\nThe land is dying. Vicious storms and an unstoppable blight ravage the scattered remnants of humanity, while fearsome new machines prowl their borders. Life on Earth is hurtling towards another extinction, and no one knows why.\n\nIt's up to Aloy to uncover the secrets behind these threats and restore order and balance to the world. Along the way, she must reunite with old friends, forge alliances with warring new factions and unravel the legacy of the ancient past – all the while trying to stay one step ahead of a seemingly undefeatable new enemy.", bg1: "hfw bg", bg2: "hfw bg2", price: 79.90, platform: ["ps4", "ps5"], publisher: "Sony Interactive Entertainment", releaseDate: "18 February 2022", developer: "Guerrilla Games", logo: "hfw logo", tags: ["playstation", "new", "slider"], shortD: "\"The lesson will be taught in due time, Aloy. Until then, we wait.\"", bg3: "hfw bg3"),
    Products(poster: "r&c poster", title: "Ratchet & Clank: Rift Apart", description: "BLAST YOUR WAY THROUGH AN INTERDIMENSIONAL ADVENTURE \n\nThe intergalactic adventurers are back with a bang. Help them stop a robotic emperor intent on conquering cross-dimensional worlds, with their own universe next in the firing line. - Blast your way home with an arsenal of outrageous weaponry. - Experience the shuffle of dimensional rifts and dynamic gameplay. - Explore never-before-seen planets and alternate dimension versions of old favorites.", bg1: "r&c bg", bg2: "r&c bg2", price: 97.90, platform: ["ps5"], publisher: "PlayStation Studios", releaseDate: "11 June 2021", developer: "Insomniac Games", logo: "r&c logo", tags: ["playstation"], shortD: "", bg3: "r&c bg3"),
    Products(poster: "sifu poster", title: "Sifu", description: "Sifu is the story of a young Kung Fu student on a path of revenge, hunting for the murderers of his family. One against all, he has no allies, and countless enemies. He has to rely on his unique mastery of Kung Fu as well as a mysterious pendant to prevail, and preserve his family’s legacy.", bg1: "sifu bg", bg2: "sifu bg2", price: 54.90, platform: ["ps4", "ps5"], publisher: "SLOCLAP S.A.S", releaseDate: "8 February 2022", developer: "SLOCLAP S.A.S", logo: "sifu logo", tags: ["playstation", "new"], shortD: "An action beat 'em up game played from a third-person perspective", bg3: "sifu bg3"),
    
    // cross - platform
    Products(poster: "codv poster", title: "Call of Duty®: Vanguard - Standard Edition", description: "Rise on every front: Dogfight over the Pacific, airdrop over France, defend Stalingrad with a sniper’s precision and blast through enemies in North Africa. Experience influential battles of World War II as you fight for victory across multiple theaters of war. The Call of Duty®: Vanguard campaign will immerse you in a deeply engaging and gripping character-driven narrative experience featuring combat on an unparalleled global scale, while also telling the harrowing stories of those who turned the tides of war and changed history forever.", bg1: "codv bg", bg2: "codv bg2", price: 79.90, platform: ["xbox one", "ps4", "xbox series x|s", "ps5"], publisher: "Activision Publishing Inc.", releaseDate: "10 November 2021", developer: "Sledgehammer Games", logo: "codv logo", tags: ["cross platform", "multiplayer", "xbox", "playstation"], shortD: "RISE ON EVERY FRONT", bg3: "codv bg3"),
    Products(poster: "it2 poster", title: "It Takes Two", description: "Embark on the craziest journey of your life in It Takes Two, a genre-bending platform adventure created purely for co-op. Invite a friend to join for free with Friend’s Pass* and work together across a huge variety of gleefully disruptive gameplay challenges. Play as the clashing couple Cody and May, two humans turned into dolls by a magic spell. Together, trapped in a fantastical world where the unpredictable hides around every corner, they are reluctantly challenged with saving their fractured relationship.", bg1: "it2 bg", bg2: "it2 bg2", price: 54.90, platform: ["xbox one", "ps4", "xbox series x|s", "ps5"], publisher: "Electronic Arts", releaseDate: "26 March 2021", developer: "Hazelight", logo: "it2 logo", tags: ["cross platform", "multiplayer", "xbox", "playstation"], shortD: "Pure Co-Op Perfection. A Universal Tale of Relationships", bg3: "it2 bg3"),
    Products(poster: "p2 poster", title: "Psychonauts 2", description: "Razputin “Raz” Aquato, trained acrobat and powerful young psychic, has realized his lifelong dream of joining the international psychic espionage organization known as the Psychonauts! But these psychic super spies are in trouble. Their leader hasn't been the same since he was rescued from a kidnapping, and what's worse, there's a mole hiding in headquarters. \n\nCombining quirky missions and mysterious conspiracies, Psychonauts 2 is a platform-adventure game with cinematic style and tons of customizable psychic powers. Psychonauts 2 serves up danger, excitement and laughs in equal measure as players guide Raz on a journey through the minds of friends and foes on a quest to defeat a murderous psychic villain.", bg1: "p2 bg", bg2: "p2 bg2", price: 54.75, platform: ["xbox one", "ps4", "xbox series x|s"], publisher: "Xbox Game Studios", releaseDate: "25 August 2021", developer: "Double Fine Productions", logo: "p2 logo", tags: ["cross platform", "xbox", "playstation"], shortD: "Combining quirky missions and mysterious conspiracies, Psychonauts 2 is a platform-adventure game with cinematic style and tons of customisable psychic powers.", bg3: "p2 bg3"),
    Products(poster: "r6e poster", title: "Tom Clancy’s Rainbow Six® Extraction", description: "Rainbow Six Extraction is a 1- to 3-player co-op tactical FPS. The elite operators of Rainbow Six are now united to face a common enemy: a highly lethal threat known as the Archeans. Assemble your team and risk everything in tense incursions in the containment zone. Knowledge, cooperation, and a tactical approach are your best weapons. Band together and put everything on the line as you take on this unknown enemy.", bg1: "r6e bg", bg2: "r6e bg2", price: 54.75, platform: ["xbox one", "ps4", "xbox series x|s", "ps5"], publisher: "UBISOFT", releaseDate: "20 January 2022", developer: "UBISOFT MONTREAL", logo: "r6e logo", tags: ["cross platform", "multiplayer", "slider", "xbox", "playstation"], shortD: "A lot of eyes are on us this time, especially since we have poor intel", bg3: "r6e bg3"),
    Products(poster: "wdl poster", title: "Watch Dogs: Legion", description: "In Watch Dogs Legion, you get to build a resistance from virtually anyone you see as you hack, infiltrate, and fight to take back a near-future London that is facing its downfall, courtesy of state surveillance, private military, and organized crime.\n\nRecruit a well-rounded team to overthrow the wankers ruining this once-great city. The fate of London lies with you.\n\nEach character has their own backstory, personality, and skill set—all of which comes into play as you personalize your team. Swap between characters as you explore an open world online with friends. Enjoy free updates of new modes, rewards, and themed events.\n\nExplore a massive urban open world and visit London’s many famous landmarks – including Trafalgar Square, Big Ben, Tower Bridge, Camden, Piccadilly Circus, or the London Eye.\n\nWelcome to the Resistance.", bg1: "wdl bg", bg2: "wdl bg2", price: 78.75, platform: ["xbox one", "ps4", "xbox series x|s", "ps5"], publisher: "UBISOFT", releaseDate: "29 October 2020", developer: "UBISOFT TORONTO", logo: "wdl logo", tags: ["cross platform", "multiplayer", "xbox", "playstation"], shortD: "Take back London. Anyone can be your weapon", bg3: "wdl bg3")
]


// template 
// Products(poster: "", title: "", description: "", bg1: "", bg2: "", price: 0, platform: [""], publisher: "", releaseDate: "", developer: "", logo: "", tags: [""]),







// declare product
class cartProduct {
    var gameName: String
    var gamePlatform: String
    var quantity: Int16
    
    init(gameName: String, gamePlatform: String, quantity: Int16) {
      self.gameName = gameName
      self.gamePlatform = gamePlatform
      self.quantity = quantity
    }
}







// for cart use
class Product {
  var title: String
  var quantity: Int
  var platform: String
  var username: String

  init(title: String, quantity: Int, platform: String, username: String) {
    self.title = title
    self.quantity = quantity
    self.platform = platform
    self.username = username
  }
}


var cartItems: [Product] = []
var tempCart = [Product]()
var differentPlatformCart = [Product]()



var tempUserCart = [[String]]()
var totalCost: Double = 0.0



// for buy now
var buyNowArray = [[String]]()


// for order summary
var doneChoosingAddress = false
var addressHolder = [[String]]()
var choosenAddress = [String]()


// for bad weather
var checkingOfPaymentWay = ""
