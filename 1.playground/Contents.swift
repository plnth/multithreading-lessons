 import UIKit
 import PlaygroundSupport
 //UNIX
 
// var thread = pthread_t(bitPattern: 0)
// var attribute = pthread_attr_t()
//
// pthread_attr_init(&attribute)
// pthread_create(&thread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
//    print("test1")
//    return nil
// }, nil)
//
// var nsthread = Thread {
//    print("test")
// }
//
// nsthread.start()
// Thread.setThreadPriority(2)
// nsthread.cancel()
 
// var pthread = pthread_t(bitPattern: 0)
// var attrib = pthread_attr_t()
// pthread_attr_init(&attrib)
// pthread_attr_set_qos_class_np(&attrib, QOS_CLASS_USER_INITIATED, 0)
// pthread_create(&pthread, &attrib, { (pointer) -> UnsafeMutableRawPointer? in
//    print("test")
//    pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0)
//    return nil
// }, nil)
//
// let nsthread = Thread {
//    print("test")
//    print(qos_class_self())
// }
// nsthread.qualityOfService = .userInteractive
// nsthread.start()
//
// print(qos_class_main())
 
// class SafeThread  {
//    private var mutex = pthread_mutex_t()
//
//    init() {
//        pthread_mutex_init(&mutex, nil)
//    }
//
//    func someMethod(completion: () -> ()) {
//        pthread_mutex_lock(&mutex)
//        completion()
//        defer {
//            pthread_mutex_unlock(&mutex)
//        }
//    }
// }
 
// class SafeThread  {
//    private let lockMutex = NSLock()
//
//    func someMethod(completion: () -> ()) {
//        lockMutex.lock()
//        completion()
//        defer {
//            lockMutex.unlock()
//        }
//    }
// }
//
// var array = [String]()
// let safeThread = SafeThread()
//
// safeThread.someMethod {
//    print("TEST")
//    array.append("1 thread")
// }
//
// array.append("2 thread")
//
// print(array)

 //4. NSRecursiveLock
 
// class RecursiveMutexTest {
//
//    private var mutex = pthread_mutex_t()
//    private var attribute = pthread_mutexattr_t()
//
//    init () {
//        pthread_mutexattr_init(&attribute)
//        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
//        pthread_mutex_init(&mutex, &attribute)
//    }
//
//    func firstTask() {
//        pthread_mutex_lock(&mutex)
//        secondTask()
//        defer {
//            pthread_mutex_unlock(&mutex)
//        }
//    }
//
//    private func secondTask() {
//        pthread_mutex_lock(&mutex)
//        debugPrint("Finish")
//        defer {
//            pthread_mutex_unlock(&mutex)
//        }
//    }
// }
//
// let recursive = RecursiveMutexTest()
// recursive.firstTask()
//
// //objc
// let recursiveLock = NSRecursiveLock()
//
// class RecursiveThread: Thread {
//    override func main() {
//        recursiveLock.lock()
//        debugPrint("Thread acquierd lock")
//        callMe()
//        defer {
//            debugPrint("defer 1")
//            recursiveLock.unlock()
//        }
//        debugPrint("Exit main")
//    }
//
//    func callMe() {
//        recursiveLock.lock()
//        debugPrint("Thread acquierd lock")
//        defer {
//            debugPrint("defer 2")
//            recursiveLock.unlock()
//        }
//        debugPrint("Exit callMe")
//    }
// }
//
// let thread = RecursiveThread()
// thread.start()

 //5. NSCondition

