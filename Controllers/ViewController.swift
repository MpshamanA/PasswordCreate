import UIKit

class ViewController: UIViewController {
    
    //桁数
    //titleForRowをStringで返さないといけないためIntではなくStringで初期化
    private let nums:[String] = ["4","5","6","7","8","9","10","11","12","13","14","15"]
    private let lNums:[String] = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    //パスワードの元のデータ
    private let passwordStrLow:String = "abcdefghijklmnopqrstuvwxyz"
    private let passWordStrLarge:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private let passwordNum:String = "0123456789"
    private let passwordSymbol:String = "!#$%&'()*+-./:;<=>?@[]^_`{|}~"
    
    private var alertController: UIAlertController!
    //最初のパスワードの長さ
    var lenPickerData:String = "4"
    //最初の大文字の数
    var largePickerData:String = "0"
    //最初の数字の数
    var numPickerData:String = "0"
    //最初の記号の数
    var symbolPickerData:String = "0"
    
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var largeToggle: UISwitch!
    @IBOutlet weak var numToggle: UISwitch!
    @IBOutlet weak var symbolToggle: UISwitch!
    @IBOutlet weak var largePicker: UIPickerView!
    @IBOutlet weak var numPicker: UIPickerView!
    @IBOutlet weak var lenPicker: UIPickerView!
    @IBOutlet weak var symbolPicker: UIPickerView!
    @IBOutlet weak var passwordCreateButton: UIButton!
    
    @IBAction func teppedPasswordCreate(_ sender: Any) {
        UIPasteboard.general.string = passwordLabel.text
        alert(title:"メッセージ", message:"クリップボードにパスワードを保存しました。")
        print("numPickerData",lenPickerData)
    }
    @IBAction func numSwitch(_ sender: UISwitch) {
        if sender.isOn{
            numPicker.isHidden = false
        }else{
            numPicker.isHidden = true
        }
    }
    
    @IBAction func symbolSwitch(_ sender: UISwitch) {
        if sender.isOn{
            symbolPicker.isHidden = false
        }else{
            symbolPicker.isHidden = true
        }
    }
    
