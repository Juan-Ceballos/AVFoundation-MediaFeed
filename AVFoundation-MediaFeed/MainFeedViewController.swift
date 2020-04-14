//
//  ViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Juan Ceballos on 4/13/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import AVFoundation // video player is done on a CALayer
import AVKit

class MainFeedViewController: UIViewController {

    @IBOutlet weak var videoButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    private var mediaObjects = [MediaObject]() {
        didSet  {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        if !UIImagePickerController.isSourceTypeAvailable(.camera)  {
            videoButton.isEnabled = false
        }
    }
    
    private func configureCollectionView()  {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
        //NSCameraUsageDescription
        //
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    private func playRandomVideo(in view: UIView)  {
        let videoURLs = mediaObjects.compactMap {$0.videoURL}
            if let videoURL = videoURLs.randomElement() {
                let player = AVPlayer(url: videoURL)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = view.bounds
                playerLayer.videoGravity = .resizeAspect
                view.layer.sublayers?.removeAll()
                view.layer.addSublayer(playerLayer)
                player.play()
            }
    }
    
}

// MARK: UICollectionView Datasource Methods

extension MainFeedViewController: UICollectionViewDataSource    {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else    {
            fatalError("could not dequeue media cell")
        }
        
        let mediaObject = mediaObjects[indexPath.row]
        cell.configureCell(for: mediaObject)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // sub class going to downcast as headerView, supView of CollView
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else    {
            fatalError("could not dequeue headerView")
        }
        playRandomVideo(in: headerView)
        return headerView
    }
    
}

// MARK: UICollectionView Delegate Methods

extension MainFeedViewController: UICollectionViewDelegateFlowLayout    {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mediaObject = mediaObjects[indexPath.row]
        
        guard let videoURL = mediaObject.videoURL else  {
            return
        }
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        present(playerViewController, animated: true)   {
            player.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.40
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.40)
    }
}

extension MainFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // infoKey.originalImage
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
            else    {
                return
        }
        
        switch mediaType    {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageData = originalImage.jpegData(compressionQuality: 1.0)  {
                let mediaObject = MediaObject(imageData: imageData, videoURL: nil, caption: nil)
                mediaObjects.append(mediaObject)
            }
        case "public.movie":
            if let medieURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL    {
                print(medieURL)
                let mediaObject = MediaObject(imageData: nil, videoURL: medieURL, caption: nil)
                mediaObjects.append(mediaObject)
            }
        default:
            print("unsupported media type")
        }
        
        print("mediaType: \(mediaType)") // "public.movie", "public.image"
        picker.dismiss(animated: true)
    }
}