// var available = false
// var condition = pthread_cond_t()
// var mutex = pthread_mutex_t()
//
// class ConditionMutexPrinter: Thread {
//
//    override init() {
//        pthread_cond_init(&condition, nil)
//        pthread_mutex_init(&mutex, nil)
//    }
//
//    override func main() {
//        printerMethod()
//    }
//
//    private func printerMethod() {
//        pthread_mutex_lock(&mutex)
//        debugPrint("Printer enter")
//        while (!available) {
//            pthread_cond_wait(&condition, &mutex)
//        }
//        available = false
//        defer {
//            pthread_mutex_unlock(&mutex)
//        }
//        debugPrint("Printer exit")
//    }
// }
//
// class ConditionMutexWriter: Thread {
//
//    override init() {
//        pthread_cond_init(&condition, nil)
//        pthread_mutex_init(&mutex, nil)
//    }
//
//    override func main() {
//        writerMethod()
//    }
//
//    private func writerMethod() {
//        pthread_mutex_lock(&mutex)
//        debugPrint("Writer enter")
//        pthread_cond_signal(&condition)
//        available = true
//        defer {
//            pthread_mutex_unlock(&mutex)
//        }
//        debugPrint("Writer exit")
//    }
// }
//
// let writer = ConditionMutexWriter()
// let printer = ConditionMutexPrinter()
// writer.start()
// printer.start()
//
//
// let cond = NSCondition()
// var availableS = false
//
// class WriterThread: Thread {
//    override func main() {
//        cond.lock()
//        debugPrint("writer enter")
//        availableS = true
//        cond.signal()
//        cond.unlock()
//        debugPrint("writer exit")
//    }
// }
//
// class PrinterThread: Thread {
//    override func main() {
//        cond.lock()
//        debugPrint("printer enter")
//        while (!availableS) {
//            debugPrint("waiting")
//            cond.wait()
//        }
//        availableS = false
//        cond.unlock()
//        debugPrint("printer exit")
//    }
// }
//
// let writet = WriterThread()
// let printet = PrinterThread()
// printet.start()
// writet.start()

 //6. Lock
 
 class ReadWriteLock {
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    private var globalProperty: Int = 0
    init() {
        pthread_rwlock_init(&lock, &attribute)
    }
    
    public var workProperty: Int {
        get {
            pthread_rwlock_wrlock(&lock)
            let temp = globalProperty
            pthread_rwlock_unlock(&lock)
            return temp
        }
        
        set {
            pthread_rwlock_wrlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
 }
 
 //deprecated
// class SpinLock {
//    private var lock = OS_SPINLOCK_INIT
//
//    func some() {
//        OSSpinLockLock(&lock)
//        //something
//        OSSpinLockUnlock(&lock)
//    }
// }
 
 class UnfairLock {
    private var lock = os_unfair_lock_s()
    
    var array = [Int]()
    
    func some() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)
    }
 }
 
 class SynchronizedObjc {
    private let lock = NSObject()
    
    var array = [Int]()
    
    func some() {
        objc_sync_enter(lock)
        array.append(2)
        objc_sync_exit(lock)
    }
 }
 
// let c = SynchronizedObjc()
// c.some()
// debugPrint(c.array)

 //7. GCD
 
 class QueueTest1 {
    private let serialQueue = DispatchQueue(label: "serialTest")
    private let concurrentQueue = DispatchQueue(label: "concurrentTest", attributes: .concurrent)
 }
 
 class QueueTest2 {
    private let globalQueue = DispatchQueue.global()
    private let mainQueue = DispatchQueue.main
 }

 //8. GCD
 
 class MyViewController: UIViewController {
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "vc 1"
        
        view.backgroundColor = .white
        button.addTarget(self, action: #selector(pressAction), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initButton()
    }
    
    @objc func pressAction() {
        debugPrint("press")
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("Press", for: .normal)
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        view.addSubview(button)
    }
 }
 
 class SecondViewController: UIViewController {
    
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "vc 2"
        
        view.backgroundColor = .white
        loadPhoto()
//
//        let imageURL: URL = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
//
//        if let data = try? Data(contentsOf: imageURL) {
//            self.image.image = UIImage(data: data)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initImage()
    }
    
    func initImage() {
        image.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        image.center = view.center
        view.addSubview(image)
    }
    
    func loadPhoto() {
        let imageURL: URL = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
        }
    }
 }
 
// let vc = MyViewController()
// let navBar = UINavigationController(rootViewController: vc)
//
// PlaygroundPage.current.liveView = navBar