    @IBAction func largeSwitch(_ sender: UISwitch) {
        if sender.isOn{
            largePicker.isHidden = false
        }else{
            largePicker.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        passwordCreateButton.layer.cornerRadius = 20
        largeToggle.isOn = false
        numToggle.isOn = false
        symbolToggle.isOn = false
        
        largePicker.delegate = self
        largePicker.dataSource = self
        
        lenPicker.delegate = self
        lenPicker.dataSource = self
        
        numPicker.delegate = self
        numPicker.dataSource = self
        
        symbolPicker.delegate = self
        symbolPicker.dataSource = self
        
        largePicker.isHidden = true
        numPicker.isHidden = true
        symbolPicker.isHidden = true
        passwordLabel.text = originalPasswordCreate(count: 4, letters: passwordStrLow)
        
        largePicker.tag = 1
        numPicker.tag = 2
        symbolPicker.tag = 3
        lenPicker.tag = 4
    }
    
    func originalPasswordCreate(count: Int,letters:String) -> String {
        //passwordを分割して配列に入れる
        let originalData = Array(letters)
        //配列の要素をString型に変換してシャッフル
        let shuffledOriginalData = originalData.shuffled()
        //シャッフルした要素の先頭から呼び出し元からしてされた文字数分を返す
        //prefixを使用したら肩型がSubstringになる
        return String(shuffledOriginalData.prefix(count))
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
        if pickerView.tag == 1{
            return lNums.count
        } else if pickerView.tag == 4{
            return nums.count
        } else {
            return lNums.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return lNums[row]
        } else if pickerView.tag == 4{
            return nums[row]
        } else {
            return lNums[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1{
            //pickerの値を取得
            largePickerData = self.pickerView(largePicker, titleForRow: largePicker.selectedRow(inComponent: 0), forComponent: 0) ?? ""
            let largePickerDataInt:Int = Int(largePickerData)!
            //大文字のパスワードを作成
            let usePasswordLarge = originalPasswordCreate(count: largePickerDataInt, letters: passWordStrLarge)
            //大文字のパスワードを作成
            let createPasswordLarge = originalPasswordCreate(count: largePickerDataInt , letters: usePasswordLarge)
            //数字のパスワードを作成
            let createPasswordNum = originalPasswordCreate(count: Int(numPickerData)!, letters: passwordNum)
            
            //大文字のスイッチのみONだったら
            if self.largeToggle.isOn && self.numToggle.isOn == false && self.symbolToggle.isOn == false{
                
                //指定してある長さより大文字で指定してる数が同じか少なかったら
                if Int(self.lenPickerData)! >= createPasswordLarge.count{
                    let passwordCount = Int(self.lenPickerData)! - createPasswordLarge.count
                    let originalpasswordLow = originalPasswordCreate(count: passwordCount, letters: self.passwordStrLow)
                    let password = createPasswordLarge + String(originalpasswordLow)
                    self.passwordLabel.text = String(password.shuffled())
                }else{return}
                
                //大文字のスイッチと数字スイッチがONだったら
            }else if self.largeToggle.isOn && self.numToggle.isOn && self.symbolToggle.isOn == false{
                //指定してある長さより大文字で指定してる数が同じか少なかったら
                if Int(self.lenPickerData)! >= createPasswordLarge.count + createPasswordNum.count{
                    let passwordCount = Int(self.lenPickerData)! - createPasswordLarge.count - createPasswordNum.count
                    let originalpasswordLow = originalPasswordCreate(count: passwordCount, letters: self.passwordStrLow)
                    let password = createPasswordLarge + originalpasswordLow + createPasswordNum
                    self.passwordLabel.text = String(password.shuffled())
                }else{return}
                
                //全部のスイッチがONだったら
            }else if self.largeToggle.isOn && self.numToggle.isOn && self.symbolToggle.isOn{
                //記号のパスワードを作成
                let createPasswordSymbol = originalPasswordCreate(count: Int(symbolPickerData)!, letters: passwordSymbol)
                //もし指定してある長さより大文字で指定してる数が同じか少なかったら
                if Int(self.lenPickerData)! >= createPasswordLarge.count + createPasswordNum.count + createPasswordSymbol.count{
                    let passwordCount = Int(self.lenPickerData)! - createPasswordLarge.count - createPasswordNum.count - createPasswordSymbol.count
                    let originalpasswordLow = originalPasswordCreate(count: passwordCount, letters: self.passwordStrLow)
                    let password = createPasswordLarge + originalpasswordLow + createPasswordNum + createPasswordSymbol
                    self.passwordLabel.text = String(password.shuffled())
                }else{return}
            }
            if pickerView.tag == 2{
                
                }
            if pickerView.tag == 3{
                
                }
            
                
                
            }else if pickerView.tag == 4{
                //選択されているPickerのデータを取得 nilの場合は""
                lenPickerData = self.pickerView(lenPicker, titleForRow: lenPicker.selectedRow(inComponent: 0), forComponent: 0) ?? ""
                //numPickerDataをIntに変換
                let lenPickerDataInt:Int = Int(lenPickerData)!
                
                if self.numToggle.isOn && self.symbolToggle.isOn{
                    self.passwordLabel.text = originalPasswordCreate(count: lenPickerDataInt, letters: self.passwordStrLow + self.passwordNum + self.passwordSymbol)
                }else if self.symbolToggle.isOn{
                    self.passwordLabel.text = originalPasswordCreate(count: lenPickerDataInt, letters: self.passwordStrLow + self.passwordSymbol)
                }else if self.numToggle.isOn{
                    self.passwordLabel.text = originalPasswordCreate(count: lenPickerDataInt, letters: self.passwordStrLow + self.passwordNum)
                }else{
                    self.passwordLabel.text = originalPasswordCreate(count: lenPickerDataInt, letters: self.passwordStrLow)
                }
            }
        }
    }
