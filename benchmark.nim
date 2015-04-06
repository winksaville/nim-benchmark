## Benchmark will measure the duration it takes for some arbitrary
## code to excute in the body of the test templates and returns
## the information for the runs in TestStats var parameter.
##
## There are  versions of the test templates you can specify
## the number of loops or how long to execute the body. In addition
## you can specify a single TestStats var parameter or a set of them
## in an array. Also, if a loop count is specified and N TestStats
## are passed in then the body will be executed loop count * N
## time.
## 
## As mentioned the number of statistic buckets is defined by the
## TestStats parameter. The duration of the sub runs are sorted from
## fastest to slowest and pushed into the corresponding TestStats entry.
## An array gives you a beter overview of the spread of the performance
## as it's very difficult to get consistent data on modern computers
## where there is a lot of contention for resources. Such as
## interrupts, mutliple cores both logical and physical, multiple threads,
## migration of threads to different cores, the list is endless.
##
## The measurements are taken each loop and is measured in cycles as
## defined by the CPU. On an X86 the RDTSC instruction is used to read
## the value and the routine cyclesPerSecond will return the approximate
## frequency. The cycle values displayed will be in cycles "cy" if the
## number of cycles is less-than SuiteObj.cyclesToSecThreshold or
## time ("s", "ms", ## "us", "ps") if greater-than.
##
## Example use with exmpl/bminc.nim
##::
## $ cat examples/bminc.nim
## import benchmark
## 
## suite "increment", 0.0:
##   var
##     ts: TestStats
##     loops = 0
## 
##   test "inc", 0.5, ts:
##     inc(loops)
## 
##   test "atomicInc", 0.5, ts:
##     atomicInc(loops)

## And then compiling and running we see some odd data. The
## atomicInc(loops) is faster, 48cy, then inc(loops) which is
## unexpected. Also minC was only 1 which means that for the
## 400,000+ executions of the inc(loops) and atomicInc(loops)
## only 1 was at min value, 50cy or 48cy respectively. This
## doesn't give you a lot confidence in the data. 
##::
## $ nim c --hints:off exmpl/bminc.nim
## CC: benchmark_bminc2
## CC: stdlib_system
## CC: benchmark_benchmark
## CC: stdlib_algorithm
## CC: stdlib_math
## CC: stdlib_times
## CC: stdlib_strutils
## CC: stdlib_parseutils
## CC: stdlib_os
## CC: stdlib_posix
## [Linking]
## $ exmpl/bminc
## increment.inc: ts={min=50cy mean=78cy minC=1 n=452276}
## increment.atomicInc: ts={min=48cy mean=81cy minC=1 n=431060}

## So lets make two changes to the code we'll change the warmup
## time for suite from 0.0 to 1.0 second. And we'll change
## ts to an array of 5 TestStats rather than just one.
##:: 
## $ cat exmpl/bminc2.nim
## suite "increment", 1.0:
##   var
##     ts: array[0..4, TestStats]
##     loops = 0
## 
##   test "inc", 0.5, ts:
##     inc(loops)
## 
##   test "atomicInc", 0.5, ts:
##     atomicInc(loops)

## With these change we still see the atomicInc being faster
## but we also see min ranging from 50cy to 68cy and the
## mean 75cy to 91cy giving us a better idea of the range of
## data. But we still have this oddity of atomicInc being
## faster than inc.
##:: 
## $ nim c --hints:off exmpl/bminc.nim
## CC: benchmark_bminc2
## $ exmpl/bminc2
## [Linking]
## $ exmpl/bminc2
## increment.inc: ts[0]={min=50cy mean=74cy minC=2 n=169482}
## increment.inc: ts[1]={min=52cy mean=78cy minC=45 n=169482}
## increment.inc: ts[2]={min=52cy mean=80cy minC=1 n=169482}
## increment.inc: ts[3]={min=56cy mean=81cy minC=10 n=169482}
## increment.inc: ts[4]={min=68cy mean=91cy minC=76 n=169482}
## increment.atomicInc: ts[0]={min=48cy mean=71cy minC=2 n=175137}
## increment.atomicInc: ts[1]={min=52cy mean=73cy minC=61 n=175137}
## increment.atomicInc: ts[2]={min=52cy mean=76cy minC=3 n=175137}
## increment.atomicInc: ts[3]={min=54cy mean=78cy minC=1 n=175137}
## increment.atomicInc: ts[4]={min=68cy mean=84cy minC=3780 n=175137}

