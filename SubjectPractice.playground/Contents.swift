import RxSwift

// subscribe(구독) 이후 onNext 한 것만 받을 수 있음.
print("-------publishSubject-------")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("여러분 안녕하세요?")

let 구독자1 = publishSubject
    .subscribe(onNext: {
        print($0)
    })

publishSubject.on(.next("1"))
publishSubject.onNext("2")

let 구독자2 = publishSubject
    .subscribe {
        print("두번째 구독:", $0.element ?? $0)
    }

publishSubject.onNext("3")

구독자1.dispose()

publishSubject.onNext("4")
publishSubject.onCompleted()

publishSubject.onNext("5")

구독자2.dispose()

let disposeBag = DisposeBag()

publishSubject
    .subscribe {
        print("세번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

publishSubject.onNext("찍힐까요?")

// subscribe(구독) 이후 onNext 한 것만과 그 전에 값을 가져올 수 있음. 단 에러면 못가져옴.
print("-------behaviorSubject-------")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "초기값")

behaviorSubject.onNext("첫번째값")

behaviorSubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

let value = try? behaviorSubject.value()
print(value ?? "")

// bufferSize 설정해 놓은 만큼 구독 전의 값을 가지고 올 수 있음.
print("-------ReplaySubject-------")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("a")
replaySubject.onNext("b")
replaySubject.onNext("c")

replaySubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("d")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)
