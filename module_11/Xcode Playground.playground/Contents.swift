
//1. Создайте перечисление для ошибок. Добавьте в него 3 кейса:

//ошибка 400,
//ошибка 404,
//ошибка 500. 
//Далее создайте переменную, которая будет хранить в себе какую-либо ошибку (400 или 404 или 500). И при помощи do-catch сделайте обработку ошибок перечисления. Для каждой ошибки должно быть выведено сообщение в консоль.

enum AutoError: Error {
    case badRequest400 
    case notFound404
    case internalServerError500
}

var badRequest400: Bool = false
var notFound404: Bool = false
var internalServerError500: Bool = true

do{
    if badRequest400 {
        throw AutoError.badRequest400
    }
    if notFound404 {
        throw AutoError.notFound404
    }
    if internalServerError500 {
        throw AutoError.internalServerError500
    }
} catch AutoError.badRequest400 {
    print("Bad Request 400")
} catch AutoError.notFound404 {
    print("Not Found 404")
} catch AutoError.internalServerError500 {
    print("Internal Server Error")
}



//2. Теперь добавьте проверку переменных в генерирующую функцию и обрабатывайте её! 

func autoError() throws {
    if badRequest400 {
        throw AutoError.badRequest400
    }
    if notFound404 {
        throw AutoError.notFound404
    }
    if internalServerError500 {
        throw AutoError.internalServerError500
    }
}

do {
    try autoError()
} catch AutoError.badRequest400 {
    print("Bad Request 400")
} catch AutoError.notFound404 {
    print("Not Found 404")
} catch AutoError.internalServerError500 {
    print("Internal Server Error")
}

//3. Напишите функцию, которая будет принимать на вход два разных типа и проверять: если типы входных значений одинаковые, то вывести сообщение “Yes”, в противном случае — “No”.

func checkTheTypesOfInputValues<T, E>(a: T, b: E) {
    if(type(of: a) == type(of: b)) {
        print("yes")
    }else {
        print("no")
    }
}

checkTheTypesOfInputValues(a: 1, b: 2)

//4. Реализуйте то же самое, но если тип входных значений различается, выбросите исключение. Если тип одинаковый — тоже выбросите исключение, но оно уже будет говорить о том, что типы одинаковые. Не бойтесь этого. Ошибки — это не всегда про плохой результат.

enum ComparisionError: Error {
    case typesAreNotTheSame 
    case typesAreTheSame
}

func checkTheTypesOfInputValuesWithErrors<T, E>(a: T, b: E) throws {
    if(type(of: a) == type(of: b)) { 
        throw ComparisionError.typesAreTheSame
    }else {
        throw ComparisionError.typesAreNotTheSame
    }
}

do {
    try checkTheTypesOfInputValuesWithErrors(a: "ok", b: 2)
} catch ComparisionError.typesAreNotTheSame {
    print("types are not the same")
} catch ComparisionError.typesAreTheSame {
    print("types are the same")
}

//5. Напишите функцию, которая принимает на вход два любых значения и сравнивает их при помощи оператора равенства ==. 

func comparison<T:Equatable>(a: T, b: T){
    if a==b {
        print("the same")
    }else {
        print("not the same")
    }
}
comparison(a:"5", b:"5")