## Lets turn on threading and see what happens maybe that will
## make a difference. And sure enough we now see that inc is
## faster than atomic but the performance slowed down to 138cy
## instead of 50cy. So turning on threading can hurt performance
## at least in this configuration.
##::
## $ nim c --threads:on --hints:off exmpl/bminc2.nim
## CC: benchmark_bminc2
## CC: stdlib_system
## CC: benchmark_benchmark
## CC: stdlib_algorithm
## CC: stdlib_math
## CC: stdlib_times
## CC: stdlib_strutils
## CC: stdlib_parseutils
## CC: stdlib_os
## CC: stdlib_posix
## [Linking]
## $ exmpl/bminc2
## increment.inc: ts[0]={min=138cy mean=164cy minC=2 n=116542}
## increment.inc: ts[1]={min=146cy mean=165cy minC=26 n=116542}
## increment.inc: ts[2]={min=148cy mean=167cy minC=48 n=116542}
## increment.inc: ts[3]={min=150cy mean=170cy minC=2 n=116542}
## increment.inc: ts[4]={min=152cy mean=183cy minC=1 n=116542}
## increment.atomicInc: ts[0]={min=150cy mean=177cy minC=1 n=115241}
## increment.atomicInc: ts[1]={min=158cy mean=180cy minC=37 n=115241}
## increment.atomicInc: ts[2]={min=158cy mean=183cy minC=1 n=115241}
## increment.atomicInc: ts[3]={min=160cy mean=185cy minC=1 n=115241}
## increment.atomicInc: ts[4]={min=170cy mean=194cy minC=254 n=115241}

## Lets make one final change lets make this a release build. What
## a huge difference the cycles is now 16cy for inc and 26cy for
## atomicInc and we see that  minC is not a miniscule number
## so we have a very high confidence that in a release build even
## with threading enabled an inc takes 16cy and atomicInc is 26cy.
##::
## $ nim c -d:release --threads:on --hints:off exmpl/bminc2.nim
## CC: benchmark_bminc2
## CC: stdlib_system
## CC: benchmark_benchmark
## CC: stdlib_algorithm
## CC: stdlib_math
## CC: stdlib_times
## CC: stdlib_strutils
## CC: stdlib_parseutils
## CC: stdlib_os
## CC: stdlib_posix
## [Linking]
## $ exmpl/bmrun2
## increment.inc: ts[0]={min=16cy mean=18cy minC=314358 n=390304}
## increment.inc: ts[1]={min=16cy mean=20cy minC=256916 n=390304}
## increment.inc: ts[2]={min=16cy mean=22cy minC=151829 n=390304}
## increment.inc: ts[3]={min=16cy mean=27cy minC=65869 n=390304}
## increment.inc: ts[4]={min=16cy mean=30cy minC=16848 n=390304}
## increment.atomicInc: ts[0]={min=26cy mean=31cy minC=116704 n=355885}
## increment.atomicInc: ts[1]={min=26cy mean=37cy minC=12701 n=355885}
## increment.atomicInc: ts[2]={min=26cy mean=42cy minC=986 n=355885}
## increment.atomicInc: ts[3]={min=26cy mean=44cy minC=2 n=355885}
## increment.atomicInc: ts[4]={min=28cy mean=48cy minC=2733 n=355885}

# The use of cpuid, rtsc, rtsp is modeled from Intel document titled
#   "How to Benchmark Code Execution Times on Intel IA-32
#   and IA-64 Instruction Set Architectures"
# Here is a short link to that document: http://goo.gl/tzKu65

import algorithm, math, times, os, posix, strutils
export math, algorithm

const
  DEBUG = false
  USE_RDTSCP_FOR_END_CYCLES = false
  DEFAULT_OVERHEAD_RUNTIME = 0.25
  DEFAULT_CPS_RUNTIME = 0.25
  DEFAULT_CYCLES_TO_SEC_THRESHOLD = 1_000.0

type
  Verbosity* {.pure.} = enum  ## Logging verbosity
    none = 0 ## Nothing output
    normal = 1 ## Normal outout at end of run
    debug = 2 ## Additional debug output
    verbose = 3 ## Copious output

  SuiteObj* = object ## Object associated with a suite
    suiteName: string ## Name of the suite
    testName: string ## Name of the current test
    fullName: string ## Suite and Runame concatonated
    cyclesPerSec: float ## Frequency of cycle counter
    cyclesToSecThreshold: float ## Threshold for displaying cycles or secs
    verbosity: Verbosity ## Verbosity of output
    overhead: float ## Number of cycles overhead to be substracted when measuring
    hasRDTSCP: bool ## True if the cpu has RDTSCP instruction

var
  bmDefaultVerbosity* = Verbosity.normal

