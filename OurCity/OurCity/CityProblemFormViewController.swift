//
//  CityProblemFormViewController.swift
//  OurCity
//
//  Created by user195143 on 12/18/21.
//

import UIKit

class CityProblemFormViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldLocalization: UITextField!
    @IBOutlet weak var datePickerData: UIDatePicker!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var textViewProblemDescription: UITextView!
    @IBOutlet weak var buttonAddEdit: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var problem:Problem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.keyboardDismissMode = .interactive
        
        if let problem = problem {
            title = "Edição"
            textFieldName.text = problem.name
            textFieldLocalization.text = problem.localization
            //datePickerData.date = problem.date!
            textViewProblemDescription.text = problem.problemDescription

            if let photo = problem.photo {
                imageViewPhoto.image = UIImage(data: photo)
            }
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            datePickerData.date = dateFormat.date(from: problem.date!)!

            buttonAddEdit.setTitle("Alterar", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
 
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        scrollView.contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        
    }

    @objc func keyboardWillHide(){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    
    @IBAction func selectPhoto(_ sender: UIButton) {
        // Criar alerta para saber de onde pegar a foto
        let alert = UIAlertController(title: "Selecionar foto do problema", message: "De onde deseja selecionar a foto do problema?", preferredStyle: .actionSheet)
        
        // Action para cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        // Action para abrir camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { _ in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { _ in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)

        let albumAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { _ in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(albumAction)

        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if problem == nil {
            problem = Problem(context: context)
        }
        
        problem?.name = textFieldName.text
        problem?.localization = textFieldLocalization.text
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        problem?.date = dateFormat.string(from: datePickerData.date)
        problem?.problemDescription = textViewProblemDescription.text
        problem?.photo = imageViewPhoto.image?.jpegData(compressionQuality: 0.9)
        
        try? context.save()
        
        navigationController?.popViewController(animated: true)
    }
}

extension CityProblemFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageViewPhoto.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
