// Абстракция данных пользователя
protocol UserData {
    var userName: String { get }    //Имя пользователя
    var userCardId: String { get }   //Номер карты
    var userCardPin: Int { get }       //Пин-код
    var userPhone: String { get }       //Номер телефона
    var userCash: Float { get set }   //Наличные пользователя
    var userBankDeposit: Float { get set }   //Банковский депозит
    var userPhoneBalance: Float { get set }    //Баланс телефона
    var userCardBalance: Float { get set }    //Баланс карты
}

// Действия, которые пользователь может выбирать в банкомате (имитация кнопок)
enum UserActions {
    case requestCardBalance
    case requestBankDepositAccountBalance 
}

// Виды операций, выбранных пользователем (подтверждение выбора)
enum DescriptionTypesAvailableOperations: String {
    case welcomeMessage = "Welcome"
}

// Способ оплаты/пополнения наличными, картой или через депозит
enum PaymentMethod {
    case card
    case bankDepositAccount
}

// Тексты ошибок
enum TextErrors: String {
    case notEnoughMoney = "Not Enough Money"
    case userNotExists = "User Not Exists"
    case pinCodeIncorrect = "Pin code incorrect"
    case somethingWentWrong = "Something Went Wrong"
    case unknownUserAction =  "Sorry, Unknown User Action"
}

// Протокол по работе с банком предоставляет доступ к данным пользователя зарегистрированного в банке
protocol BankApi {
    func showUserCardBalance()
    func showUserDepositBalance()
    func showUserToppedUpMobilePhoneCash(cash: Float)
    func showUserToppedUpMobilePhoneCard(card: Float)
    func showWithdrawalCard(cash: Float)
    func showWithdrawalDeposit(cash: Float)
    func showTopUpCard(cash: Float)
    func showTopUpDeposit(cash: Float)
    func showError(error: TextErrors)
    
    func checkUserPhone(phone: String) -> Bool
    func checkMaxUserCash(cash: Float) -> Bool
    func checkMaxUserCard(withdraw: Float) -> Bool
    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool
    
    mutating func topUpPhoneBalanceCash(pay: Float)
    mutating func topUpPhoneBalanceCard(pay: Float)
    mutating func getCashFromDeposit(cash: Float)
    mutating func getCashFromCard(cash: Float)
    mutating func putCashDeposit(topUp: Float)
    mutating func putCashCard(topUp: Float)
}

class Bank : BankApi {
    
    // Acts like a database
    let availableUsers:[String:Int] = ["User1":123, "User2":432]
    let usersCardBalance:[String:Int] = ["User1":1000000, "User2":200]
    
    var activeUserCardId: String? = nil
    
    func showUserCardBalance() {
        let cardBalance = usersCardBalance[activeUserCardId ?? ""]
        print("Card balance: \(cardBalance)")
    }

    func showUserDepositBalance() {
        <#code#>
    }

    func showUserToppedUpMobilePhoneCash(cash: Float) {
        <#code#>
    }

    func showUserToppedUpMobilePhoneCard(card: Float) {
        <#code#>
    }

    func showWithdrawalCard(cash: Float) {
        <#code#>
    }

    func showWithdrawalDeposit(cash: Float) {
        <#code#>
    }

    func showTopUpCard(cash: Float) {
        <#code#>
    }

    func showTopUpDeposit(cash: Float) {
        <#code#>
    }

    func showError(error: TextErrors) {
        <#code#>
    }

    func checkUserPhone(phone: String) -> Bool {
        <#code#>
    }

    func checkMaxUserCash(cash: Float) -> Bool {
        <#code#>
    }

    func checkMaxUserCard(withdraw: Float) -> Bool {
        <#code#>
    }

    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool {
        var availablePin = availableUsers[userCardId]
        if (availablePin == nil) {
            print(TextErrors.userNotExists.rawValue)
            return false
        }else if(availablePin != userCardPin){
            print(TextErrors.pinCodeIncorrect.rawValue)
            return false
        }else {
            self.activeUserCardId = userCardId
            return true
        }
    }

    func topUpPhoneBalanceCash(pay: Float) {
        <#code#>
    }

    func topUpPhoneBalanceCard(pay: Float) {
        <#code#>
    }

    func getCashFromDeposit(cash: Float) {
        <#code#>
    }

    func getCashFromCard(cash: Float) {
        <#code#>
    }

    func putCashDeposit(topUp: Float) {
        <#code#>
    }

    func putCashCard(topUp: Float) {
        <#code#>
    }
}


// Банкомат, с которым мы работаем, имеет общедоступный интерфейс sendUserDataToBank
class ATM {
    private let userCardId: String
    private let userCardPin: Int
    private var someBank: BankApi
    private let action: UserActions
    private let paymentMethod: PaymentMethod?
    
    init(userCardId: String, userCardPin: Int, someBank: BankApi, action: UserActions, paymentMethod: PaymentMethod? = nil) {
        self.userCardId = userCardId
        self.userCardPin = userCardPin
        self.someBank = someBank
        self.action = action
        self.paymentMethod = paymentMethod
        
        sendUserDataToBank(userCardId: userCardId, userCardPin: userCardPin, actions: action, payment: paymentMethod)
    }
    
    
    public final func sendUserDataToBank(userCardId: String, userCardPin: Int, actions: UserActions, payment: PaymentMethod?) {
        let userExists = someBank.checkCurrentUser(userCardId: userCardId, userCardPin: userCardPin)
        if (userExists) {
            print(DescriptionTypesAvailableOperations.welcomeMessage.rawValue)
            
            switch actions{
            case .requestCardBalance:
                someBank.showUserCardBalance()
            default:
                print(TextErrors.unknownUserAction.rawValue)
            }
            
            
        }else {
            print(TextErrors.somethingWentWrong.rawValue)
        }
    }
}

var bank = Bank()

var atm = ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.requestCardBalance, paymentMethod: PaymentMethod.card)