proc NONE*(verbosity: Verbosity): bool {.inline.} =
  ## Return true if verbosity == Verbosity.none
  result = verbosity == Verbosity.normal

proc NRML*(verbosity: Verbosity): bool {.inline.} =
  ## Return true if verbosity >= Verbosity.normal
  result = verbosity >= Verbosity.normal

proc DBG*(verbosity: Verbosity): bool {.inline.} =
  ## Return true if verbosity >= Verbosity.debug
  result = verbosity >= Verbosity.debug

proc DBGV*(verbosity: Verbosity): bool {.inline.} =
  ## Return true if verbosity >= Verbosity.verbose
  result = verbosity >= Verbosity.verbose

proc NONE*(suiteObj: SuiteObj): bool {.inline.} =
  ## Return true if suiteObj.verbosity == Verbosity.none
  result = NONE(suiteObj.verbosity)

proc NRML*(suiteObj: SuiteObj): bool {.inline.} =
  ## Return true if bsmo.verbosity >= Verbosity.normal
  result = NRML(suiteObj.verbosity)

proc DBG*(suiteObj: SuiteObj): bool {.inline.} =
  ## Return true if suiteObj.verbosity >= Verbosity.debug
  result = DBG(suiteObj.verbosity)

proc DBGV*(suiteObj: SuiteObj): bool {.inline.} =
  ## Return true if suiteObj.verbosity >= Verbosity.verbose
  result = DBGV(suiteObj.verbosity)

# Forward decls
proc secToStr*(seconds: float): string
proc cyclesToStr*(suiteObj: SuiteObj, cycles: float): string

proc strOrNil(s: string): string =
  result = if s == nil: "nil" else: s

proc `$`*(suiteObj: SuiteObj): string =
  result = "{suiteName=" & strOrNil(suiteObj.suiteName) &
           " testName=" & strOrNil(suiteObj.testName) &
           " fullName=" & strOrNil(suiteObj.fullName) &
           " cyclesPerSec=" & secToStr(suiteObj.cyclesPerSec) &
           " cyclesToSecThreshold=" & secToStr(suiteObj.cyclesToSecThreshold) &
           " verbosity=" & $suiteObj.verbosity &
           " overhead=" & cyclesToStr(suiteObj, suiteObj.overhead) &
           " hasRDTSCP=" & $suiteObj.hasRDTSCP & "}"

type
  TestStats* = object ## A test run's statistical data
    n*: int ## number of data points
    minC*: int ## number of data points == min
    maxC*: int ## number of data points == max
    sum*, min*, max*, mean*: float ## self-explaining
    oldM, oldS, newS: float

proc `$`*(s: TestStats): string =
  ## Print the TestStats.
  "{n=" & $s.n & " sum=" & $s.sum & " min=" & $s.min & " minC=" & $s.minC &
    " max=" & $s.max & " maxC=" & $s.maxC & " mean=" & $s.mean & "}"

proc zero*(ts: var TestStats) =
  ## Zero TestStats fields
  ts.n = 0
  ts.minC = 0
  ts.maxC = 0
  ts.sum = 0.0
  ts.min = 0.0
  ts.max = 0.0
  ts.mean = 0.0
  ts.oldM = 0.0
  ts.oldS = 0.0
  ts.newS = 0.0

proc zero*(tsArray: var openarray[TestStats]) =
  ## Zero an array of TestStats
  for i in 0..tsArray.len-1:
    zero(tsArray[i])

proc push*(s: var TestStats, x: float) =
  ## Pushes a value `x` for processing
  inc(s.n)
  # See Knuth TAOCP vol 2, 3rd edition, page 232
  if s.n == 1:
    s.min = x
    s.minC = 1
    s.max = x
    s.maxC = 1
    s.oldM = x
    s.mean = x
    s.oldS = 0.0
  else:
    if s.min == x:
      s.minC += 1
    elif s.min > x:
      s.min = x
      s.minC = 1

    if s.max == x:
      s.maxC += 1
    elif s.max < x:
      s.max = x
      s.maxC = 1
    s.mean = s.oldM + (x - s.oldM)/toFloat(s.n)
    s.newS = s.oldS + (x - s.oldM)*(x - s.mean)

    # set up for next iteration:
    s.oldM = s.mean
    s.oldS = s.newS
  s.sum = s.sum + x
  
proc push*(s: var TestStats, x: int) =
  ## Pushes a value `x` for processing. `x` is simply converted to ``float``
  ## and the other push operation is called.
  push(s, toFloat(x))
  
proc variance*(s: TestStats): float =
  ## Computes the current variance of `s`
  if s.n > 1: result = s.newS / (toFloat(s.n - 1))

