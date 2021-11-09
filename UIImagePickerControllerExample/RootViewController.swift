//
//  RootViewController.swift
//  UIImagePickerControllerExample
//
//  Created by Alex Nagy on 02/03/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import TinyConstraints
import UIKit

class RootViewController: UIViewController {
    
    let profileImageViewWidth: CGFloat = 100
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "DefaultProfileImage").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = profileImageViewWidth / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var profileImageButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.cornerRadius = profileImageViewWidth / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func profileImageButtonTapped() {
        print("Tapped profile image button")
        showImagePickerControllerActionSheet()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
    }

    fileprivate func setupViews() {
        view.backgroundColor = .white
        addViews()
        constrainViews()
    }
    
    fileprivate func addViews() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
    }
    
    fileprivate func constrainViews() {
        profileImageView.topToSuperview(offset: 36, usingSafeArea: true)
        profileImageView.centerXToSuperview()
        profileImageView.width(profileImageViewWidth)
        profileImageView.height(profileImageViewWidth)
        
        profileImageButton.edges(to: profileImageView)
    }

}

// extensionでimage pickerに関する処理を記述
// UINavigationControllerDelegateを追加する理由：UIImagePickerControllerに遷移するため
extension RootViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Choose your image", message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        // 引数sourceTypeで、photoLibraryかカメラかを選択
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true // 画像の編集を許可（拡大・縮小などでトリミング）
        imagePickerController.sourceType = sourceType // アルバム or camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // フォトアルバムから画像を選択した時に行う処理を記述。(delegate function)
    // didFinishPまで打てば、予測が出る。
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
