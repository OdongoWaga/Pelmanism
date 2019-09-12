//
//  ViewController.swift
//  Pelmanism
//
//  Created by JFJ on 10/09/2019.
//  Copyright © 2019 JFJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex: IndexPath?
    var timer: Timer?
    var milliseconds:Float = 30000
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Create Timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
        // Call the getCards method of the card model.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        //convert to seconds
        
       let seconds = String(format: "%.2f", milliseconds/1000)
        
        //set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // Timer reaching zero
        
        if milliseconds <= 0 {
            
            //Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //Check if there are any unmatched cards
            checkGameEnded()
        }
        
    }

    //MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get Card CollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        //Set the card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Check if there's any time left
        
        if milliseconds <= 0 {
            return
        }
        
        //Get the cell that the user selected
        let cell = collectionView.cellForItem(at:  indexPath) as! CardCollectionViewCell
        
        //Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            //Flip the card
            cell.flip()
            
            //Play sound
            
            SoundManager.playSound(.flip)
            
            // Set the status of the card
            card.isFlipped = true
            
            //Determine if this is the first or second card that is flipped.
            
            if firstFlippedCardIndex == nil {
                
                // if it is the first card to be flipped
                
                firstFlippedCardIndex = indexPath
            }
            else{
                // This is the second card being flipped
                
                //TODO: Perform matching logic
                
                checkForMatches(indexPath)
                
                
            }
        }
        
        
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        // Get the cells for the two cards that were revealed
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        //Get the cards for the two cards that were revealed
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //Compare the two cards
        
        if cardOne.imageName == cardTwo.imageName {
            
            //Its a match
            
            //play sound
            SoundManager.playSound(.match)
            
            //Set the statuses of the cards
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            
            //remove the cards from the grid
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //Check if there are any cards left unmatched
            
            checkGameEnded()
            
            
        } else{
            //Its not a match
            
            //Play Sound
            SoundManager.playSound(.nomatch)
            
            //Set the statuses of the cards
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //Flip the cards back
            cardOneCell? .flipBack()
            cardTwoCell?.flipBack()
        }
        // Tell the collectionView to reload the cell of the first card if it is nil
        
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        //Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded() {
        // Determine if there are any unmatched cards
        
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // Messaging Variables for alerts
        var title = " "
        var message = " "
        
        //If not then user has won
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratuweldone!"
            message = " You have won"
            
        }
        else {
            //if there are unmatched cards, check if there is any time left
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You have lost"
        }
        
        
        
        // Show won or lost messagaing
        
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil )
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