proc standardDeviation*(s: TestStats): float =
  ## Computes the current standard deviation of `s`
  result = sqrt(variance(s))


type
  CpuId* = tuple  ## EAX..EDX registers returned by CPUID instruciton
    eax: int
    ebx: int
    ecx: int
    edx: int

proc `$`(cpuid: CpuId): string =
  ## Print the CpuId.
  "{ eax=0x" & toHex(cpuid.eax, 8) & " ebx=0x" & toHex(cpuid.ebx, 8) &
    " ecx=0x" & toHex(cpuid.ecx, 8) & " edx=0x" & toHex(cpuid.edx, 8) & "}"

proc cpuid(eax_param: int, ecx_param: int): CpuId =
  ## Execute cpuid instruction wih EAX = eax_param and ECX = ecx_param.
  {.emit: """
    asm volatile (
      "movq %4, %%rax\n\t"
      "movq %5, %%rcx\n\t"
      "cpuid\n\t"
      : "=a"(`result.Field0`), "=b"(`result.Field1`), "=c"(`result.Field2`), "=d"(`result.Field3`)
      : "r"(`eax_param`), "r"(`ecx_param`));
  """.}

proc cpuid(ax_param: int): CpuId =
  ## Execute cpuid instruction wih EAX = eax_param.
  {.emit: """
    asm volatile (
      "movq %4, %%rax\n\t"
      "cpuid\n\t"
      : "=a"(`result.Field0`), "=b"(`result.Field1`), "=c"(`result.Field2`), "=d"(`result.Field3`)
      : "r"(`ax_param`));
  """.}

proc cpuid() {.inline.} =
  ## Execute cpuid instruction wih no parameters. This will
  ## return arbitrary data and is used a memory barrier instruction.
  {.emit: """
    asm volatile (
      "cpuid\n\t"
      : /* Throw away output */
      : /* No input */
      : "%eax", "%ebx", "%ecx", "%edx");
  """.}

proc mfence() {.inline.} =
  ## Full memory barrier serializes all loads and stores.
  {.emit: """
    asm volatile (
      "mfence\n\t"
      : /* Throw away output */
      : /* No input */
      : "memory");
  """.}

proc hasRDTSCP(): bool =
  var id = cpuid(0x80000001)
  result = (id.edx and (1 shl 27)) != 0

proc rdtsc(): int64 {.inline.} =
  ## Execute the rdtsc, read Time Stamp Counter, instruction
  ## returns the 64 bit TSC value.
  var lo, hi: uint32
  {.emit: """
    asm volatile (
      "rdtsc\n\t"
      :"=a"(`lo`), "=d"(`hi`));
  """.}
  result = int64(lo) or (int64(hi) shl 32)
  when DEBUG: echo "rdtsc:-  result=", result

proc rdtscp(): int64 {.inline.} =
  ## Execute the rdtscp, read Time Stamp Counter, instruction
  ## returns the 64 bit TSC value but ignore the tscAux value.
  var lo, hi: uint32
  {.emit: """
    asm volatile (
      "rdtscp\n\t"
      :"=a"(`lo`), "=d"(`hi`));
  """.}
  result = int64(lo) or (int64(hi) shl 32)
  when DEBUG: echo "rdtscp:- result=", result

proc rdtscp(tscAux: var int32): int64 {.inline.} =
  ## Execute the rdtscp, read Time Stamp Counter, instruction
  ## returns the 64 bit TSC value and writes ecx to tscAux value.
  ## The tscAux value is the logical cpu number and can be used
  ## to determine if the thread migrated to a different cpu and
  ## thus the returned value is suspect.
  var lo, hi, aux: int32
  {.emit: """
    asm volatile (
      "rdtscp\n\t"
      :"=a"(`lo`), "=d"(`hi`), "=c"(`aux`));
  """.}
  tscAux = aux
  result = int64(lo) or (int64(hi) shl 32)
  when DEBUG: echo "rdtscp:- result=", result, " tscAux=", tscAux

proc rdTscAux(): int32 {.inline.} =
  ## Use rdtscp to read just tscAux value from ecx
  var aux: int32
  {.emit: """
    asm volatile (
      "rdtscp\n\t"
      :"=c"(`aux`));
  """.}
  result = aux
  when DEBUG: echo "rdTscAux:- result=", result


proc getBegCycles(): int64 {.inline.} =
  ## Return TSC to be used at the beginning of the measurement.
  cpuid()
  result = rdtsc()

proc getEndCyclesNoRdtscp(): int64 {.inline.} =
  ## Return TSC to be used at the end of the measurement.
  result = rdtsc()
  mfence()

