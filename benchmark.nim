## Benchmark will measure the time it takes for some arbitrary
## code to excute in the body of templates bmLoop or bmTime.
## The templates bmLoop takes name, loopCount, var BmStats/array BmStats,
## and the body to run.The templates come in two variants one takes a single BmStats
## take an array of BmStats and N runs of the body
## will be sorted in ascending order by the time the run took.
## This produces a set of bins for analyzing the run with the first
## element of the array contains statistics for the fastest runs
## and the last element the slowest.
##
## This give you a good overview of the spread of the performance
## as it is very difficult to get consistent data on modern computers
## where there is a lot of contention for resources. Such as interrupts
## mutliple cores both logical and physical, multiple threads,
## migration of threads to different cores, the list is endless.
##
## The measurement is in cycles as defined by the CPU, on an X86
## the RDTSC instruction is used to read the value and the routine
## cyclesPerSecond will return the approximate frequency.
##
## Example use with the following code in t1.nim:
##::
## $ cat examples/bmrun.nim
## import benchmark
## 
## bmSuite "testing atomicInc", 1.0:
##   var bmsArray: array[0..2, BmStats]
##   var loops = 0
## 
##   bmSetup:
##     # Start with normal verbosity
##     verbosity = Verbosity.normal
##     loops = 0
## 
##   bmTeardown:
##     # Setting verbosity to dbg outputs the bmsArray
##     verbosity = Verbosity.dbg
##    
##   bmLoop "loop 10 times", 10, bmsArray:
##     atomicInc(loops)
## 
##   bmTime "run 0.5 seconds", 0.5, bmsArray:
##     atomicInc(loops)
##    
## And then compiling and running in debug mode we see
## lots of jitter with long times and cycles. Also note
## that with the faster buckets we see small values of
## minC and maxC:
##
##  wink@desktop:~/prgs/nim/benchmark$ nim c -r --hints:off examples/bmrun.nim
##  [Linking]
##  /home/wink/prgs/nim/benchmark/examples/bmrun 
##  [cycles:115.0 time=3.486918065818314e-08] testing atomicInc.loop 10 times runStat={n=10 sum=1198.0 min=115.0 minC=1 max=124.0 maxC=1 mean=119.8}
##  [cycles:119.0 time=3.608202172455472e-08] testing atomicInc.loop 10 times runStat={n=10 sum=1237.0 min=119.0 minC=1 max=128.0 maxC=2 mean=123.7}
##  [cycles:120.0 time=3.638523199114762e-08] testing atomicInc.loop 10 times runStat={n=10 sum=1411.0 min=120.0 minC=1 max=206.0 maxC=1 mean=141.1}
##  [cycles:104.0 time=3.153386772566127e-08] testing atomicInc.run 0.5 seconds runStat={n=195655 sum=23052666.0 min=104.0 minC=2 max=204.0 maxC=1 mean=117.8230354450431}
##  [cycles:108.0 time=3.274670879203286e-08] testing atomicInc.run 0.5 seconds runStat={n=195655 sum=23459211.0 min=108.0 minC=4 max=244.0 maxC=1 mean=119.900902098081}
##  [cycles:116.0 time=3.517239092477603e-08] testing atomicInc.run 0.5 seconds runStat={n=195655 sum=23991788.0 min=116.0 minC=2910 max=21736.0 maxC=1 mean=122.6229230022219}
##
##
## And then compiling and running in release mode we see
## much higher performance and less jitter:
##
##  $ nim c -r -d:release --hints:off examples/bmrun.nim
##  [Linking]
##  /home/wink/prgs/nim/benchmark/examples/bmloop 
##  [cycles:32.0 time=9.702678670773822e-09] testing atomicInc.loop 10 times runStat={n=10 sum=320.0 min=32.0 minC=10 max=32.0 maxC=10 mean=32.0}
##  [cycles:32.0 time=9.702678670773822e-09] testing atomicInc.loop 10 times runStat={n=10 sum=324.0 min=32.0 minC=9 max=36.0 maxC=1 mean=32.4}
##  [cycles:32.0 time=9.702678670773822e-09] testing atomicInc.loop 10 times runStat={n=10 sum=340.0 min=32.0 minC=5 max=36.0 maxC=5 mean=34.0}
##  [cycles:32.0 time=9.702678670773822e-09] testing atomicInc.run 0.5 seconds runStat={n=344361 sum=11025916.0 min=32.0 minC=342784 max=40.0 maxC=14 mean=32.01848060610886}
##  [cycles:32.0 time=9.702678670773822e-09] testing atomicInc.run 0.5 seconds runStat={n=344361 sum=11182460.0 min=32.0 minC=303729 max=44.0 maxC=6 mean=32.47307331550373}
##  [cycles:32.0 time=9.702678670773822e-09] testing atomicInc.run 0.5 seconds runStat={n=344361 sum=11882580.0 min=32.0 minC=132082 max=12548.0 maxC=1 mean=34.50617230174199}
##
##    runStat.n    = Number of loops
##    runStat.sum  = sum of the time for each loop in cycles
##    runStat.min  = The cycles needed for the fastest loop
##    runStat.minC = The number of data points that were == min
##    runStat.max  = The cycles needed for the slowest loop
##    runStat.maxC = The number of data points that were == max
##    runStat.mean = bms.sum / bms.n
##
##

