import RxSwift

let disposeBag = DisposeBag()

print("----------startWith----------")
let 노랑반 = Observable.of("👧🏼", "🧒🏻", "👦🏽")
    
노랑반
//    .enumerated()
//    .map {
//        $0.element + "어린이" + "\($0.index)"
//    }
    .startWith("👨🏻선생님")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------concat1----------")
let 노랑반어린이들 = Observable.of("👧🏼", "🧒🏻", "👦🏽")
let 선생님 = Observable.of("👨🏻선생님")

let 줄서서걷기: () = Observable
    .concat([선생님, 노랑반어린이들])
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------concat2----------")
선생님
    .concat(노랑반어린이들)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------concatMap----------")
let 어린이집 = [
    "노랑반": Observable.of("👧🏼", "🧒🏻", "👦🏽"),
    "파랑반": Observable.of("👶🏾", "👶🏻")
]

Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------merge1----------")
let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(강북, 강남)
    .merge() // 순서는 랜덤임!!!
    .subscribe(onNext: {
        print("서울특별시의 구:", $0)
    })
    .disposed(by: disposeBag)

print("----------merge2----------")
Observable.of(강남, 강북)
    .merge(maxConcurrent: 1) // 한개 구독 중이면 끝나고 다음 거 받음.
    .subscribe(onNext: {
        print("서울특별시의 구:", $0)
    })
    .disposed(by: disposeBag)

print("----------combineLatest1----------")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable.combineLatest(성, 이름) { 성, 이름 in
    성 + 이름
} // 성, 이름 받을 때마다 다른 값의 최종값과 더해져서 내보내진다!!

성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("김")
이름.onNext("똘똘")
이름.onNext("영수")
이름.onNext("은영")
성.onNext("박")
성.onNext("이")
성.onNext("조")

print("----------combineLatest2----------")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜,
        resultSelector: { 형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        }
    )

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------combineLatest3----------")
let lastName = PublishSubject<String>()     //성
let firstName = PublishSubject<String>()    //이름

let fullName = Observable.combineLatest([firstName, lastName]) { name in
    name.joined(separator: " ")
}

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Stella")
firstName.onNext("Lily")

print("----------zip----------")
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("🇰🇷", "🇨🇭", "🇺🇸", "🇧🇷", "🇯🇵", "🇨🇳")

// zip 은 대응되는 갯수만큼 보임. 승부의 아이템 갯수가 5개라서 선수 아이템도 5개만 보여짐!
let 시합결과 = Observable.zip(승부, 선수) { 결과, 대표선수 in
    return 대표선수 + "선수" + " \(결과)!"
}

시합결과
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------withLatestFrom1----------")
let 💥🔫 = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

💥🔫.withLatestFrom(달리기선수) // 달리기선수 의 가장 마지막 데이터가 방출됨!!
//    .distinctUntilChanged()     //Sample과 똑같이 쓰고 싶을 때(여러번 호출해도 한 번만 방출!!!)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

달리기선수.onNext("🏃🏻‍♀️")
달리기선수.onNext("🏃🏻‍♀️ 🏃🏽‍♂️")
달리기선수.onNext("🏃🏻‍♀️ 🏃🏽‍♂️ 🏃🏿")
💥🔫.onNext(Void()) // 🏃🏻‍♀️ 🏃🏽‍♂️ 🏃🏿
💥🔫.onNext(Void()) // 🏃🏻‍♀️ 🏃🏽‍♂️ 🏃🏿

print("----------sample----------")
let 🏁출발 = PublishSubject<Void>()
let F1선수 = PublishSubject<String>()

F1선수.sample(🏁출발) // 🏁출발 의 가장 마지막 데이터가 방출됨. 단 한번만 방출됨!!!
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

F1선수.onNext("🏎")
F1선수.onNext("🏎   🚗")
F1선수.onNext("🏎      🚗   🚙")
🏁출발.onNext(Void())
🏁출발.onNext(Void())
🏁출발.onNext(Void())

print("----------amb----------")
let 🚌버스1 = PublishSubject<String>()
let 🚌버스2 = PublishSubject<String>()

let 🚏버스정류장 = 🚌버스1.amb(🚌버스2) // 버스1, 버스2 모두 구독하지만 먼저 방출하는 observable 만 구독하게 됨!

🚏버스정류장.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

🚌버스2.onNext("버스2-승객0: 👩🏾‍💼")
🚌버스1.onNext("버스1-승객0: 🧑🏼‍💼")
🚌버스1.onNext("버스1-승객1: 👨🏻‍💼")
🚌버스2.onNext("버스2-승객1: 👩🏻‍💼")
🚌버스1.onNext("버스1-승객1: 🧑🏻‍💼")
🚌버스2.onNext("버스2-승객2: 👩🏼‍💼")

print("----------switchLatest----------")
let 👩🏻‍💻학생1 = PublishSubject<String>()
let 🧑🏽‍💻학생2 = PublishSubject<String>()
let 👨🏼‍💻학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest() // 손들기 에서 최신 구독한 학생 것만 구독하는 것임!!!
손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(👩🏻‍💻학생1)
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 저는 1번 학생입니다.")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 저요 저요!!!")

손들기.onNext(🧑🏽‍💻학생2)
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 저는 2번이예요!")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아.. 나 아직 할말 있는데")

손들기.onNext(👨🏼‍💻학생3)
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 아니 잠깐만! 내가! ")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 언제 말할 수 있죠")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 저는 3번 입니다~ 아무래도 제가 이긴 것 같네요.")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 저는 3번 입니다~ 아무래도 제가 이긴 것 같네요.")

손들기.onNext(👩🏻‍💻학생1)
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아니, 틀렸어. 승자는 나야.")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: ㅠㅠ")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 이긴 줄 알았는데")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 이거 이기고 지는 손들기였나요?")

print("----------reduce----------")
Observable.from((1...10))
    .reduce(0, accumulator: { summary, newValue in // 계산하는 것임. 결과값만 방출
        return summary + newValue
    })
//    .reduce(0, accumulator: +) // 간단한 방식
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------scan----------")
Observable.from((1...10))
    .scan(0, accumulator: +) // 더해지는 과정을 다 보여줌.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