//10. Work item
 
 PlaygroundPage.current.needsIndefiniteExecution = true
 
 class DispatchWorkItem1 {
    private let queue = DispatchQueue(label: "DispatchWorkItem1", attributes: .concurrent)
    
    func create() {
        let workItem = DispatchWorkItem {
            debugPrint(Thread.current)
            debugPrint("Start task")
        }
        
        workItem.notify(queue: .main) {
            debugPrint(Thread.current)
            debugPrint("Task finished")
        }
        
        queue.async(execute: workItem)
    }
 }
 
// let dispatchWorkItem1 = DispatchWorkItem1()
// dispatchWorkItem1.create()
 
 class DispatchWorkItem2 {
    private let queue = DispatchQueue(label: "DispatchWorkItem2")
    
    func create() {
        queue.async {
            debugPrint(Thread.current)
            sleep(1)
            debugPrint("Task 1")
        }
        
        queue.async {
            debugPrint(Thread.current)
            sleep(1)
            debugPrint("Task 2")
        }
        
        let workItem = DispatchWorkItem {
            debugPrint(Thread.current)
            debugPrint("Start workItem2 task")
        }
        
        queue.async(execute: workItem)
        sleep(5)
        workItem.cancel()
    }
 }

// let dispatchWorkItem2 = DispatchWorkItem2()
// dispatchWorkItem2.create()

 var view = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
 var eImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
 eImage.backgroundColor = .cyan
 eImage.contentMode = .scaleAspectFit
 view.addSubview(eImage)
 
// PlaygroundPage.current.liveView = view
 
 let imageURL: URL = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
 
 //classic
 
 func fetchImage() {
    let queue = DispatchQueue.global(qos: .utility)
    
    queue.async {
        if let data = try? Data(contentsOf: imageURL) {
            DispatchQueue.main.async {
                eImage.image = UIImage(data: data)
            }
        }
    }
 }

// fetchImage()
 
 //2 DWI
 
 func fetchImage2() {
    var data: Data?
    let queue = DispatchQueue.global(qos: .utility)
    
    let workItem = DispatchWorkItem(qos: .userInteractive) {
        data = try? Data(contentsOf: imageURL)
        sleep(8)
        debugPrint(Thread.current, data)
    }
    queue.async(execute: workItem)
    
    workItem.notify(queue: DispatchQueue.main) {
        debugPrint(Thread.current)
        if let imageData = data {
            eImage.image = UIImage(data: imageData)
        }
    }
 }
 
// fetchImage2()
 
 //3. Async URLSession
 
 func fetchImage3() {
    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
        debugPrint(Thread.current)
        if let imageData = data {
            DispatchQueue.main.async {
                debugPrint(Thread.current)
                eImage.image = UIImage(data: imageData)
            }
        }
    }
    
    task.resume()
 }
 
// fetchImage3()
 
//11. GCD Semaphore

 let queue = DispatchQueue(label: "The Swift Dev", attributes: .concurrent)
 let semaphore = DispatchSemaphore(value: 0)

 queue.async {
    semaphore.wait() //-1
    sleep(3)
    debugPrint("method 1")
    semaphore.signal()
 }

 queue.async {
    semaphore.wait() //-1
    sleep(3)
    debugPrint("method 2")
    semaphore.signal()
 }

 queue.async {
    semaphore.wait() //-1
    sleep(3)
    debugPrint("method 3")
    semaphore.signal()
 }


// let sem = DispatchSemaphore(value: 0)
// sem.signal()
// DispatchQueue.concurrentPerform(iterations: 10) { (id: Int) in
//    sem.wait(timeout: DispatchTime.distantFuture)
//    debugPrint("===")
//    debugPrint(Thread.current)
//    debugPrint("Block", String(id))
//    sem.signal()
// }
 
 class SemaphoreTest {
    private let semaphore = DispatchSemaphore(value: 1)
    private var array = [Int]()
    
    private func methodWork(_ id: Int) {
        semaphore.wait()
        array.append(id)
        debugPrint("test array:", array.count)
        Thread.sleep(forTimeInterval: 1)
        semaphore.signal()
    }
    
    func startAllThreads() {
        DispatchQueue.global().async {
            self.methodWork(111)
        }
        
        DispatchQueue.global().async {
            self.methodWork(3242)
        }
        
        DispatchQueue.global().async {
            self.methodWork(456)
        }
        
        DispatchQueue.global().async {
            self.methodWork(46464)
        }
    }
 }

