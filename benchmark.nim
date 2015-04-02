## Benchmark will measure the duration it takes for some arbitrary
## code to excute in the body of the test templates and returns
## the information for the runs in BmStats var parameter.
##
## There are  versions of the test templates you can specify
## the number of loops or how long to execute the body. In addition
## you can specify a single BmStats var parameter or a set of them
## in an array. Also, if a loop count is specified and N BmStats
## are passed in then the body will be executed loop count * N
## time.
## 
## As mentioned the number of statistic buckets is defined by the
## BmStats parameter. The duration of the sub runs are sorted from
## fastest to slowest and pushed into the corresponding BmStats entry.
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
## number of cycles is less-than BmSuiteObj.cyclesToSecThreshold or
## time ("s", "ms", ## "us", "ps") if greater-than.
##
## Example use with exmpl/bminc.nim
##::
## $ cat examples/bminc.nim
## import benchmark
## 
## bmSuite "increment", 0.0:
##   var
##     bms: BmStats
##     loops = 0
## 
##   bmTime "inc", 0.5, bms:
##     inc(loops)
## 
##   bmTime "atomicInc", 0.5, bms:
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
## increment.inc: bms={min=50cy mean=78cy minC=1 n=452276}
## increment.atomicInc: bms={min=48cy mean=81cy minC=1 n=431060}

## So lets make two changes to the code we'll change the warmup
## time for bmSuite from 0.0 to 1.0 second. And we'll change
## bms to an array of 5 BmStats rather than just one.
##:: 
## $ cat exmpl/bminc2.nim
## bmSuite "increment", 1.0:
##   var
##     bms: array[0..4, BmStats]
##     loops = 0
## 
##   bmTime "inc", 0.5, bms:
##     inc(loops)
## 
##   bmTime "atomicInc", 0.5, bms:
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
## increment.inc: bms[0]={min=50cy mean=74cy minC=2 n=169482}
## increment.inc: bms[1]={min=52cy mean=78cy minC=45 n=169482}
## increment.inc: bms[2]={min=52cy mean=80cy minC=1 n=169482}
## increment.inc: bms[3]={min=56cy mean=81cy minC=10 n=169482}
## increment.inc: bms[4]={min=68cy mean=91cy minC=76 n=169482}
## increment.atomicInc: bms[0]={min=48cy mean=71cy minC=2 n=175137}
## increment.atomicInc: bms[1]={min=52cy mean=73cy minC=61 n=175137}
## increment.atomicInc: bms[2]={min=52cy mean=76cy minC=3 n=175137}
## increment.atomicInc: bms[3]={min=54cy mean=78cy minC=1 n=175137}
## increment.atomicInc: bms[4]={min=68cy mean=84cy minC=3780 n=175137}# 

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
## increment.inc: bms[0]={min=138cy mean=164cy minC=2 n=116542}
## increment.inc: bms[1]={min=146cy mean=165cy minC=26 n=116542}
## increment.inc: bms[2]={min=148cy mean=167cy minC=48 n=116542}
## increment.inc: bms[3]={min=150cy mean=170cy minC=2 n=116542}
## increment.inc: bms[4]={min=152cy mean=183cy minC=1 n=116542}
## increment.atomicInc: bms[0]={min=150cy mean=177cy minC=1 n=115241}
## increment.atomicInc: bms[1]={min=158cy mean=180cy minC=37 n=115241}
## increment.atomicInc: bms[2]={min=158cy mean=183cy minC=1 n=115241}
## increment.atomicInc: bms[3]={min=160cy mean=185cy minC=1 n=115241}
## increment.atomicInc: bms[4]={min=170cy mean=194cy minC=254 n=115241}

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
## increment.inc: bms[0]={min=16cy mean=18cy minC=314358 n=390304}
## increment.inc: bms[1]={min=16cy mean=20cy minC=256916 n=390304}
## increment.inc: bms[2]={min=16cy mean=22cy minC=151829 n=390304}
## increment.inc: bms[3]={min=16cy mean=27cy minC=65869 n=390304}
## increment.inc: bms[4]={min=16cy mean=30cy minC=16848 n=390304}
## increment.atomicInc: bms[0]={min=26cy mean=31cy minC=116704 n=355885}
## increment.atomicInc: bms[1]={min=26cy mean=37cy minC=12701 n=355885}
## increment.atomicInc: bms[2]={min=26cy mean=42cy minC=986 n=355885}
## increment.atomicInc: bms[3]={min=26cy mean=44cy minC=2 n=355885}
## increment.atomicInc: bms[4]={min=28cy mean=48cy minC=2733 n=355885}

