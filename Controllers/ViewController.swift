import UIKit

class ViewController: UIViewController {

    private let nums:[String] = ["4","5","6","7","8","9","10","11","12","13","14","15"]
    private let passwordLetters1:NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private let passwordLetters2:NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    private let passwordLetters3:NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&'()*+-./:;<=>?@[]^_`{|}~"
    //後に二重引用符も入れる
    private let passwordLetters4:NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&'()*+-./:;<=>?@[]^_`{|}~"
    
    private var alertController: UIAlertController!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var numToggle: UISwitch!
    @IBOutlet weak var symbolToggle: UISwitch!
    @IBOutlet weak var numPicker: UIPickerView!
    @IBOutlet weak var passwordCreateButton: UIButton!
    
    @IBAction func teppedPasswordCreate(_ sender: Any) {
        UIPasteboard.general.string = passwordLabel.text
        alert(title:"メッセージ", message:"クリップボードにパスワードを保存しました。")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        passwordCreateButton.layer.cornerRadius = 20
        numToggle.isOn = false
        symbolToggle.isOn = false
        numPicker.delegate = self
        numPicker.dataSource = self
        passwordLabel.text = "pass"
        
    }
    func passwordCreate(length: Int,letters:NSString) -> String {
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func alert(title:String, message:String) {
            alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
            present(alertController, animated: true)
        }
}


extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nums[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //選択されているPickerのデータを取得
        let numPickerData = self.pickerView(numPicker, titleForRow: numPicker.selectedRow(inComponent: 0), forComponent: 0)
        if let numPickerData = numPickerData{
                    let numPickerDataInt:Int = Int(numPickerData)!
            if self.numToggle.isOn && self.symbolToggle.isOn{
                self.passwordLabel.text = passwordCreate(length: numPickerDataInt, letters: self.passwordLetters4)
            }else if self.symbolToggle.isOn{
                self.passwordLabel.text = passwordCreate(length: numPickerDataInt, letters: self.passwordLetters3)
            }else if self.numToggle.isOn{
                self.passwordLabel.text = passwordCreate(length: numPickerDataInt, letters: self.passwordLetters2)
            }else{
                self.passwordLabel.text = passwordCreate(length: numPickerDataInt, letters: self.passwordLetters1)
            }
        }

    }
}