// let semaphoreTest = SemaphoreTest()
// semaphoreTest.startAllThreads()

 //12. DispatchGroup

 class DispatchGroupTest1 {
    private let queue = DispatchQueue(label: "The Swift Dev")
    
    private let groupred = DispatchGroup()
    
    func loadInfo() {
        queue.async(group: groupred) {
            sleep(1)
            debugPrint("1")
        }
        
            queue.async(group: groupred) {
            sleep(1)
            debugPrint("2")
        }
        
        queue.async(group: groupred) {
            sleep(1)
            debugPrint("3")
        }
        
        groupred.notify(queue: .main) {
            debugPrint("group finish all")
        }
    }
 }

// let dispatchGroupTest1 = DispatchGroupTest1()
// dispatchGroupTest1.loadInfo()

 class DispatchGroupTest2 {
    private let queueC = DispatchQueue(label: "The Swift Dev", attributes: .concurrent)
    
    private let groupBlack = DispatchGroup()
    
    func loadInfo() {
        groupBlack.enter()
        queueC.async {
            sleep(1)
            debugPrint("1")
            self.groupBlack.leave()
        }
        
        groupBlack.enter()
        queueC.async {
            sleep(2)
            debugPrint("2")
            self.groupBlack.leave()
        }
        
        groupBlack.wait()
        
        debugPrint("finished all")
        
        groupBlack.notify(queue: .main) {
            debugPrint("group finished all")
        }
    }
 }

//  let dispatchGroupTest2 = DispatchGroupTest2()
//  dispatchGroupTest2.loadInfo()

 class EightImage: UIView {
    public var ivs = [UIImageView]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100)))
        
        for i in 0...7 {
            ivs[i].contentMode = .scaleAspectFit
            self.addSubview(ivs[i])
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 }

 var view8 = EightImage(frame: CGRect(x: 0, y: 0, width: 700, height: 900))
 view8.backgroundColor = .cyan

 let imageURLs = ["https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
                  "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg",
                "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png",
            "https://vignette.wikia.nocookie.net/iceage/images/2/24/Sid_Sloth.png/revision/latest?cb=20161218032655"]

 var images = [UIImage]()
 
// PlaygroundPage.current.liveView = view8
 
 func asyncLoadImage(imageURL: URL, runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (UIImage?, Error?) -> ()) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async { completion(UIImage(data: data), nil) }
        } catch let error {
            completionQueue.async { completion(nil, error) }
        }
    }
 }
 
 func asyncGroup() {
    let aGroup = DispatchGroup()
    
    for i in 0...3 {
        aGroup.enter()
        asyncLoadImage(imageURL: URL(string: imageURLs[i])!,
                       runQueue: .global(),
                       completionQueue: .main) { (result, error) in
                        guard let image = result else {
                            return
                        }
                        images.append(image)
                        aGroup.leave()
        }
    }
    aGroup.notify(queue: .main) {
        for i in 0...3 {
            view8.ivs[i].image = images[i]
        }
    }
 }
 
 func asyncURLSession() {
    for i in 4...7 {
        let url = URL(string: imageURLs[i - 4])
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                view8.ivs[i].image = UIImage(data: data!)
            }
        }
        task.resume()
    }
 }
//asyncURLSession()
// asyncGroup()
 
 
 //14. Dispatch Barrier
 
// var array = [Int]()
//
// for i in 0...9 {
//    array.append(i)
// }
//
// debugPrint(array)
// debugPrint(array.count)