# The use of cpuid, rtsc, rtsp is modeled from Intel document titled
#   "How to Benchmark Code Execution Times on Intel IA-32
#   and IA-64 Instruction Set Architectures"
# Here is a short link to that document: http://goo.gl/tzKu65

import algorithm, math, times, os, posix, strutils
export math, algorithm

# forward decls
#proc secToStr*(seconds: float): string
#proc cyclesToStr*(cycles: float, cps: float): string

const
  DEFAULT_CPS_RUNTIME = 0.25
  DEFAULT_CYCLES_TO_SEC_THRESHOLD = 1_000.0

type
  Verbosity* {.pure.} = enum  ## Logging verbosity
    none = -1                 ## Nothing output
    normal = 0                ## Normal outout at end of run
    dbg = 1                   ## Additional debug output
    dbgv = 2                  ## Copious output

proc NONE*(verbosity: Verbosity): bool {.inline.} =
  ## Return true if Verbosity == Verbosity.none
  result = verbosity == Verbosity.normal

proc NRM*(verbosity: Verbosity): bool {.inline.} =
  ## Return true if Verbosity >= Verbosity.normal
  result = verbosity >= Verbosity.normal

proc DBG*(verbosity: Verbosity): bool {.inline.} =
  ## Return true if Verbosity >= Verbosity.dbg
  result = verbosity >= Verbosity.dbg

proc DBGV*(verbosity: Verbosity): bool {.inline.} =
  ## Return true if Verbosity >= Verbosity.dbgv
  result = verbosity >= Verbosity.dbgv

type
  BmStats* = object                     ## Statistical benchmark data
    n*: int                             ## number of data points
    minC*: int                          ## number of data points == min
    maxC*: int                          ## number of data points == max
    sum*, min*, max*, mean*: float      ## self-explaining
    oldM, oldS, newS: float

proc `$`*(s: BmStats): string =
  ## Print the BmStats.
  "{n=" & $s.n & " sum=" & $s.sum & " min=" & $s.min & " minC=" & $s.minC &
    " max=" & $s.max & " maxC=" & $s.maxC & " mean=" & $s.mean & "}"

proc zero*(bms: var BmStats) =
  ## Zero BmStats fields
  bms.n = 0
  bms.minC = 0
  bms.maxC = 0
  bms.sum = 0.0
  bms.min = 0.0
  bms.max = 0.0
  bms.mean = 0.0
  bms.oldM = 0.0
  bms.oldS = 0.0
  bms.newS = 0.0

proc zero*(bmsArray: var openarray[BmStats]) =
  ## Zero an array of BmStats
  for i in 0..bmsArray.len-1:
    zero(bmsArray[i])

proc push*(s: var BmStats, x: float) =
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
  
proc push*(s: var BmStats, x: int) =
  ## Pushes a value `x` for processing. `x` is simply converted to ``float``
  ## and the other push operation is called.
  push(s, toFloat(x))
  
proc variance*(s: BmStats): float =
  ## Computes the current variance of `s`
  if s.n > 1: result = s.newS / (toFloat(s.n - 1))

proc standardDeviation*(s: BmStats): float =
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

