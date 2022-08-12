//
//  CameraViewController.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON
import YPImagePicker
/*
 권한이 항상 중요하다 UIImagePickerVc-> ios14 PHPPickerVc(카마라 기능은 없다)
 => 완전 커스텁은 AVFoundation
 카메라 갤러리 -> 가지고 오기, 저장 마이크
 카메라를 촬영하고 싶다하면 camera usage, 마이크 권한도 허용
 갤러리 권한 -> 가지고만 오고 싶다면 권한이 필요 없음
          -> 갤러리에 사진 저장하고 싶다면 권한 필요
          -> 사용자가 사진을 가지고 오고 명확하게 갤러리를 여는게 명확
          -> 사진 가지고 오는건 권한이 필요 없기 때문에 몇개만 허용해도 다 가져올 수 있음
          -> 가지고 오는 것만이면 권한 필요 없는거 아님? 정해진 범위 벗어나면 addition use description 사용
 
 1. 오픈웨더 구현(위치 base)
 2. clova API -> 코드 구조 개선
 3. UIButton(iOS15+)
 4. image Phpicker(옵션)
 => 1 ~ 6
 */

class CameraViewController: UIViewController {

    @IBOutlet weak var resultImage: UIImageView!
    
    //UIImagePickerController1.
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIImagePickerController2.
        picker.delegate = self

       
    }
    
    //OpenSource
    //권한은 다 허용하자
    //실제 디바이스 빌드 , 시뮬레이터(카메라X)
    //권한 문구 등도 내부적으로 구현! 실제로 카메라를 쓸 때 권한을 요청
    @IBAction func ypimagePickerButtonClicked(_ sender: UIButton) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered 항상 편집 Or 원본 이미지
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImage.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    //UImagePickerController
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        //카메라 기능 있는지 확인하는 코드
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트/얼럿")
            return
        }
        
        //띄워주는 코드
        picker.sourceType = .camera
        //촬영하고 나서 바로 edit 편집화면 띄우는 코드
        picker.allowsEditing = false //편집화면
        
        present(picker, animated: true)
        
        
    }
    
    //UImagePickerController
    @IBAction func photoLibraryButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용불가 + 사용자에게 토스트/얼럿")
            return
        }
        
        //띄워주는 코드
        picker.sourceType = .photoLibrary
        //촬영하고 나서 바로 edit 편집화면 띄우는 코드
        picker.allowsEditing = false
        
        present(picker, animated: true)
        
        
    }
    
    //갤러리에 사진 저장
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        
        if let image = resultImage.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
    }
    
    //이미지뷰 이미지 > 네이버 > 얼굴 분석 해줘 요청 > 응답!
    //문자열이 아닌 파일 이미지 Pdf 파일 자체가 그대로 전송 되지 않음 => 텍스트 형태로 인코딩
    //어떤 파일의 종류가 서버에게 전달이 되는지 명시 = Cotent-Type
    @IBAction func clovaFaceButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "\(APIKey.naverId)",
            "X-Naver-Client-Secret" : "\(APIKey.naverPw)",
            //"Content-Type": "multipart/form-data" 왜 안해도 될까요? 라이브러리에 내장되어 있다 almofire에 내장되어 있다
        ]
        
        //UIImage를 택스트 형태(바이너리 타입)로 변환해서 전달
        //jpgData도 있음 압축해서 보내야함 용량 줄여서 보내는거임
        guard let imageData = resultImage.image?.pngData() else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image") //
        }, to: url, headers: header)
        .validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                
                
                
            case .failure(let error):
                print(error)
                
                
            }
        }
        
    }
}

//UIImagePickerController3.
//네비게이션 컨트롤러 상속받고 있어서 채택함
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UIImagePickerController4. 사진을 선택하거나 카메라 촬영 직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //원본, 편집, 메타 데이터 등 - infoKey
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.resultImage.image = image
            //사진찍고 사라짐
            dismiss(animated: true)
        }
        
    }
    
    //UIImagePickerController5. 취소버튼 클릭 시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
    
}