proc getEndCycles(tscAux: var int32): int64 {.inline.} =
  ## Return TSC to be used at the end of the measurement
  ## and write ecx to tscAux. The tscAux value is the
  ## logical cpu number and can be used to determine if
  ## the thread migrated to a different cpu and thus the
  ## returned value is suspect.
  when USE_RDTSCP_FOR_END_CYCLES:
    # For some reason this is very unreliable and on my linux desktop
    # negative TSC values in are frequently returned in result!
    result = rdtscp(tscAux)
    cpuid()
  else:
    tscAux = rdTscAux()
    result = rdtsc()
    mfence()

proc initializeCycles(suiteObj: SuiteObj, tscAux: var int32): int64 {.inline.} =
  ## Initalize as per the ia32-ia64-benchmark document returning
  ## the tsc value as exiting and the tscAux in the var param
  if DBGV(suiteObj): echo "initializeCycles:+"
  if suiteObj.hasRdtscp:
    discard getBegCycles()
    discard getEndCycles(tscAux)
    discard getBegCycles()
    result = getEndCycles(tscAux)
  else:
    discard getBegCycles()
    discard getEndCyclesNoRdtscp()
    discard getBegCycles()
    result = getEndCyclesNoRdtscp()
  if DBGV(suiteObj): echo "initializeCycles:- result=", result, " tscAux=", tscAux

proc cyclesPerSecond*(suiteObj: SuiteObj, seconds: float = DEFAULT_CPS_RUNTIME): float =
  proc cps(seconds: float): float =
    ## Determine the approximate cycles per second of the TSC.
    ## The seconds parameter is the length of the meausrement.
    ## return a value < 0.0 if unsuccessful. This happens if the
    ## code detects if the thread migrated cpu's.
    var
      tscAuxInitial: int32
      tscAuxNow: int32
      start: int64
      ec: int64
      endTime: float

    endTime = epochTime() + seconds
    start = initializeCycles(suiteObj, tscAuxInitial)
    while epochTime() <= endTime:
      if suiteObj.hasRDTSCP:
        ec = getEndCycles(tscAuxNow)
      else:
        ec = getEndCyclesNoRdtscp()
      if tscAuxInitial != tscAuxNow:
        if DBG(suiteObj):
          echo "cps:- BAD tscAuxNow:", tscAuxNow,
            " != tscAuxInitial:", tscAuxInitial
        return -1.0
    result = float((ec - start)) / seconds

  ## Call cps several times to maximize the chance
  ## of getting a good value
  if DBG(suiteObj): echo "cyclesPerSecond:+ seconds=", seconds
  for i in 0..2:
    result = cps(seconds)
    if result > 0.0:
      if DBG(suiteObj): echo "cyclesPerSecond:- result=", result
      return result
  result = -1.0
  if DBG(suiteObj): echo "cyclesPerSecond:- BAD result=", result

template measure(suiteObj: SuiteObj, durations: var openarray[float],
    tsArray: var openarray[TestStats], body: stmt): bool =
  var
    ok: bool = true
    tscAuxInitial: int32
    tscAuxNow: int32
    bc : int64
    ec : int64

  if DBGV(suiteObj): echo "measure:+"
  discard initializeCycles(suiteObj, tscAuxInitial)
  if DBGV(suiteObj):
    echo "measure:  before loop loopCount=", tsArray.len,
      " tscAuxInitial=", tscAuxInitial
  for i in 0..tsArray.len-1:
    if suiteObj.hasRDTSCP:
      bc = getBegCycles()
      body
      ec = getEndCycles(tscAuxNow)
    else:
      bc = getBegCycles()
      body
      ec = getEndCyclesNoRdtscp()
    if ec < bc:
      ok = false
      if DBG(suiteObj): echo "measure: BAD ec:" & $ec & " < bc:" & $bc
      break
    var adjDuration = float(ec - bc) - suiteObj.overhead
    if adjDuration < 0: adjDuration = 0
    durations[i] = adjDuration
    if DBGV(suiteObj):
      echo "measure:  duration[", i, "]=", durations[i], " ec=", float(ec), " bc=",
        float(bc)
    if tscAuxInitial != tscAuxNow:
      # Switched CPU we can't trust duration
      if DBG(suiteObj):
        echo "measure:  BAD tscAuxNow=", tscAuxNow, " != tscAuxInitial=", tscAuxInitial
      ok = false;
      break
  if ok:
    sort(durations, system.cmp[float])
    for i in 0..tsArray.len-1:
      tsArray[i].push(durations[i])
  if DBGV(suiteObj): echo "measure:- ok=", $ok
  ok

