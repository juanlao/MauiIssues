//
//  ViewController.swift
//  nativemacplayer
//
//  Created by Juan Maria Lao Ramos on 6/9/21.
//

import Cocoa
import MediaPlayer

class ViewController: NSViewController {
 
    var isPlaying = false
    
    lazy var player : AVQueuePlayer	 = {
        return AVQueuePlayer()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRemoteTransportControls()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                isPlaying = true
                UpdateIsPlayingOnControlCenter()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                isPlaying = false
                UpdateIsPlayingOnControlCenter()
                return .success
            }
            return .commandFailed
        }
    }

    @IBAction func playStopAction(_ sender: Any) {
        isPlaying = !isPlaying
        
        let podcastUrl = URL(string: "https://chtbl.com/track/84EGD/aphid.fireside.fm/d/1437767933/bd6e0af5-b1d6-4783-9506-d534cfbae69e/99ef39f9-6835-4c1d-9e40-7ece1692798b.mp3")
        
        let playerItem = AVPlayerItem(url: podcastUrl!)

        if self.player.canInsert(playerItem, after: nil){
            self.player.insert(playerItem, after: nil)
            self.player.play()
            setNowPlayingMetadata()
            UpdateIsPlayingOnControlCenter()
            
        }
        
    }
    
    func UpdateIsPlayingOnControlCenter(){
        MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
    }
    
    func setNowPlayingMetadata() {
       
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
        //NSLog("%@", "**** Set track metadata: title \(metadata.title)")
        //nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = metadata.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.audio.rawValue
        //nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = "pepe"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "artis"
//        nowPlayingInfo[MPMediaItemPropertyArtwork] = metadata.artwork
//        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = metadata.albumArtist
//        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metadata.albumTitle
//
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
}