proc rdtscp(tscAux: var int): int64 {.inline.} =
  ## Execute the rdtscp, read Time Stamp Counter, instruction
  ## returns the 64 bit TSC value and writes to ecx to tscAux value.
  ## The tscAux value is the logical cpu number and can be used
  ## to determine if the thread migrated to a different cpu and
  ## thus the returned value is suspect.
  var lo, hi, aux: uint32
  {.emit: """
    asm volatile (
      "rdtscp\n\t"
      :"=a"(`lo`), "=d"(`hi`), "=c"(`aux`));
  """.}
  tscAux = cast[int](aux)
  result = int64(lo) or (int64(hi) shl 32)

proc getBegCycles(): int64 {.inline.} =
  ## Return TSC to be used at the beginning of the measurement.
  cpuid()
  result = rdtsc()

proc getEndCycles(): int64 {.inline.} =
  ## Return TSC to be used at the end of the measurement.
  result = rdtscp()
  cpuid()

proc getEndCycles(tscAux: var int): int64 {.inline.} =
  ## Return TSC to be used at the end of the measurement
  ## and write ecx to tscAux. The tscAux value is the
  ## logical cpu number and can be used to determine if
  ## the thread migrated to a different cpu and thus the
  ## returned value is suspect.
  result = rdtscp(tscAux)
  cpuid()

proc initializeCycles(tscAux: var int): int {.inline.} =
  ## Initalize as per the ia32-ia64-benchmark document returning
  ## the tsc value as exiting and the tscAux in the var param
  discard getBegCycles()
  discard getEndCycles()
  discard getBegCycles()
  result = cast[int](getEndCycles(tscAux))

proc cyclesPerSecond*(seconds: float = DEFAULT_CPS_RUNTIME): float =
  proc cps(seconds: float): float =
    ## Determine the approximate cycles per second of the TSC.
    ## The seconds parameter is the length of the meausrement.
    ## return a value < 0.0 if unsuccessful. This happens if the
    ## code detects if the thread migrated cpu's.
    const
      DBG = false

    var
      tscAuxInitial: int
      tscAuxNow: int
      start: int
      ec: int
      endTime: float

    endTime = epochTime() + seconds
    start = initializeCycles(tscAuxInitial)
    while epochTime() <= endTime:
      ec = cast[int](getEndCycles(tscAuxNow))
      if tscAuxInitial != tscAuxNow:
        when DBG:
          echo "bad tscAuxNow=0x", toHex(tscAuxNow, 4),
            " != tscAuxInitial=0x", toHex(tscAuxInitial, 4)
        return -1.0
    result = (ec - start).toFloat() / seconds

  ## Call cps several times to maximize the chance
  ## of getting a good value
  for i in 0..2:
    result = cps(seconds)
    if result > 0.0:
      return result
  result = -1.0

type
  BmSuiteObj* = object ## Object associated with a bmSuite
    suiteName: string ## Name of the suite
    testName: string ## Name of the current run
    fullName: string ## Suite and Runame concatonated
    cyclesPerSec: float ## Frequency of cycle counter
    cyclesToSecThreshold: float ## Threshold for displaying cycles or secs
    verbosity: Verbosity ## Verbosity of output
    overhead: float ## number of cycles overhead to be substracted when measuring

template measure(bmso: BmSuiteObj, durations: var openarray[float],
    bmsArray: var openarray[BmStats], body: stmt): bool =
  var
    ok: bool = true
    tscAuxInitial: int
    tscAuxNow: int
    bc : int64
    ec : int64

  if DBG(bmso.verbosity): echo "measure: loopCount=", bmsArray.len

  discard initializeCycles(tscAuxInitial)
  for i in 0..bmsArray.len-1:
    bc = getBegCycles()
    body
    ec = getEndCycles(tscAuxNow)
    var adjDuration = float(ec - bc) - bmso.overhead
    if adjDuration < 0: adjDuration = 0
    durations[i] = adjDuration
    if DBGV(bmso.verbosity):
      echo "duration[", i, "]=", durations[i], " ec=", float(ec), " bc=",
        float(bc)
    if tscAuxInitial != tscAuxNow:
      # Switched CPU we can't trust rdtsc
      if NRM(bmso.verbosity):
        echo "bad tscAuxNow=0x", toHex(tscAuxNow, 4), " != tscAuxInitial=0x",
          toHex(tscAuxInitial, 4)
      ok = false;
      break
  if ok:
    sort(durations, system.cmp[float])
    for i in 0..bmsArray.len-1:
      bmsArray[i].push(durations[i])
  ok