# The use of cpuid, rtsc, rtsp is modeled from Intel document titled
#   "How to Benchmark Code Execution Times on Intel IA-32
#   and IA-64 Instruction Set Architectures"
# Here is a short link to that document: http://goo.gl/tzKu65

import algorithm, math, times, os, posix, strutils
export math, algorithm

const
  DEFAULT_CPS_RUNTIME = 0.25

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
  # RunningStat with and minC and maxC
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
  for i in 0..bmsArray.len-1:
    zero(bmsArray[i])

proc push*(s: var BmStats, x: float) =
  ## pushes a value `x` for processing
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
  ## pushes a value `x` for processing. `x` is simply converted to ``float``
  ## and the other push operation is called.
  push(s, toFloat(x))
  
proc variance*(s: BmStats): float =
  ## computes the current variance of `s`
  if s.n > 1: result = s.newS / (toFloat(s.n - 1))

proc standardDeviation*(s: BmStats): float =
  ## computes the current standard deviation of `s`
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

proc cyclesPerSecond*(seconds: float = DEFAULT_CPS_RUNTIME): float =
  ## Call cps several times to maximize the chance
  ## of getting a good value
  for i in 0..2:
    result = cps(seconds)
    if result > 0.0:
      return result
  result = -1.0

template measure(verbosity: Verbosity, durations: var openarray[float], bmsArray: var openarray[BmStats], body: stmt): bool =
  var
    ok: bool = true
    tscAuxInitial: int
    tscAuxNow: int
    bc : int64
    ec : int64

  if DBG(verbosity): echo "measure: loopCount=", bmsArray.len

  discard initializeCycles(tscAuxInitial)
  for i in 0..bmsArray.len-1:
    bc = getBegCycles()
    body
    ec = getEndCycles(tscAuxNow)
    durations[i] = float(ec - bc)
    if DBGV(verbosity): echo "duration[", i, "]=", durations[i], " ec=", float(ec), " bc=", float(bc)
    if tscAuxInitial != tscAuxNow:
      # Switched CPU we can't trust rdtsc
      if NRM(verbosity): echo "bad tscAuxNow=0x", toHex(tscAuxNow, 4), " != tscAuxInitial=0x", toHex(tscAuxInitial, 4)
      ok = false;
      break
  if ok:
    sort(durations, system.cmp[float])
    for i in 0..bmsArray.len-1:
      bmsArray[i].push(durations[i])
  ok

template measureSecs(seconds: float, verbosity: Verbosity, bmsArray: var openarray[BmStats], body: stmt) =
  ## Meaure the execution time of body for seconds period of time
  ## returning the array of BmStats for the loop timings. If
  if DBG(verbosity): echo "measureSecs: seconds=", seconds

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
    if not measure(verbosity, durations, bmsArray, body):
      if DBG(verbosity): echo "echo measureSecs: bad measurement"
    cur = epochTime()

template measureLoops(loopCount: int, verbosity: Verbosity, bmsArray: var openarray[BmStats], body: stmt) =
  ## Meaure the execution time of body for seconds period of time
  ## returning the array of BmStats for the loop timings. If
  if DBG(verbosity): echo "measureLoops: loopCount=", loopCount

  var
    durations = newSeq[float](bmsArray.len)

  for i in 0..loopCount-1:
    if not measure(verbosity, durations, bmsArray, body):
      if DBG(verbosity): echo "echo measureLoops: bad measurement"

proc secondsToString*(seconds: float): string =
  ## Convert seconds to string with suffix if possible
  var
    suffixArray = @["s", "ms", "us", "ns", "ps"]
    adjSeconds = seconds

  for suffix in suffixArray:
    if adjSeconds >= 1.0:
      return formatFloat(adjSeconds, ffDecimal, 3) & suffix
    adjSeconds *= 1.0e3
  result = formatFloat(seconds, ffScientific, 4)