template measureSecs(suiteObj: SuiteObj, seconds: float,
    tsArray: var openarray[TestStats], body: stmt) =
  ## Meaure the execution time of body for seconds period of time
  ## returning the array of TestStats for the loop timings. If
  if DBGV(suiteObj): echo "measureSecs:+ seconds=", seconds

  var
    durations = newSeq[float](tsArray.len)
    runDuration = seconds
    start = epochTime()
    cur = start
  # I tried using cycles rather than epoch time but there
  # was not measureable difference in performance and this
  # is simpler because we don't have to pass or calculate
  # the current cycles per second.
  while runDuration > cur - start:
    if not measure(suiteObj, durations, tsArray, body):
      if DBGV(suiteObj): echo "echo measureSecs: BAD measurement"
    cur = epochTime()

  if DBGV(suiteObj): echo "measureSecs:-"

template measureLoops(suiteObj: SuiteObj, loopCount: int,
    tsArray: var openarray[TestStats], body: stmt) =
  ## Meaure the execution time of body for seconds period of time
  ## returning the array of TestStats for the loop timings. If
  if DBGV(suiteObj): echo "measureLoops: loopCount=", loopCount

  var
    durations = newSeq[float](tsArray.len)

  for i in 0..loopCount-1:
    if not measure(suiteObj, durations, tsArray, body):
      if DBGV(suiteObj): echo "echo measureLoops: BAD measurement"

  if DBGV(suiteObj): echo "measureLoops:-"

proc secToStr*(seconds: float): string =
  ## Convert seconds to string with suffix if possible
  var
    suffixArray = @["s", "ms", "us", "ns", "ps"]
    adjSeconds = seconds

  for suffix in suffixArray:
    if adjSeconds >= 1.0:
      return formatFloat(adjSeconds, ffDecimal, 3) & suffix
    adjSeconds *= 1.0e3
  result = formatFloat(seconds, ffScientific, 4)

proc cyclesToStr*(suiteObj: SuiteObj, cycles: float): string =
  ## Convert cycles to string either as cycles or time
  ## depending upon suiteObj.cyclesToSecThreshold
  if cycles >=  suiteObj.cyclesToSecThreshold:
    result = secToStr(cycles / suiteObj.cyclesPerSec)
  else:
    result = $round(cycles) & "cy"

proc bmStatsToStr*(suiteObj: SuiteObj, s: TestStats): string =
  ## Print the TestStats using cycles per second.
  "{n=" & $s.n &
    " min=" & cyclesToStr(suiteObj, s.min) &
    " minC=" & $s.minC &
    " max=" & cyclesToStr(suiteObj, s.max) &
    " maxC=" & $s.maxC &
    " mean=" & cyclesToStr(suiteObj, s.mean) &
    " sum=" & cyclesToStr(suiteObj, s.sum) &
    "}"

proc bmEchoResults*(suiteObj: SuiteObj,
    tsArray: openarray[TestStats]) =
  ## Echo to the console the results of a run. To override
  ## set verbosity = Verbosity.none and then write your own
  ## code in teardown.
  var
    tsArrayIdxStr = ""
    idx = 0
  for ts in tsArray:
    var s = suiteObj.fullName & ":"
    if tsArray.len > 1:
      tsArrayIdxStr = "[" & $idx & "]"
    if NRML(suiteObj):
      s &= " ts" & tsArrayIdxStr & "=" &
          "{min=" & cyclesToStr(suiteObj, ts.min) &
          " mean=" & cyclesToStr(suiteObj, ts.mean) &
          " minC=" & $ts.minC &
          " n=" & $ts.n & "}"
    else:
      s &= " ts=" & bmStatsToStr(suiteObj, ts)
    echo s
    idx += 1

proc bmWarmupCpu*(suiteObj: SuiteObj, seconds: float) =
  ## Warmup the cpu so its running at its highest clock rate
  var
    tsa: array[0..0, TestStats]
    v: int
  if DBGV(suiteObj): echo "bmWarmupCup:+"
  measureSecs(suiteObj, seconds, tsa, inc(v))
  if DBGV(suiteObj): echo "bmWarmupCup:-"