template measureSecs(bmso: BmSuiteObj, seconds: float,
    bmsArray: var openarray[BmStats], body: stmt) =
  ## Meaure the execution time of body for seconds period of time
  ## returning the array of BmStats for the loop timings. If
  if DBG(bmso.verbosity): echo "measureSecs: seconds=", seconds

  var
    durations = newSeq[float](bmsArray.len)
    runDuration = seconds
    start = epochTime()
    cur = start
  # I tried using cycles rather than epoch time but there
  # was not measureable difference in performance and this
  # is simpler because we don't have to pass or calculate
  # the current cycles per second.
  while runDuration > cur - start:
    if not measure(bmso, durations, bmsArray, body):
      if DBG(bmso.verbosity): echo "echo measureSecs: bad measurement"
    cur = epochTime()

template measureLoops(bmso: BmSuiteObj, loopCount: int,
    bmsArray: var openarray[BmStats], body: stmt) =
  ## Meaure the execution time of body for seconds period of time
  ## returning the array of BmStats for the loop timings. If
  if DBG(bmso.verbosity): echo "measureLoops: loopCount=", loopCount

  var
    durations = newSeq[float](bmsArray.len)

  for i in 0..loopCount-1:
    if not measure(bmso, durations, bmsArray, body):
      if DBG(bmso.verbosity): echo "echo measureLoops: bad measurement"

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

proc cyclesToStr*(bmso: BmSuiteObj, cycles: float): string =
  ## Convert cycles to string either as cycles or time
  ## depending upon bmso.cyclesToSecThreshold
  if cycles >=  bmso.cyclesToSecThreshold:
    result = secToStr(cycles / bmso.cyclesPerSec)
  else:
    result = $round(cycles) & "cy"

proc bmStatsToStr*(bmso: BmSuiteObj, s: BmStats): string =
  ## Print the BmStats using cycles per second.
  "{n=" & $s.n &
    " min=" & cyclesToStr(bmso, s.min) &
    " minC=" & $s.minC &
    " max=" & cyclesToStr(bmso, s.max) &
    " maxC=" & $s.maxC &
    " mean=" & cyclesToStr(bmso, s.mean) &
    " sum=" & cyclesToStr(bmso, s.sum) &
    "}"

proc bmEchoResults*(bmso: BmSuiteObj,
    bmsArray: openarray[BmStats]) =
  ## Echo to the console the results of a run. To override
  ## set verbosity = Verbosity.none and then write your own
  ## code in teardown.
  var
    bmsArrayIdxStr = ""
    idx = 0
  for bms in bmsArray:
    var s = bmso.fullName & ":"
    if bmsArray.len > 1:
      bmsArrayIdxStr = "[" & $idx & "]"
    if NRM(bmso.verbosity):
      s &= " bms" & bmsArrayIdxStr & "=" &
          "{min=" & cyclesToStr(bmso, bms.min) &
          " mean=" & cyclesToStr(bmso, bms.mean) &
          " minC=" & $bms.minC &
          " n=" & $bms.n & "}"
    else:
      s &= " bms=" & bmStatsToStr(bmso, bms)
    echo s
    idx += 1

proc bmWarmupCpu*(bmso: BmSuiteObj, seconds: float) =
  ## Warmup the cpu so its running at its highest clock rate
  var
    bmsa: array[0..0, BmStats]
    v: int
  measureSecs(bmso, seconds, bmsa, inc(v))

