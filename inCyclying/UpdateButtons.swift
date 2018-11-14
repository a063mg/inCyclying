//
//  UpdateButtons.swift
//  inCyclying
//
//  Created by Alekseev Artem on 30.09.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit

enum buttonTypeState {
    case started
    case paused
    case finished
    case loaded
}

enum buttonReuseId {
    case startButton //1
    case startBigButton //2
    case doneButton //3
    case doneBigButton //4
    case stopButton //5
}

extension ViewController {

    func makeSartButton() -> UIButton{
        buttonTitle = "Start"
        
        let buttonFrame = CGRect(x:0, y: screenSize.height-130,
                                 width: screenSize.width/2,
                                 height: 50.0)
        
        let button = UIButton(frame: buttonFrame)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font =  UIFont(name: fontName, size: 25)
        button.tag = 1
        
        button.addTarget(self,
                         action: #selector(startButtonPressed),
                         for: UIControlEvents.touchUpInside)
        button.addTarget(self,
                         action: #selector(startButtonTouchedUpOutside),
                         for: UIControlEvents.touchUpOutside)
        button.addTarget(self,
                         action: #selector(startButtonTouchedDown),
                         for: UIControlEvents.touchDown)
        
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = startButtonColor
        return button
    }
    
    @objc func startButtonPressed() {
        if let button = self.view.viewWithTag(1){
            button.backgroundColor = startButtonColor
            buttonType = .started
            updateButtons()
            startRun()
        }
    }
    
    @objc func startButtonTouchedUpOutside() {
        if let button = self.view.viewWithTag(1){
            button.backgroundColor = startButtonColor
        }
    }
    
    @objc func startButtonTouchedDown() {
        if let button = self.view.viewWithTag(1){
            button.backgroundColor = startButtonDarkColor
        }
    }
    
    func makeBigSartButton() -> UIButton{
        buttonTitle = "Start"
        
        let buttonFrame = CGRect(x:0, y: screenSize.height-130,
                                 width: screenSize.width,
                                 height: 50.0)
        
        let button = UIButton(frame: buttonFrame)
        button.layer.cornerRadius = 4
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font =  UIFont(name: fontName, size: 25)
        button.tag = 2
        
        button.addTarget(self,
                         action: #selector(startBigButtonPressed),
                         for: UIControlEvents.touchUpInside)
        button.addTarget(self,
                         action: #selector(startBigButtonTouchedUpOutside),
                         for: UIControlEvents.touchUpOutside)
        button.addTarget(self,
                         action: #selector(startBigButtonTouchedDown),
                         for: UIControlEvents.touchDown)
        
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = startButtonColor
        return button
    }
    
    @objc func startBigButtonPressed() {
        if let button = self.view.viewWithTag(2){
            button.backgroundColor = startButtonColor
            buttonType = .started
            updateButtons()
            startRun()
        }
    }
    
    @objc func startBigButtonTouchedUpOutside() {
        if let button = self.view.viewWithTag(2){
            button.backgroundColor = startButtonColor
        }
    }
    
    @objc func startBigButtonTouchedDown() {
        if let button = self.view.viewWithTag(2){
            button.backgroundColor = startButtonDarkColor
        }
    }


    func makeDoneButton() -> UIButton{
        buttonTitle = "Done"
        
        let buttonFrame = CGRect(x: screenSize.width - (screenSize.width/2), y: screenSize.height-130,
                                 width: screenSize.width/2,
                                 height: 50.0)
        
        let button = UIButton(frame: buttonFrame)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font =  UIFont(name: fontName, size: 25)
        button.tag = 3
        button.addTarget(self,
                         action: #selector(doneButtonPressed),
                         for: UIControlEvents.touchUpInside)
        button.addTarget(self,
                         action: #selector(doneButtonTouchedUpOutside),
                         for: UIControlEvents.touchUpOutside)
        button.addTarget(self,
                         action: #selector(doneButtonTouchedDown),
                         for: UIControlEvents.touchDown)
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = doneButtonColor
        return button
    }
    
    @objc func doneButtonPressed() {
        if let button = self.view.viewWithTag(3){
            button.backgroundColor = doneButtonColor
            endRun()
        }
    }
    
    @objc func doneButtonTouchedUpOutside() {
        if let button = self.view.viewWithTag(3){
            button.backgroundColor = doneButtonColor
        }
    }
    
    @objc func doneButtonTouchedDown() {
        if let button1 = self.view.viewWithTag(3){
            button1.backgroundColor = doneButtonDarkColor
        }
    }
    
    func makeBigDoneButton() -> UIButton{
        buttonTitle = "Done"
        
        let buttonFrame = CGRect(x: screenSize.width - (screenSize.width), y: screenSize.height-130,
                                 width: screenSize.width,
                                 height: 50.0)
        
        let button = UIButton(frame: buttonFrame)
        button.layer.cornerRadius = 4
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font =  UIFont(name: fontName, size: 25)
        button.tag = 4
        button.addTarget(self,
                         action: #selector(doneBigButtonPressed),
                         for: UIControlEvents.touchUpInside)
        button.addTarget(self,
                         action: #selector(doneBigButtonTouchedUpOutside),
                         for: UIControlEvents.touchUpOutside)
        button.addTarget(self,
                         action: #selector(doneBigButtonTouchedDown),
                         for: UIControlEvents.touchDown)
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = doneButtonColor
        return button
    }
    
    @objc func doneBigButtonPressed() {
        if let button = self.view.viewWithTag(4){
            button.backgroundColor = doneButtonColor
            endrun()
        }
    }
    
    @objc func doneBigButtonTouchedUpOutside() {
        if let button = self.view.viewWithTag(4){
            button.backgroundColor = doneButtonColor
        }
    }
    
    @objc func doneBigButtonTouchedDown() {
        if let button1 = self.view.viewWithTag(4){
            button1.backgroundColor = doneButtonDarkColor
        }
    }
    
    func makeStopButton() -> UIButton{
        
        buttonTitle = "Stop"
        
        let buttonFrame = CGRect(x:0, y: screenSize.height-130,
                                 width: screenSize.width,
                                 height: 50.0)
        
        let button = UIButton(frame: buttonFrame)
        button.layer.cornerRadius = 4
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font =  UIFont(name: fontName, size: 25)
        button.tag = 5
        
        button.addTarget(self,
                         action: #selector(stopButtonPressed),
                         for: UIControlEvents.touchUpInside)
        button.addTarget(self,
                         action: #selector(stopButtonTouchedUpOutside),
                         for: UIControlEvents.touchUpOutside)
        button.addTarget(self,
                         action: #selector(stopButtonTouchedDown),
                         for: UIControlEvents.touchDown)
        
        button.backgroundColor = stopButtonColor
        return button
    }
    
    @objc func stopButtonPressed() {
        if let button = self.view.viewWithTag(5){
            button.backgroundColor = stopButtonColor
            buttonType = .paused
            updateButtons()
            stopRun()
        }
    }
    
    @objc func stopButtonTouchedUpOutside() {
        if let button = self.view.viewWithTag(5){
            button.backgroundColor = stopButtonColor
        }
    }
    
    @objc func stopButtonTouchedDown() {
        if let button = self.view.viewWithTag(5){
            button.backgroundColor = stopButtonDarkColor
        }
    }
}
