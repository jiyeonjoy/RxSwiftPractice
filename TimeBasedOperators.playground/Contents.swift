import RxSwift
import RxCocoa
import PlaygroundSupport

import Foundation
import UIKit

let disposeBag = DisposeBag()

print("----------replay----------")
let 인사말 = PublishSubject<String>()

let 반복하는앵무새🦜 = 인사말.replay(1) // 버퍼 사이즈에 따라 구독전에 받은 값도 방출 할 수 있음!
반복하는앵무새🦜.connect() // replay 관련 쓰면 connect 무조건 해줘야됨!!
인사말.onNext("1. hello")
인사말.onNext("2. hi")
반복하는앵무새🦜
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
인사말.onNext("3. 안녕하세요")

print("----------replayAll----------")
let 닥터스트레인지 = PublishSubject<String>()
let 닥터스트레인지의타임스톤 = 닥터스트레인지.replayAll() // 구독 시점 어떤값이라도 다 방출 할 수 있다!!
닥터스트레인지의타임스톤.connect() // 역시 connect 해줘야  됨!!

닥터스트레인지.onNext("도르마무")
닥터스트레인지.onNext("거래를 하러왔다")

닥터스트레인지의타임스톤
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------buffer----------")
//let source = PublishSubject<String>()
//
//var count = 0
//let timer = DispatchSource.makeTimerSource()
//timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
//timer.setEventHandler {
//    count += 1
//    source.onNext("\(count)")
//}
//timer.resume() // 타이머 리줌 해줘야됨!!
//
//source
//    .buffer(
//        timeSpan: .seconds(2), // 만들시간 단 10으로 해도 2개 생기면 바로 방출
//        count: 2, // 2개 받으면 무조건 나옴.
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("----------window----------") // buffer 와 같지만 리스트가 아닌 observable 방출!!
//let 만들어낼최대Observable수 = 1 // 5 라고 쓰면 최대 5개 만듬.
//let 만들시간 = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//
//var windowCount = 0
//let windowTimerSource = DispatchSource.makeTimerSource()
//windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimerSource.setEventHandler {
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
//windowTimerSource.resume()
//
//window
//    .window(
//        timeSpan: 만들시간,
//        count: 만들어낼최대Observable수,
//        scheduler: MainScheduler.instance
//    )
//    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
//        return windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print("\($0.index)번째 Observable의 요소 \($0.element)")
//    })
//    .disposed(by: disposeBag)

print("----------delaySubscription----------")
// 구독만을 뒤로 미룸. 이벤트는 제시간에 등록 9, 10, ...
//let delaySource = PublishSubject<String>()
//
//var delayCount = 0
//let delayTimerSource = DispatchSource.makeTimerSource()
//delayTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//delayTimerSource.setEventHandler {
//    delayCount += 1
//    delaySource.onNext("\(delayCount)")
//}
//delayTimerSource.resume()
//
//delaySource
//    .delaySubscription(.seconds(10), scheduler: MainScheduler.instance) // 5초 뒤에 구독하겠다!!! 4, 5, 6, ....
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("----------delay----------")
// 이벤트 자체를 뒤로 미룸 1, 2, ...
//let delaySubject = PublishSubject<Int>()
//
//var delaySubjectCount = 0
//let delaySubjectTimerSource = DispatchSource.makeTimerSource()
//delaySubjectTimerSource.schedule(deadline: .now()+2, repeating: .seconds(1))
//delaySubjectTimerSource.setEventHandler {
//    delaySubjectCount += 1
//    delaySubject.onNext(delaySubjectCount)
//}
//delaySubjectTimerSource.resume()
//
//delaySubject
//    .delay(.seconds(10), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("----------interval----------")
//Observable<Int>
//    .interval(.seconds(3), scheduler: MainScheduler.instance) // 3초마다 방출.. 간격 3초!!
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("----------timer----------")
//Observable<Int>
//    .timer(
//        .seconds(5),    // 구독 시작 딜레이
//        period: .seconds(2),    // 간격
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("----------timeout----------")
//let 누르지않으면에러 = UIButton(type: .system)
//누르지않으면에러.setTitle("눌러주세요!", for: .normal)
//누르지않으면에러.sizeToFit()
//
//PlaygroundPage.current.liveView = 누르지않으면에러
//
//누르지않으면에러.rx.tap
//    .do(onNext: {
//        print("tap")
//    })
//    .timeout(.seconds(5), scheduler: MainScheduler.instance) // 5초 지나면 에러 발생!!
//    .subscribe {
//        print($0)
//    }
//    .disposed(by: disposeBag)