proc cyclesToString*(cycles: float): string =
  ## Convert cycles to an interger string if <= 1,000,000
  if cycles >= 0.0 and cycles <= 1_000_000.0:
    result = $round(cycles)
  else:
    result = formatFloat(cycles, ffScientific, 3)

proc bmEchoResults(bms: BmStats, verbosity: Verbosity,
                   suiteName: string, runName: string, cyclesPerSec: float) =
  ## Echo to the console the results of a run. To override
  ## set verbosity = Verbosity.none and then write your own
  ## code in bmTeardown.
  var
    s = "[cycles:" & cyclesToString(bms.min) &
      " time=" & secondsToString(bms.min / cyclesPerSec) & "] " &
      suiteName & "." & runName & " bmStats=" & $bms
  #if DBG(verbosity): s = s & " bmStats=" & $bms
  echo s

proc bmWarmupCpu*(seconds: float) =
  var
    bmsa: array[0..0, BmStats]
    v: int
  measureSecs(seconds, Verbosity.none, bmsa, inc(v))

template bmSuite*(nameSuite: string, warmupSeconds: float, bmSuiteBody: stmt): stmt {.immediate.} =
  ## Begin a benchmark suite. May contian one or more of bmSetup, bmTeardown,
  ## bmTime, bmLoop.  which are detailed below:
  ##::
  ##  let suiteName: string
  ##  ## The name of the suite
  ##::
  ##  let runName: string
  ##  ## The name of the bmLoop or bmTime run
  ##::
  ##  var verbosity: Verbosity
  ##  ## The current verbosity level
  ##::
  ##  var cyclesPerSec: float
  ##::
  ##  template bmSetup*(bmSetupBody: stmt): stmt {.immediate.} =
  ##    ## This is executed prior to each bmTime or bmLoop
  ##::
  ##  template bmTeardown*(bmTeardownBody: stmt): stmt {.immediate.} =
  ##    ## This is executed after to each bmTime or bmLoop
  ##::
  ##  template bmLoop*(nameRun: string, loopCount: int,
  ##                   bms: var BmStats,
  ##                   runBody: stmt): stmt {.dirty.} =
  ##  template bmLoop*(nameRun: string, loopCount: int,
  ##                   bmsArray: var openarray[BmStats],
  ##                   runBody: stmt): stmt {.dirty.} =
  ##    ## Run the runBody loopCount * bmsArray.len times.
  ##::
  ##  template bmTime*(nameRun: string, seconds: float,
  ##                   bms: var BmStats,
  ##                   runBody: stmt): stmt {.dirty.} =
  ##  template bmTime*(nameRun: string, seconds: float,
  ##                   bmsArray: var openarray[BmStats],
  ##                   runBody: stmt): stmt {.dirty.} =
  ##    ## Run the runBody in a loop for seconds and the number of loops will be
  ##    ## modulo the length of bmsArray.
  block:
    let
      suiteName {.inject.} = nameSuite
    var
      verbosity {.inject.} = Verbosity.normal
      cyclesPerSec {.inject.} = cyclesPerSecond()

    bmWarmupCpu(warmupSeconds)

    # The implementation of setup/teardown when invoked by bmTime
    template bmSetupImpl*: stmt = discard
    template bmTeardownImpl*: stmt = discard

    template bmSetup(bmSetupBody: stmt): stmt {.immediate.} =
      ## This is executed prior to each bmTime or bmLoop
      template bmSetupImpl*: stmt = bmSetupBody

    template bmTeardown(bmTeardownBody: stmt): stmt {.immediate.} =
      ## This is executed after to each bmTime or bmLoop
      template bmTeardownImpl*: stmt = bmTeardownBody

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmLoop*(nameRun: string, loopCount: int,
                     bmsArray: var openarray[BmStats],
                     runBody: stmt): stmt {.dirty.} =
      ## Run the runBody loopCount * bmsArray.len times.
      block:
        let runName {.inject.} = nameRun
        try:
          bmsArray.zero()
          bmSetupImpl()
          measureLoops(loopCount, verbosity, bmsArray, runBody)
        except:
          if NRM(verbosity):
            echo "bmLoop ", suiteName, ".", runName,
              ": exception=", getCurrentExceptionMsg()
        finally:
          bmTeardownImpl()
          if NRM(verbosity):
            for i in 0..bmsArray.len-1:
              bmEchoResults(bmsArray[i], verbosity, suiteName, runName, cyclesPerSec)

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmLoop*(nameRun: string, loopCount: int, bms: var BmStats, runBody: stmt): stmt {.dirty.} =
      block:
        var bmsArray: array[0..0, BmStats]
        bmLoop(nameRun, loopCount, bmsArray, runBody)
        bms = bmsArray[0]

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmTime*(nameRun: string, seconds: float,
                     bmsArray: var openarray[BmStats],
                     runBody: stmt): stmt {.dirty.} =
      ## Run the runBody in a loop for seconds and the number of loops will be
      ## modulo the length of bmsArray.
      block:
        var runName {.inject.} = nameRun
        try:
          bmsArray.zero()
          bmSetupImpl()
          measureSecs(seconds, verbosity, bmsArray, runBody)
        except:
          if NRM(verbosity):
            echo "bmTime ", suiteName, ".", runName,
              ": exception=", getCurrentExceptionMsg()
        finally:
          bmTeardownImpl()
          if NRM(verbosity):
            for i in 0..bmsArray.len-1:
              bmEchoResults(bmsArray[i], verbosity, suiteName, runName, cyclesPerSec)

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmTime*(nameRun: string, seconds: float, bms: var BmStats, runBody: stmt): stmt {.dirty.} =
      block:
        var bmsArray: array[0..0, BmStats]
        bmTime(nameRun, seconds, bmsArray, runBody)
        bms = bmsArray[0]

    # Instanitate the suite body
    bmSuiteBody