// var array = [Int]()
// DispatchQueue.concurrentPerform(iterations: 10) { (index) in
//    array.append(index)
// }
//
// debugPrint(array)
// debugPrint(array.count)

 class SafeArray<T> {
    private var array = [T]()
    private let queue = DispatchQueue(label: "The Swift Dev", attributes: .concurrent)
    
    public func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }
    
    public var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }
 }
 
 var arraySafe = SafeArray<Int>()
 
 DispatchQueue.concurrentPerform(iterations: 10) { (index) in
    arraySafe.append(index)
 }
 
// debugPrint(arraySafe.valueArray)
// debugPrint(arraySafe.valueArray.count)
 
 
 //14. Dispatch Source
 
// let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
// timer.setEventHandler {
//    debugPrint(Thread.current)
//    debugPrint("!")
// }
//
// timer.schedule(deadline: .now(), repeating: 5)
// timer.activate()
 
 //15. Operation
 
// debugPrint(Thread.current)
 
// let operation1 = {
//    debugPrint("Start")
//    debugPrint(Thread.current)
//    debugPrint("Finish")
// }
//
// let queueo = OperationQueue()
// queueo.addOperation(operation1)
 
// var result: String?
// let concatOperation = BlockOperation {
//    result = "The Swift" + " " + "Dev"
//    debugPrint(Thread.current)
// }
//
// let queueoo = OperationQueue()
// queueoo.addOperation(concatOperation)
//
// let queue1 = OperationQueue()
// queue1.addOperation {
//    debugPrint("Test")
//    debugPrint(Thread.current)
// }
 
 class MyThread: Thread {
    override func main() {
        debugPrint("Test main Thread")
        debugPrint(Thread.current)
    }
 }
 
 let myThread = MyThread()
// myThread.start()
 
 class OparationA: Operation {
    override func main() {
        debugPrint("Test main OperationA")
        debugPrint(Thread.current)
    }
 }
 
 let operationA = OparationA()
// operationA.start()
 
 let queue2 = OperationQueue()
// queue2.addOperation(operationA)

 //16. Operation

 let opQ = OperationQueue()
 
 class OperationCancelTest: Operation {
    override func main() {
        if isCancelled {
            debugPrint(isCancelled)
            return
        }
        debugPrint("test 1")
        sleep(1)
        
        if isCancelled {
            debugPrint(isCancelled)
            return
        }
        debugPrint("2")
    }
 }
 
 func cancelMethod() {
    let cancelOperation = OperationCancelTest()
    opQ.addOperation(cancelOperation)
    cancelOperation.cancel()
 }
 
// cancelMethod()
 
 class WaitOperationtest {
    private let operationQueue = OperationQueue()
    
    func test() {
        operationQueue.addOperation {
            sleep(1)
            debugPrint("test 1")
        }
        operationQueue.addOperation {
            sleep(2)
            debugPrint("test 2")
        }
        operationQueue.waitUntilAllOperationsAreFinished()
        operationQueue.addOperation {
            debugPrint("test 3")
        }
        operationQueue.addOperation {
            debugPrint("test 4")
        }
    }
 }
 
 let waitOperationtest = WaitOperationtest()
 waitOperationtest.test()
 
 
 class WaitOperationTest2 {
    private let operationQueue = OperationQueue()
    
    func test() {
        let operation = BlockOperation {
            sleep(1)
            debugPrint("test 1")
        }
        let operation2 = BlockOperation {
            sleep(2)
            debugPrint("test 2")
        }
        
        operationQueue.addOperations([operation, operation2], waitUntilFinished: true)
    }
 }

 let waitOperationTest2 = WaitOperationTest2()
 waitOperationTest2.test()
 
 class CompletionBlockTest {
    private let operationQueue = OperationQueue()
    
    func test() {
        let operation = BlockOperation {
            sleep(3)
            debugPrint("test completion block")
        }
        operation.completionBlock = {
            debugPrint("Finish")
        }
        operationQueue.addOperation(operation)
    }
 }
 
 let completionBlockTest = CompletionBlockTest()
 completionBlockTest.test()