template suite*(nameSuite: string, warmupSeconds: float,
    bmSuiteBody: stmt): stmt {.immediate.} =
  ## Begin a benchmark suite. May contian one or more of setup, teardown,
  ## test, these are detailed below:
  ##::
  ##  var suiteObj {.inject.}: SuiteObj
  ##  ## Suite object
  ##::
  ##  template setup*(setupBody: stmt): stmt {.immediate.} =
  ##    ## This is executed prior to each test
  ##::
  ##  template teardown*(teardownBody: stmt): stmt {.immediate.} =
  ##    ## This is executed after to each test
  ##::
  ##  template test*(name string, loopCount: int,
  ##                   tsArray: var openarray[TestStats],
  ##                   testBody: stmt): stmt {.dirty.} =
  ##    ## Run the testBody loopCount * tsArray.len times. Upon termination
  ##    ## tsArray contains the results.
  ##::
  ##  template test*(name string, loopCount: int,
  ##                   ts: var TestStats,
  ##                   testBody: stmt): stmt {.dirty.} =
  ##    ## Run the testBody loopCount times. Upon termination ts
  ##    ## contains the result.
  ##::
  ##  template test*(name string, seconds: float,
  ##                   tsArray: var openarray[TestStats],
  ##                   testBody: stmt): stmt {.dirty.} =
  ##    ## Run the testBody in a loop for seconds and the number of loops will be
  ##    ## modulo the length of tsArray. Upon termination tsArray contiains
  ##    ## the results.
  ##::
  ##  template test*(name string, seconds: float,
  ##                   ts: var TestStats,
  ##                   testBody: stmt): stmt {.dirty.} =
  ##    ## Run the testBody in a loop for seconds and the number of loops will be
  ##    ## modulo the length of tsArray with ts containing the results.
  block:
    var
      suiteObj {.inject.}: SuiteObj
      tsa: array[0..0, TestStats]

    # Initialize suiteObj
    suiteObj.suiteName = nameSuite
    suiteObj.overhead = 0
    suiteObj.verbosity = bmDefaultVerbosity
    suiteObj.hasRDTSCP = hasRDTSCP()
    suiteObj.cyclesToSecThreshold = DEFAULT_CYCLES_TO_SEC_THRESHOLD
    suiteObj.cyclesPerSec = cyclesPerSecond(suiteObj)

    # Warmup the CPU
    bmWarmupCpu(suiteObj, warmupSeconds)

    # Measure overhead
    measureSecs(suiteObj, DEFAULT_OVERHEAD_RUNTIME, tsa, (discard))
    suiteObj.overhead = tsa[0].min
    if DBGV(suiteObj): echo "suiteObj", suiteObj


    # The implementation of setup/teardown when invoked by test
    template setupImpl*: stmt = discard
    template teardownImpl*: stmt = discard

    template setup*(setupBody: stmt): stmt {.immediate.} =
      ## This is executed prior to each test
      template setupImpl*: stmt = setupBody

    template teardown*(teardownBody: stmt): stmt {.immediate.} =
      ## This is executed after to each test
      template teardownImpl*: stmt = teardownBody

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test*(name: string, loopCount: int,
                     tsArray: var openarray[TestStats],
                     testBody: stmt): stmt {.dirty.} =
      ## Run the testBody loopCount * tsArray.len times. Upon termination
      ## tsArray contains the results.
      block:
        try:
          suiteObj.testName = name
          suiteObj.fullName = suiteObj.suiteName & "." & suiteObj.testName
          tsArray.zero()
          setupImpl()
          measureLoops(suiteObj, loopCount, tsArray, testBody)
        except:
          if NRML(suiteObj):
            echo "test ", suiteObj.fullName &
              ": exception=", getCurrentExceptionMsg()
        finally:
          teardownImpl()
          bmEchoResults(suiteObj, tsArray)

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test*(name: string, loopCount: int,
        ts: var TestStats, testBody: stmt): stmt {.dirty.} =
      ## Run the testBody loopCount times. Upon termination ts
      ## contains the result.
      block:
        var tsArray: array[0..0, TestStats]
        test(name, loopCount, tsArray, testBody)
        ts = tsArray[0]

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test*(name: string, seconds: float,
        tsArray: var openarray[TestStats], testBody: stmt): stmt {.dirty.} =
      ## Run the testBody in a loop for seconds and the number of loops will be
      ## modulo the length of tsArray. Upon termination tsArray contiains
      ## the results.
      block:
        try:
          suiteObj.testName = name
          suiteObj.fullName = suiteObj.suiteName & "." & suiteObj.testName
          tsArray.zero()
          setupImpl()
          measureSecs(suiteObj, seconds, tsArray, testBody)
        except:
          if NRML(suiteObj):
            echo "test ", suiteObj.fullName,
              ": exception=", getCurrentExceptionMsg()
        finally:
          teardownImpl()
          if NRML(suiteObj):
            bmEchoResults(suiteObj, tsArray)

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test*(name: string, seconds: float, ts: var TestStats,
        testBody: stmt): stmt {.dirty.} =
      ## Run the testBody in a loop for seconds and the number of loops will be
      ## modulo the length of tsArray with ts containing the results.
      block:
        var tsArray: array[0..0, TestStats]
        test(name, seconds, tsArray, testBody)
        ts = tsArray[0]

    # Instanitate the suite body
    bmSuiteBody

