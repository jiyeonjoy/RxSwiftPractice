import Foundation
import RxSwift

let disposeBag = DisposeBag()
print("--------toArray--------")
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------map--------")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------flatMap--------")
protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }  // 초기값도 구독!
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 🇰🇷국가대표 = 양궁선수(점수: BehaviorSubject(value: 10))
let 🇺🇸국가대표 = 양궁선수(점수: BehaviorSubject(value: 8))

let 올림픽경기 = PublishSubject<선수>()

올림픽경기
    .flatMap {
        $0.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

올림픽경기.onNext(🇰🇷국가대표)
🇰🇷국가대표.점수.onNext(10)

올림픽경기.onNext(🇺🇸국가대표)
🇰🇷국가대표.점수.onNext(10)
🇺🇸국가대표.점수.onNext(9)

print("--------flatMapLatest--------")
struct 높이뛰기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 서울 = 높이뛰기선수(점수: BehaviorSubject(value: 7))
let 제주 = 높이뛰기선수(점수: BehaviorSubject(value: 6))

let 전국체전 = PublishSubject<선수>()

전국체전
    .flatMapLatest { // 초기값과 한번 업데이트 되면 그 값만 보여주고 그다음 업데이트해도 보여주지 않는다.
        $0.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

전국체전.onNext(서울)
서울.점수.onNext(9)

전국체전.onNext(제주)
서울.점수.onNext(10)
제주.점수.onNext(8)

print("--------materialize and dematerialize--------")
enum 반칙: Error {
    case 부정출발
}

struct 달리기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 김토끼 = 달리기선수(점수: BehaviorSubject(value: 0))
let 박치타 = 달리기선수(점수: BehaviorSubject(value: 1))

let 달리기100M = BehaviorSubject<선수>(value: 김토끼)


// 0, 1, Unhandled error happened: 부정출발

//달리기100M
//    .flatMapLatest {
//        $0.점수
//    }
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
//
//김토끼.점수.onNext(1)
//김토끼.점수.onError(반칙.부정출발)
//김토끼.점수.onNext(2)
//
//달리기100M.onNext(박치타)

print("-------------------------------------------")

// 1) materialize 추가

// next(0)
// next(1)
// error(부정출발)
// next(1)

//달리기100M
//    .flatMapLatest {
//        $0.점수
//            .materialize()
//    }
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
//
//김토끼.점수.onNext(1)
//김토끼.점수.onError(반칙.부정출발)
//김토끼.점수.onNext(2)
//
//달리기100M.onNext(박치타)

print("-------------------------------------------")

// 2) demeterialize 추가

// 0
// 1
// 부정출발
// 1

달리기100M
    .flatMapLatest {
        $0.점수
            .materialize() // dematerialize 이거 할때 이거 안 써주면 에러남.
    }
    .filter {
        guard let error = $0.error else {
            return true // 에러가 아니면 통과
        }
        print(error) // 에러면 에러 메시지 출력 후 제외
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

김토끼.점수.onNext(1)
김토끼.점수.onError(반칙.부정출발)
김토끼.점수.onNext(2)

달리기100M.onNext(박치타)

print("--------전화번호 11자리--------")
let input = PublishSubject<Int?>()

let list: [Int] = [1]
input
    .flatMap {
        $0 == nil ? Observable.empty() : Observable.just($0) // nil 입력 시 제거
    }
    .map { $0! }
    .skip(while: { $0 != 0 }) // 처음에는 0이 들어와야 돼서 처음에 0 이들어올때 까지 스킵
    .take(11) // 11개만 받음
    .toArray() // 어레이로 만듬
    .asObservable() // 다시 옵저블로 만듬
    .map {
        $0.map { "\($0)" } // 스트링으로 바꿈
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3) // 010-
        numberList.insert("-", at: 8) // 010-1234-
        let number = numberList.reduce(" ", +) // 다 더함
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(4)
input.onNext(4)
input.onNext(4)
input.onNext(4)
input.onNext(4)