when isMainModule:
  import unittest

  proc unpackIntToStr(val: int, strg: var string) =
    var value = val
    for byteIdx in 0..3:
      strg.add(cast[char](value and 0xFF))
      value = value shr 8

  suite "cpuid and rdtsc":
    test "cpuid 0x0":
      ## Input: EAX=0
      ## Return:
      ##   CpuId.eax = largest standard function number 
      ##   CpuId.ebx, ecx, edx = Processor Vendor
      ##     Intel: ebx=0x756E_6547 ecx=0x6C65_746E edx=0x4965_6E69
      ##     Amd:   ebx=0x6874_7541 ecx=0x444D_4163 edx=0x6974_6E65
      var id = cpuid(0)
      checkpoint("id=" & $id)
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

      # This isn't much of a check but something.Intel is correct not sure about AMD
      check(strg.startsWith("Intel") or (strg.len > 0 and strg.len < 48))

    test "cpuid ax, cx param":
      ## TODO: Devise a real test for cpuid with two parameters
      discard cpuid(0x8000_001D, 0)

    test "cyclesPerSecond":
      var cycles = cyclesPerSecond(0.25)
      check(cycles > 0)

  suite "test bm":
    ## Some simple tests
    test "bmSuite":

      bmSuite "bmLoop", 1.0:
        var
          bms: BmStats
          loops = 0
          bmSetupCalled = 0
          bmTearDownCalled = 0

        bmSetup:
          loops = 0
          bmSetupCalled += 1

        bmTearDown:
          bmTearDownCalled += 1

        bmLoop "loop 1", 1, bms:
          check(bmSetupCalled == 1)
          check(bmTearDownCalled == 0)
          loops += 1
        checkpoint("loop 1 bms=" & $bms)
        check(loops == 1)
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 1)
        check(bms.n == 1)
        check(bms.min >= 0.0)

        bmLoop "loop 2", 2, bms:
          check(bmSetupCalled == 2)
          check(bmTearDownCalled == 1)
          loops += 1
        checkpoint("loop 2 bms=" & $bms)
        check(loops == 2)
        check(bmSetupCalled == 2)
        check(bmTearDownCalled == 2)
        check(bms.n == 2)
        check(bms.min >= 0.0)

      bmSuite "bmTime", 0.0:
        var
          bms: BmStats
          loops = 0
          bmSetupCalled = 0
          bmTearDownCalled = 0

        bmSetup:
          loops = 0
          bmSetupCalled += 1

        bmTearDown:
          bmTearDownCalled += 1

        bmTime "run 0.001 seconds ", 0.001, bms:
          loops += 1
          check(bmSetupCalled == 1)
          check(bmTearDownCalled == 0)

        checkpoint("run 0.001 seconds bms=" & $bms)
        check(loops > 100)
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 1)
        check(bms.n > 1)
        check(bms.min >= 0.0)

      bmSuite "bmTime", 0:
        var
          bmStats: BmStats
          loops = 0
          bmSetupCalled = 0
          bmTearDownCalled = 0

        bmSetup:
          loops = 0
          bmSetupCalled += 1

        bmTearDown:
          verbosity = Verbosity.dbg
          bmTearDownCalled += 1

        bmTime "run 2 seconds", 2.0, bmStats:
          atomicInc(loops)
          check(bmSetupCalled == 1)
          check(bmTearDownCalled == 0)

        check(loops > 100)
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 1)
