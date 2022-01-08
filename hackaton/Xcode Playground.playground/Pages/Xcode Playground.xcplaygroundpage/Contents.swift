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
    case requestBalance 
    case withdrawCash
    case depositCash
    case topUpPhoneBalance
}

// Виды операций, выбранных пользователем (подтверждение выбора)
enum DescriptionTypesAvailableOperations: String {
    case welcomeMessage = "Welcome"
}

// Способ оплаты/пополнения наличными, картой или через депозит
enum PaymentMethod {
    case cash
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
    case noPhoneNumber = "No Phone Number"
}

// Протокол по работе с банком предоставляет доступ к данным пользователя зарегистрированного в банке
protocol BankApi {
    func showUserCardBalance()
    func showUserCashBalance()
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
    let usersPhoneNumbers:[String:String] = ["User1":"+19167445632", "User2":"+16509871256"]
    var usersPhoneBalance:[String:Float] = ["User1":300, "User2":10]
    var usersCashBalance:[String:Float] = ["User1":1000, "User2":20]
    var usersCardBalance:[String:Float] = ["User1":1000000, "User2":200]
    var usersBankDepositAccountBalance:[String:Float] = ["User1":2000000, "User2":300]
    
    var activeUserCardId: String? = nil
    
    func showUserCardBalance() {
        let balance = usersCardBalance[activeUserCardId ?? ""]
        print("Card balance: \(balance)")
    }
    
    func showUserCashBalance() {
        let balance = usersCashBalance[activeUserCardId ?? ""]
        print("Cash balance: \(balance)")
    }
    
    func showUserDepositBalance() {
        let balance = usersBankDepositAccountBalance[activeUserCardId ?? ""]
        print("Bank Deposit Account balance: \(balance)")
    }
    
    func showUserToppedUpMobilePhoneCash(cash: Float) {
        print("\(cash) Mobile Phone Card TopUp using Cash")
    }
    
    func showUserToppedUpMobilePhoneCard(card: Float) {
        print("\(card) Mobile Phone Card TopUp using Card")
    }
    
    func showWithdrawalCard(cash: Float) {
        print("\(cash) Card Withdrawal")
    }
    
    func showWithdrawalDeposit(cash: Float) {
        print("\(cash) Bank Account Withdrawal")
    }
    
    func showTopUpCard(cash: Float) {
        print("\(cash) Card Deposit")
    }
    
    func showTopUpDeposit(cash: Float) {
        print("\(cash) Bank Account Deposit")
    }
    
    func showError(error: TextErrors) {
        print(error.rawValue)
    }
    
    func checkUserPhone(phone: String) -> Bool {
        let phoneNumber = usersPhoneNumbers[activeUserCardId ?? ""]
        if (phoneNumber != nil) {
            return true
        }else {
            showError(error: .noPhoneNumber)
            return false
        }
    }
    
    func checkMaxUserCash(cash: Float) -> Bool {
        var balance = usersCashBalance[activeUserCardId ?? ""]
        if (balance ?? 0 >= cash) {
            return true
        }else {
            return false
        }
    }
    
    func checkMaxUserCard(withdraw: Float) -> Bool {
        var balance = usersCardBalance[activeUserCardId ?? ""]
        if (balance ?? 0 >= withdraw) {
            return true
        }else {
            return false
        }
    }
    
    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool {
        var availablePin = availableUsers[userCardId]
        if (availablePin == nil) {
            showError(error: TextErrors.userNotExists)
            return false
        }else if(availablePin != userCardPin){
            showError(error: TextErrors.pinCodeIncorrect)
            return false
        }else {
            self.activeUserCardId = userCardId
            return true
        }
    }
    
    func topUpPhoneBalanceCash(pay: Float) {
        if (checkMaxUserCash(cash: pay)) {
            showUserCashBalance()
            let currentBalanse = usersCashBalance[activeUserCardId ?? ""] as! Float
            usersCashBalance[activeUserCardId ?? ""] = currentBalanse - pay
            
            let currentPhoneBalanse = usersPhoneBalance[activeUserCardId ?? ""] as! Float
            usersPhoneBalance[activeUserCardId ?? ""] = currentPhoneBalanse + pay
            
            showUserToppedUpMobilePhoneCash(cash: pay)
            showUserCashBalance()
        } else {
            showError(error: .notEnoughMoney)
        }
    }
    
    func topUpPhoneBalanceCard(pay: Float) {
        if (checkMaxUserCard(withdraw: pay)) {
            showUserCardBalance()
            let currentBalanse = usersCardBalance[activeUserCardId ?? ""] as! Float
            usersCardBalance[activeUserCardId ?? ""] = currentBalanse - pay
            
            let currentPhoneBalanse = usersPhoneBalance[activeUserCardId ?? ""] as! Float
            usersPhoneBalance[activeUserCardId ?? ""] = currentPhoneBalanse + pay
            
            showUserToppedUpMobilePhoneCard(card: pay)
            showUserCardBalance()
        } else {
            showError(error: .notEnoughMoney)
        }
    }
    
    func getCashFromDeposit(cash: Float) {
        if (checkMaxUserCard(withdraw: cash)) {
            showUserDepositBalance()
            let currentBalanse = usersBankDepositAccountBalance[activeUserCardId ?? ""] as! Float
            usersBankDepositAccountBalance[activeUserCardId ?? ""] = currentBalanse - cash
            showWithdrawalDeposit(cash: cash)
            showUserDepositBalance()
        }else {
            showError(error: .notEnoughMoney)
        }
    }
    