template suite*(nameSuite: string, warmupSeconds: float,
    bmSuiteBody: stmt): stmt {.immediate.} =
  ## Begin a benchmark suite. May contian one or more of setup, teardown,
  ## bmTime, bmLoop.  which are detailed below:
  ##::
  ##  var bmso {.inject.}: BmSuiteObj
  ##  ## Suite object
  ##::
  ##  template setup*(setupBody: stmt): stmt {.immediate.} =
  ##    ## This is executed prior to each bmTime or bmLoop
  ##::
  ##  template teardown*(teardownBody: stmt): stmt {.immediate.} =
  ##    ## This is executed after to each bmTime or bmLoop
  ##::
  ##  template bmLoop*(nameRun: string, loopCount: int,
  ##                   bmsArray: var openarray[BmStats],
  ##                   testBody: stmt): stmt {.dirty.} =
  ##    ## Run the testBody loopCount * bmsArray.len times. Upon termination
  ##    ## bmsArray contains the results.
  ##  template bmLoop*(nameRun: string, loopCount: int,
  ##                   bms: var BmStats,
  ##                   testBody: stmt): stmt {.dirty.} =
  ##    ## Run the testBody loopCount times. Upon termination bms
  ##    ## contains the result.
  ##::
  ##  template bmTime*(nameRun: string, seconds: float,
  ##                   bmsArray: var openarray[BmStats],
  ##                   timeBody: stmt): stmt {.dirty.} =
  ##    ## Run the timeBody in a loop for seconds and the number of loops will be
  ##    ## modulo the length of bmsArray. Upon termination bmsArray contiains
  ##    ## the results.
  ##  template bmTime*(nameRun: string, seconds: float,
  ##                   bms: var BmStats,
  ##                   timeBody: stmt): stmt {.dirty.} =
  ##    ## Run the timeBody in a loop for seconds and the number of loops will be
  ##    ## modulo the length of bmsArray with bms containing the results.
  block:
    var
      bmso {.inject.}: BmSuiteObj
      bmsa: array[0..0, BmStats]

    # Initialize bmso
    bmso.suiteName = nameSuite
    bmso.cyclesPerSec = cyclesPerSecond()
    bmso.cyclesToSecThreshold = DEFAULT_CYCLES_TO_SEC_THRESHOLD
    bmso.overhead = 0

    # Warmup the CPU
    bmWarmupCpu(bmso, warmupSeconds)

    # Measure overhead
    measureSecs(bmso, 0.25, bmsa, (discard))
    bmso.overhead = bmsa[0].min
    if DBG(bmso.verbosity): echo "bmso.overhead=", bmso.overhead, " bms=", $bmsa[0]

    # The implementation of setup/teardown when invoked by bmTime
    template setupImpl*: stmt = discard
    template teardownImpl*: stmt = discard

    template setup*(setupBody: stmt): stmt {.immediate.} =
      ## This is executed prior to each bmTime or bmLoop
      template setupImpl*: stmt = setupBody

    template teardown*(teardownBody: stmt): stmt {.immediate.} =
      ## This is executed after to each bmTime or bmLoop
      template teardownImpl*: stmt = teardownBody

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test*(nameRun: string, loopCount: int,
                     bmsArray: var openarray[BmStats],
                     testBody: stmt): stmt {.dirty.} =
      ## Run the testBody loopCount * bmsArray.len times. Upon termination
      ## bmsArray contains the results.
      block:
        try:
          bmso.testName = nameRun
          bmso.fullName = bmso.suiteName & "." & bmso.testName
          bmsArray.zero()
          setupImpl()
          measureLoops(bmso, loopCount, bmsArray, testBody)
        except:
          if NRM(bmso.verbosity):
            echo "bmLoop ", bmso.fullName &
              ": exception=", getCurrentExceptionMsg()
        finally:
          teardownImpl()
          bmEchoResults(bmso, bmsArray)

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test*(nameRun: string, loopCount: int,
        bms: var BmStats, testBody: stmt): stmt {.dirty.} =
      ## Run the testBody loopCount times. Upon termination bms
      ## contains the result.
      block:
        var bmsArray: array[0..0, BmStats]
        test(nameRun, loopCount, bmsArray, testBody)
        bms = bmsArray[0]

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test*(nameRun: string, seconds: float,
        bmsArray: var openarray[BmStats], timeBody: stmt): stmt {.dirty.} =
      ## Run the timeBody in a loop for seconds and the number of loops will be
      ## modulo the length of bmsArray. Upon termination bmsArray contiains
      ## the results.
      block:
        try:
          bmso.testName = nameRun
          bmso.fullName = bmso.suiteName & "." & bmso.testName
          bmsArray.zero()
          setupImpl()
          measureSecs(bmso, seconds, bmsArray, timeBody)
        except:
          if NRM(bmso.verbosity):
            echo "bmTime ", bmso.fullName,
              ": exception=", getCurrentExceptionMsg()
        finally:
          teardownImpl()
          if NRM(bmso.verbosity):
            bmEchoResults(bmso, bmsArray)

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test*(nameRun: string, seconds: float, bms: var BmStats,
        timeBody: stmt): stmt {.dirty.} =
      ## Run the timeBody in a loop for seconds and the number of loops will be
      ## modulo the length of bmsArray with bms containing the results.
      block:
        var bmsArray: array[0..0, BmStats]
        test(nameRun, seconds, bmsArray, timeBody)
        bms = bmsArray[0]

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

    test "cpuid ax, cx param":
      ## TODO: Devise a real test for cpuid with two parameters
      discard cpuid(0x8000_001D, 0)

    test "cyclesPerSecond":
      var cycles = cyclesPerSecond(0.25)
      check(cycles > 0)

  ut.suite "test benchmark":
    ## Some simple tests
    ut.test "suite":

      suite "loop", 1.0:
        var
          bms: BmStats
          loops = 0
          setupCalled = 0
          teardownCalled = 0

        setup:
          loops = 0
          setupCalled += 1

        teardown:
          teardownCalled += 1

        test "loop 1", 1, bms:
          check(setupCalled == 1)
          check(teardownCalled == 0)
          loops += 1
        checkpoint(bmso.fullName & ": bms=" & $bms)
        check(loops == 1)
        check(setupCalled == 1)
        check(teardownCalled == 1)
        check(bms.n == 1)
        check(bms.min >= 0.0)

        test "loop 2", 2, bms:
          check(setupCalled == 2)
          check(teardownCalled == 1)
          loops += 1
        checkpoint(bmso.fullName & ": bms=" & $bms)
        check(loops == 2)
        check(setupCalled == 2)
        check(teardownCalled == 2)
        check(bms.n == 2)
        check(bms.min >= 0.0)

      suite "time", 0.0:
        var
          bms: BmStats
          loops = 0
          setupCalled = 0
          teardownCalled = 0

        setup:
          loops = 0
          setupCalled += 1

        teardown:
          teardownCalled += 1

        test "+=1 0.001 secs", 0.001, bms:
          loops += 1
          check(setupCalled == 1)
          check(teardownCalled == 0)

        checkpoint(bmso.fullName & ": bms=" & $bms)
        check(loops > 100)
        check(setupCalled == 1)
        check(teardownCalled == 1)
        check(bms.n > 1)
        check(bms.min >= 0.0)

      suite "bmTime", 0:
        var
          bms: BmStats
          loops = 0
          setupCalled = 0
          teardownCalled = 0

        setup:
          loops = 0
          setupCalled += 1

        teardown:
          bmso.verbosity = Verbosity.dbg
          teardownCalled += 1

        test "atomicInc 2 secs", 2.0, bms:
          atomicInc(loops)
          check(setupCalled == 1)
          check(teardownCalled == 0)

        checkpoint(bmso.fullName & ": bms=" & $bms)
        check(loops > 100)
        check(setupCalled == 1)
        check(teardownCalled == 1)
