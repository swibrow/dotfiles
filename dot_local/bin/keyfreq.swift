import Foundation
import CoreGraphics

let dataDir = ("~/.local/share/keyfreq" as NSString).expandingTildeInPath
let dataFile = dataDir + "/counts.tsv"

var counts: [Int64: UInt64] = [:]
var eventTap: CFMachPort?

func loadCounts() {
    guard let content = try? String(contentsOfFile: dataFile, encoding: .utf8) else { return }
    for line in content.split(separator: "\n") {
        let parts = line.split(separator: "\t")
        if parts.count == 2, let code = Int64(parts[0]), let n = UInt64(parts[1]) {
            counts[code] = n
        }
    }
}

func saveCounts() {
    try? FileManager.default.createDirectory(atPath: dataDir, withIntermediateDirectories: true)
    let sorted = counts.sorted { $0.value > $1.value }
    var out = ""
    for (code, n) in sorted { out += "\(code)\t\(n)\n" }
    try? out.write(toFile: dataFile, atomically: true, encoding: .utf8)
}

let keyNames: [Int64: String] = [
    0: "a", 1: "s", 2: "d", 3: "f", 4: "h", 5: "g", 6: "z", 7: "x", 8: "c", 9: "v",
    11: "b", 12: "q", 13: "w", 14: "e", 15: "r", 16: "y", 17: "t", 18: "1", 19: "2",
    20: "3", 21: "4", 22: "6", 23: "5", 24: "=", 25: "9", 26: "7", 27: "-", 28: "8",
    29: "0", 30: "]", 31: "o", 32: "u", 33: "[", 34: "i", 35: "p", 36: "return",
    37: "l", 38: "j", 39: "'", 40: "k", 41: ";", 42: "\\", 43: ",", 44: "/", 45: "n",
    46: "m", 47: ".", 48: "tab", 49: "space", 50: "`", 51: "delete", 53: "escape",
    54: "r-cmd", 55: "cmd", 56: "shift", 57: "capslock", 58: "option", 59: "control",
    60: "r-shift", 61: "r-option", 62: "r-control", 63: "fn", 96: "f5", 97: "f6",
    98: "f7", 99: "f3", 100: "f8", 101: "f9", 103: "f11", 105: "f13", 109: "f10",
    111: "f12", 114: "help", 115: "home", 116: "pageup", 117: "fwd-delete",
    118: "f4", 119: "end", 120: "f2", 121: "pagedown", 122: "f1", 123: "left",
    124: "right", 125: "down", 126: "up",
]

func keyName(_ code: Int64) -> String { keyNames[code] ?? "code\(code)" }

func tapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent,
                 refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    switch type {
    case .keyDown:
        let code = event.getIntegerValueField(.keyboardEventKeycode)
        counts[code, default: 0] += 1
    case .tapDisabledByTimeout, .tapDisabledByUserInput:
        if let tap = eventTap { CGEvent.tapEnable(tap: tap, enable: true) }
    default:
        break
    }
    return Unmanaged.passUnretained(event)
}

func die(_ msg: String) -> Never {
    FileHandle.standardError.write((msg + "\n").data(using: .utf8)!)
    exit(1)
}

func runDaemon() {
    loadCounts()
    let mask = (1 << CGEventType.keyDown.rawValue)
    guard let tap = CGEvent.tapCreate(
        tap: .cgSessionEventTap, place: .headInsertEventTap, options: .listenOnly,
        eventsOfInterest: CGEventMask(mask), callback: tapCallback, userInfo: nil)
    else {
        die("keyfreq: failed to create event tap — grant Input Monitoring to \(CommandLine.arguments[0])")
    }
    eventTap = tap
    let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
    CGEvent.tapEnable(tap: tap, enable: true)

    let timer = Timer(timeInterval: 10.0, repeats: true) { _ in saveCounts() }
    RunLoop.current.add(timer, forMode: .common)

    signal(SIGTERM) { _ in saveCounts(); exit(0) }
    signal(SIGINT) { _ in saveCounts(); exit(0) }

    CFRunLoopRun()
}

func pad(_ s: String, _ width: Int) -> String {
    s.count >= width ? s : s + String(repeating: " ", count: width - s.count)
}

func runTop(_ n: Int) {
    loadCounts()
    let sorted = counts.sorted { $0.value > $1.value }
    let total = counts.values.reduce(0, +)
    if total == 0 { print("no keys recorded yet"); return }
    print("\(pad("rank", 6))\(pad("key", 12))\(pad("count", 10))share")
    for (i, entry) in sorted.prefix(n).enumerated() {
        let share = Double(entry.value) / Double(total) * 100
        let rank = pad("\(i + 1).", 6)
        let key = pad(keyName(entry.key), 12)
        let cnt = pad("\(entry.value)", 10)
        print("\(rank)\(key)\(cnt)\(String(format: "%.1f%%", share))")
    }
    print("\ntotal keys counted: \(total)")
}

func runReset() {
    try? FileManager.default.removeItem(atPath: dataFile)
    print("keyfreq counts reset")
}

let args = CommandLine.arguments
switch args.count > 1 ? args[1] : "daemon" {
case "daemon": runDaemon()
case "top": runTop(args.count > 2 ? Int(args[2]) ?? 20 : 20)
case "reset": runReset()
default:
    print("usage: keyfreq [daemon|top [N]|reset]")
    exit(2)
}