    func getCashFromCard(cash: Float) {
        if (checkMaxUserCard(withdraw: cash)) {
            showUserCardBalance()
            let currentBalanse = usersCardBalance[activeUserCardId ?? ""] as! Float
            usersCardBalance[activeUserCardId ?? ""] = currentBalanse - cash
            showWithdrawalCard(cash: cash)
            showUserCardBalance()
        }else {
            showError(error: .notEnoughMoney)
        }
    }
    
    func putCashDeposit(topUp: Float) {        
        showUserDepositBalance()
        let currentBalanse = usersBankDepositAccountBalance[activeUserCardId ?? ""] as! Float
        usersBankDepositAccountBalance[activeUserCardId ?? ""] = currentBalanse + topUp
        showUserDepositBalance()
    }
    
    func putCashCard(topUp: Float) {
        showUserCardBalance()
        let currentBalanse = usersCardBalance[activeUserCardId ?? ""] as! Float
        usersCardBalance[activeUserCardId ?? ""] = currentBalanse + topUp
        showUserCardBalance()
    }
}


// Банкомат, с которым мы работаем, имеет общедоступный интерфейс sendUserDataToBank
class ATM {
    private let userCardId: String
    private let userCardPin: Int
    private var someBank: BankApi
    private let action: UserActions
    private let paymentMethod: PaymentMethod?
    private let amount: Float
    private let phone: String?
    
    init(userCardId: String, userCardPin: Int, someBank: BankApi, action: UserActions, paymentMethod: PaymentMethod? = nil, amount: Float = 0, phone: String? = nil) {
        self.userCardId = userCardId
        self.userCardPin = userCardPin
        self.someBank = someBank
        self.action = action
        self.paymentMethod = paymentMethod
        self.amount = amount
        self.phone = phone
        
        sendUserDataToBank(userCardId: userCardId, userCardPin: userCardPin,action: action, paymentMethod: paymentMethod, amount: amount)
    }
    
    public final func sendUserDataToBank(userCardId: String, userCardPin: Int, action: UserActions, paymentMethod: PaymentMethod? = nil, amount: Float = 0) {
        let userExists = someBank.checkCurrentUser(userCardId: userCardId, userCardPin: userCardPin)
        if (userExists) {
            print("User Action: \(self.action)")
            
            switch (self.action, self.paymentMethod){
            case (.requestBalance, .card):
                someBank.showUserCardBalance()
                break 
            case (.requestBalance, .bankDepositAccount):
                someBank.showUserDepositBalance()
                break 
            case (.withdrawCash, .card): 
                print("Amount: \(amount)")
                if (someBank.checkMaxUserCash(cash: amount)) {
                    someBank.getCashFromCard(cash: amount)
                }else {
                    someBank.showError(error: .notEnoughMoney)
                }
                break
            case (.withdrawCash, .bankDepositAccount): 
                print("Amount: \(amount)")
                if (someBank.checkMaxUserCard(withdraw: amount)) {
                    someBank.getCashFromDeposit(cash: amount)
                }else {
                    someBank.showError(error: .notEnoughMoney)
                }
                break
            case (.depositCash, .card): 
                print("Amount: \(amount)")
                someBank.putCashCard(topUp: amount)
                break
            case (.depositCash, .bankDepositAccount):
                print("Amount: \(amount)")
                someBank.putCashDeposit(topUp: amount)
                break
            case (.topUpPhoneBalance, .card): 
                print("Amount: \(amount)")
                someBank.topUpPhoneBalanceCard(pay: amount)
                break
            case (.topUpPhoneBalance, .cash): 
                print("Amount: \(amount)")
                someBank.topUpPhoneBalanceCash(pay: amount)
                break
            default:
                print(TextErrors.unknownUserAction.rawValue)
            }
        }else {
            print(TextErrors.somethingWentWrong.rawValue)
        }
        print("------- Session finished -----------")
    }
}

var bank = Bank()

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.requestBalance, paymentMethod: PaymentMethod.card)

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.requestBalance, paymentMethod: PaymentMethod.bankDepositAccount)

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.withdrawCash, paymentMethod: PaymentMethod.card, amount: 100)

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.withdrawCash, paymentMethod: PaymentMethod.bankDepositAccount, amount: 300)

ATM(userCardId: "User2", userCardPin: 123, someBank: bank, action: UserActions.withdrawCash, paymentMethod: PaymentMethod.bankDepositAccount, amount: 3000)

ATM(userCardId: "User2", userCardPin: 432, someBank: bank, action: UserActions.withdrawCash, paymentMethod: PaymentMethod.bankDepositAccount, amount: 3000)

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.depositCash, paymentMethod: PaymentMethod.card, amount: 200)

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.depositCash, paymentMethod: PaymentMethod.bankDepositAccount, amount: 200)

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.topUpPhoneBalance, paymentMethod: PaymentMethod.card, amount: 20, phone: "+1963328543")

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.topUpPhoneBalance, paymentMethod: PaymentMethod.bankDepositAccount, amount: 100, phone: "+19167445632")

ATM(userCardId: "User3", userCardPin: 123, someBank: bank, action: UserActions.topUpPhoneBalance, paymentMethod: PaymentMethod.bankDepositAccount, amount: 100, phone: "+19167445632")

ATM(userCardId: "User1", userCardPin: 123, someBank: bank, action: UserActions.topUpPhoneBalance, paymentMethod: PaymentMethod.cash, amount: 100, phone: "+19167445632")



