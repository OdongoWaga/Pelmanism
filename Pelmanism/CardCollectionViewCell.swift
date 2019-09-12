//
//  CardCollectionViewCell.swift
//  Pelmanism
//
//  Created by JFJ on 11/09/2019.
//  Copyright © 2019 JFJ. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func setCard(_ card: Card) {
        
        //Keep track of the card that gets passed in
        
        self.card = card
        
        if card.isMatched == true {
            // if card has been matched make image views invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        } else {
            // if card has not been matched make image views visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
            
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //Determine if the card is in a flipped up state or flipped down state
        
        if card.isFlipped == true {
            //Make sure front image view is ontop
             UIView.transition(from: backImageView, to: frontImageView, duration: 0.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
            // Make sure the backimage view is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0.0, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
        }
        
    }
    func flip(){
     UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
        
    }
    
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
             UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
        }
       
    }
    
    
    func remove () {
        
        // Removes both imageviews from visibility
         backImageView.alpha = 0
        // TODO: Animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0

        }, completion: nil)
        
       
            }
    
    
}
