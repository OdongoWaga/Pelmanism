//
//  CardModel.swift
//  Pelmanism
//
//  Created by JFJ on 10/09/2019.
//  Copyright © 2019 JFJ. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        //Declare an array to store numbers
        
        var generatedNumbersArray = [Int]()
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        // Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            // Get a Random Number
            
            let randomNumber = Int.random(in: 0 ... 13)
            
            //Ensure the random number isn't one we already have
            if generatedNumbersArray.contains(randomNumber) == false {
                //Log the Number
                print(randomNumber)
                
                //Store number in generated numbers array
                
                generatedNumbersArray.append(Int(randomNumber))
                
                //First Card
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                //Second Card
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
            
            
            
            //Optional Make it so we only have unique pairs
            
        }
        
        //Randomise Array
        for i in 0 ... generatedCardsArray.count-1 {
        let randomNumber = Int.random(in: 0...generatedCardsArray.count-1)
        
            //Swap cards
        let temporaryStorage = generatedCardsArray[i]
        generatedCardsArray[i] = generatedCardsArray[randomNumber]
        generatedCardsArray[randomNumber] = temporaryStorage
        }
        //Return Array
        return generatedCardsArray
    }
}