when isMainModule:
  import unittest as ut

  proc unpackIntToStr(val: int, strg: var string) =
    var value = val
    for byteIdx in 0..3:
      strg.add(cast[char](value and 0xFF))
      value = value shr 8

  ut.suite "cpuid and rdtsc":
    test "cpuid 0x0":
      ## Input: EAX=0
      ## Return:
      ##   CpuId.eax = largest standard function number 
      ##   CpuId.ebx, ecx, edx = Processor Vendor
      ##     Intel: ebx=0x756E_6547 ecx=0x6C65_746E edx=0x4965_6E69
      ##     Amd:   ebx=0x6874_7541 ecx=0x444D_4163 edx=0x6974_6E65
      var id = cpuid(0)
      checkpoint("cpuid 0x0: id=" & $id)
      check(id.eax <= 0x20)
      check(id.ebx == 0x756E_6547 or id.ebx == 0x6874_7541)
      check(id.ecx == 0x6C65_746E or id.ecx == 0x444D_4163)
      check(id.edx == 0x4965_6E69 or id.edx == 0x6974_6E65)

    test "cpuid processor name":
      ## Verify that we can get a processor name thats reasonable
      var
        id: CpuId
        strg = ""

      for eax in 0x8000_0002..0x8000_0004:
        id = cpuid(eax)
        unpackIntToStr(id.eax, strg)
        unpackIntToStr(id.ebx, strg)
        unpackIntToStr(id.ecx, strg)
        unpackIntToStr(id.edx, strg)

      # This isn't much of a check but something
      check(strg.startsWith("Intel") or (strg.len > 0 and strg.len < 48))

    test "cpuid 0x80000001 feature bits":
      ## Test feature bits which is used to look for RDTSCP instruction
      var id = cpuid(0x80000001)
      var resultsStr = "cpuid 0x80000001 id=" & $id
      echo resultsStr
      checkpoint(resultsStr)

    test "mfence":
      ## test mfence
      mfence()

    test "cpuid ax, cx param":
      ## TODO: Devise a real test for cpuid with two parameters
      discard cpuid(0x8000_001D, 0)

  ut.suite "test benchmark":
    ## Some simple tests
    ut.test "suite":

      suite "loop", 1.0:
        var
          ts: TestStats
          loops = 0
          setupCalled = 0
          teardownCalled = 0

        setup:
          loops = 0
          setupCalled += 1

        teardown:
          teardownCalled += 1

        test "loop 1", 1, ts:
          check(setupCalled == 1)
          check(teardownCalled == 0)
          loops += 1
        checkpoint(suiteObj.fullName & ": ts=" & $ts)
        check(loops == 1)
        check(setupCalled == 1)
        check(teardownCalled == 1)
        check(ts.n == 1)
        check(ts.min >= 0.0)

        test "loop 2", 2, ts:
          check(setupCalled == 2)
          check(teardownCalled == 1)
          loops += 1
        checkpoint(suiteObj.fullName & ": ts=" & $ts)
        check(loops == 2)
        check(setupCalled == 2)
        check(teardownCalled == 2)
        check(ts.n == 2)
        check(ts.min >= 0.0)

      suite "time", 0.0:
        var
          ts: TestStats
          loops = 0
          setupCalled = 0
          teardownCalled = 0

        setup:
          loops = 0
          setupCalled += 1

        teardown:
          teardownCalled += 1

        test "+=1 0.001 secs", 0.001, ts:
          loops += 1
          check(setupCalled == 1)
          check(teardownCalled == 0)

        checkpoint(suiteObj.fullName & ": ts=" & $ts)
        check(loops > 100)
        check(setupCalled == 1)
        check(teardownCalled == 1)
        check(ts.n > 1)
        check(ts.min >= 0.0)

      suite "test time", 0:
        var
          ts: TestStats
          loops = 0
          setupCalled = 0
          teardownCalled = 0

        setup:
          loops = 0
          setupCalled += 1

        teardown:
          suiteObj.verbosity = Verbosity.debug
          teardownCalled += 1

        test "atomicInc 2 secs", 2.0, ts:
          atomicInc(loops)
          check(setupCalled == 1)
          check(teardownCalled == 0)

        checkpoint(suiteObj.fullName & ": ts=" & $ts)
        check(loops > 100)
        check(setupCalled == 1)
        check(teardownCalled == 1)
