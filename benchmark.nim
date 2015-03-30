## Benchmark will measure the time it takes for some arbitrary
## code to excute in the body of templates bmLoop or bmRun.
## These templates use a processr provided instruction, RDTSC on
## X86, to measure the number of cycles necessary to run each
## iteration of the body and reports the results as a RunningStat
## as defined in the nim math module.
##
## Example use with the following code in t1.nim:
##
## ::
## $ cat examples/bmloop.nim
## import benchmark
## 
## bmSuite "testing echo":
##   var rs: RunningStat
##   var loops: int
## 
##   bmSetup:
##     loops = 0
##
##   bmTeardown:
##     echo "rs=", rs
##   
##   bmLoop "loop 10 times", 10, rs:
##     loops += 1
##    
## And then compiling and running with:
##
##::
## $ nim c -r --hints:off examples/bmloop
## [Linking]
## /Users/wink/prgs/nim/benchmark/examples/bmloop
## measureFor: loopCount=10
## duration=148.0 ec=23094928548916.0 bc=23094928548768.0
## duration=102.0 ec=23094928649480.0 bc=23094928649378.0
## duration=82.0 ec=23094928657624.0 bc=23094928657542.0
## duration=84.0 ec=23094928665900.0 bc=23094928665816.0
## duration=80.0 ec=23094928673200.0 bc=23094928673120.0
## duration=90.0 ec=23094928705028.0 bc=23094928704938.0
## duration=58.0 ec=23094928711834.0 bc=23094928711776.0
## duration=88.0 ec=23094928718876.0 bc=23094928718788.0
## duration=88.0 ec=23094928725848.0 bc=23094928725760.0
## duration=88.0 ec=23094928732620.0 bc=23094928732532.0
## [cycles:58.0 time=2.235954291814339e-08] testing echo.loop 10 times runStat={n=10 sum=908.0 min=58.0 max=148.0 mean=90.8}
##
## ::
##    runStat.n    = Number of loops
##    runStat.sum  = sum of the time for each loop in cycles
##    runStat.min  = The cycles needed for the fastest loop
##    runStat.max  = The cycles needed for the slowest loop
##    runStat.mean = rs.sum / rs.n
##
## In addition to bmLoop, where you define the number of loops, the
## bmRun template can be used to run for a specified amount of time.
##
## bmSuite "bmRun example"
##   mb
## there is also
## defining the number of loops to measure, the bmRun template
## can be used to run the body in a loop for a specified period of seconds as
## a floating point number. Or a specified number of machine cycles if ToUsage: bmSuite is a template to define a scope for
## one or more instantiations of bmLoop and bmRun templates. In addition,
## prior to actually running the body of bmLoop or bmRun the template bmSetup
## is invoked and at the conclusion bmTeardown is invoked. See below for
## additional details.
## 
# The use of cpuid, rtsc, rtsp is Intel document titled
#   "How to Benchmark Code Execution Times on Intel IA-32
#   and IA-64 Instruction Set Architectures"
# Here is a short link to the document: http://goo.gl/tzKu65
import algorithm, math, times, os, posix, strutils
export math, algorithm

const
  DEFAULT_CPS_RUNTIME = 0.25

type
  ## The registers returned by cpuid instruction.
  CpuId* = tuple[eax: int, ebx: int, ecx: int, edx: int]

  Verbosity* {.pure.} = enum
    none = -1
    normal = 0
    dbg = 1
    dbgv = 2

proc cyclesPerSecond*(seconds: float = DEFAULT_CPS_RUNTIME): float

var
  gBmCyclesPerSecond* = cyclesPerSecond()

proc NRM(verbosity: Verbosity): bool {.inline.} =
  result = verbosity >= Verbosity.normal

proc DBG(verbosity: Verbosity): bool {.inline.} =
  result = verbosity >= Verbosity.dbg

proc DBGV(verbosity: Verbosity): bool {.inline.} =
  result = verbosity >= Verbosity.dbgv

proc `$`*(r: RunningStat): string =
  ## Print the RunningStat.
  "{n=" & $r.n & " sum=" & $r.sum & " min=" & $r.min & " max=" & $r.max & " mean=" & $r.mean & "}"

proc `$`(cpuid: CpuId): string =
  ## Print the CpuId.
  "{ eax=0x" & toHex(cpuid.eax, 8) & " ebx=0x" & toHex(cpuid.ebx, 8) & " ecx=0x" & toHex(cpuid.ecx, 8) & " edx=0x" & toHex(cpuid.edx, 8) & "}"

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
      when DBG: echo "bad tscAuxNow=0x", toHex(tscAuxNow, 4), " != tscAuxInitial=0x", toHex(tscAuxInitial, 4)
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

proc cyclesToRun*(seconds: float, cpsRunTime: float = DEFAULT_CPS_RUNTIME): int =
  ## Returns the number of cycles that can be passed to bmRun
  ## or -1 if in indeterminate
  var cps = cyclesPerSecond(cpsRunTime)
  if cps < 0.0:
    result = -1
  else:
    result = round(cps * seconds)

template measureFor(cycles: int, verbosity: Verbosity, body: stmt): RunningStat =
  ## Meaure the execution time of body for cycles count of TSC
  ## returning the RunningStat for the loop timings. If
  ## RunningStat.n = -1 and RunningStat.min == -1 then an error occured.
  var
    result: RunningStat
    tscAuxInitial: int
    tscAuxNow: int
    start: int
    bc : int64
    ec : int64

  if DBG(verbosity): echo "measureFor: cycles=", cycles

  start = initializeCycles(tscAuxInitial)
  ec = start
  if DBG(verbosity): echo "start=", start, " tscAuxInitial=0x", toHex(tscAuxInitial, 4)
  while cycles > ec - start:
    # TODO: Make the body of this loop a template
    bc = getBegCycles()
    body
    ec = getEndCycles(tscAuxNow)
    var duration = float(ec - bc)
    if DBGV(verbosity): echo "duration=", duration, " ec=", float(ec), " bc=", float(bc)
    if tscAuxInitial != tscAuxNow:
      # Switched CPU we can't trust rdtsc
      if NRM(verbosity): echo "bad tscAuxNow=0x", toHex(tscAuxNow, 4), " != tscAuxInitial=0x", toHex(tscAuxInitial, 4)
      result.n = -1
      result.min = -1
      break
    if duration < 0.0:
      if NRM(verbosity): echo "ignore duration=", duration, " ec=", float(ec), " bc=", float(bc)
    else:
      result.push(duration)
  result

template measureFor(seconds: float, verbosity: Verbosity, body: stmt): RunningStat =
  ## Meaure the execution time of body for seconds period of time
  ## returning the RunningStat for the loop timings. If
  ## RunningStat.n = -1 and RunningStat.min == -1 then an error occured.
  var
    result: RunningStat
    tscAuxInitial: int
    tscAuxNow: int
    endTime: float
    bc : int64
    ec : int64

  if DBG(verbosity): echo "measureFor: seconds=", seconds

  endTime = epochTime() + seconds
  discard initializeCycles(tscAuxInitial)
  while epochTime() <= endTime:
    # TODO: Make the body of this loop a template
    bc = getBegCycles()
    body
    ec = getEndCycles(tscAuxNow)
    var duration = float(ec - bc)
    if DBGV(verbosity): echo "duration=", duration, " ec=", float(ec), " bc=", float(bc)
    if tscAuxInitial != tscAuxNow:
      # Switched CPU we can't trust rdtsc
      if NRM(verbosity): echo "bad tscAuxNow=0x", toHex(tscAuxNow, 4), " != tscAuxInitial=0x", toHex(tscAuxInitial, 4)
      result.n = -1
      result.min = -1
      break
    if duration < 0.0:
      if DBG(verbosity): echo "ignore duration=", duration, " ec=", float(ec), " bc=", float(bc)
    else:
      result.push(duration)
  result

template measureLoops(loopCount: int, verbosity: Verbosity, body: stmt): RunningStat =
  ## Meaure the execution time of body for seconds period of time
  ## returning the RunningStat for the loop timings. If
  ## RunningStat.n = -1 and RunningStat.min == -1 then an error occured.
  var
    result: RunningStat
    tscAuxInitial: int
    tscAuxNow: int
    bc : int64
    ec : int64

  if DBG(verbosity): echo "measureFor: loopCount=", loopCount

  discard initializeCycles(tscAuxInitial)
  for i in 0..loopCount-1:
    # TODO: Make the body of this loop a template
    bc = getBegCycles()
    body
    ec = getEndCycles(tscAuxNow)
    var duration = float(ec - bc)
    if DBGV(verbosity): echo "duration=", duration, " ec=", float(ec), " bc=", float(bc)
    if tscAuxInitial != tscAuxNow:
      # Switched CPU we can't trust rdtsc
      if NRM(verbosity): echo "bad tscAuxNow=0x", toHex(tscAuxNow, 4), " != tscAuxInitial=0x", toHex(tscAuxInitial, 4)
      result.n = -1
      result.min = -1
      break
    if duration < 0.0:
      if DBG(verbosity): echo "ignore duration=", duration, " ec=", float(ec), " bc=", float(bc)
    else:
      result.push(duration)
  result


template measureX(verbosity: Verbosity, durations: var openarray[float], runStats: var openarray[RunningStat], body: stmt): bool =
  var
    ok: bool = true
    tscAuxInitial: int
    tscAuxNow: int
    bc : int64
    ec : int64

  if DBG(verbosity): echo "measurX: loopCount=", runStats.len

  discard initializeCycles(tscAuxInitial)
  for i in 0..runStats.len-1:
    # TODO: Make the body of this loop a template
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
    for i in 0..runStats.len-1:
      rss[i].push(durations[i])
  ok

template measureForX(seconds: float, verbosity: Verbosity, runStats: var openarray[RunningStat], body: stmt) =
  ## Meaure the execution time of body for seconds period of time
  ## returning the array of RunningStat for the loop timings. If
  ## TODO: errors ????? RunningStat.n = -1 and RunningStat.min == -1 then an error occured.
  if DBG(verbosity): echo "measureForX: seconds=", seconds

  var
    durations = newSeq[float](runStats.len)
    runDuration = seconds
    start = epochTime()
    cur = start
  # I tried using cycles rather than epoch time but there
  # was not measureable difference in performance and this
  # is simpler because we don't have to pass or calculate
  # the current cycles per second.
  while runDuration > cur - start:
    if not measureX(verbosity, durations, runStats, body):
      if DBG(verbosity): echo "echo measureForX: bad measurement"
    cur = epochTime()

proc bmEchoResults(runStat: RunningStat, verbosity: Verbosity,
                   suiteName: string, runName: string, cyclesPerSec: float) =
  ## Echo to the console the results of a run. To override
  ## set verbosity = Verbosity.none and then write your own
  ## code in bmTeardown.
  var s = "[cycles:" & $runStat.min & " time=" & $(runStat.min / cyclesPerSec) & "] " & suiteName & "." & runName
  if DBG(verbosity): s = s & " runStat=" & $runStat
  echo s

template bmSuite*(nameSuite: string, bmSuiteBody: stmt): stmt {.immediate.} =
  ## Begin a benchmark suite. May contian one or more of bmSetup, bmTeardown,
  ## bmRun, bmLoop which are detailed below:
  ##::
  ##  template bmSetup*(bmSetupBody: stmt): stmt {.immediate.} =
  ##    ## This is executed prior to each bmRun or bmLoop
  ##
  ##::
  ##  template bmTeardown*(bmTeardownBody: stmt): stmt {.immediate.} =
  ##    ## This is executed after to each bmRun or bmLoop
  ##
  ##::
  ##  template bmRun*(runName: string, timeOrCycles: expr, runStat: var RunningStat,
  ##    runBody: stmt): stmt
  ##    ## Run the runBody using cycles by using an interger for timeOrCycles or using
  ##    ## time by passing a float in timeOrCycles. Optionally each time bmRun is invoked
  ##    ## it will invoke bmSetup or bmTeardown if they've been overridden.
  ##
  ##::
  ##  template bmLoop*(runName: string, loopCount: int, runStat: var RunningStat,
  ##    runBody: stmt): stmt
  ##    ## Run the runBody loopcount times, optionally each time bmLoop is invoked
  ##    ## it will invoke bmSetup or bmTeardown if they've been overridden.
  ##
  block:
    var
      suiteName {.inject.} = nameSuite
      verbosity {.inject.} = Verbosity.normal
      cyclesPerSec {.inject.} = cyclesPerSecond()

    # TODO: How to make cyclesToSeconds available to bmSuite?
    # For now injecting cyclesPerSec you can at least
    # use that in bmSuite and calculate it your self!
    #proc cyclesToSeconds(cycles: float): float =
    #  result = cycles / cyclesPerSec

    # The implementation of setup/teardown when invoked by bmRun
    template bmSetupImpl*: stmt = discard
    template bmTeardownImpl*: stmt = discard

    template bmSetup(bmSetupBody: stmt): stmt {.immediate.} =
      ## This is executed prior to each bmRun or bmLoop
      template bmSetupImpl*: stmt = bmSetupBody

    template bmTeardown(bmTeardownBody: stmt): stmt {.immediate.} =
      ## This is executed after to each bmRun or bmLoop
      template bmTeardownImpl*: stmt = bmTeardownBody

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmRun(nameRun: string, timeOrCycles: expr, runStat: var RunningStat,
                    runBody: stmt): stmt {.dirty.} =
      ## Run the runBody using cycles by using an interger for timeOrCycles or using
      ## time by passing a float in timeOrCycles. Optionally each time bmRun is invoked
      ## it will invoke bmSetup or bmTeardown if they've been overridden.
      block:
        var runName {.inject.} = nameRun
        #var rslt: RunningStat
        try:
          bmSetupImpl()
          runStat = measureFor(timeOrCycles, verbosity, runBody)
        except:
          if NRM(verbosity): echo "bmRun ", suiteName, ".", runName, ": exception=", getCurrentExceptionMsg()
        finally:
          bmTeardownImpl()
          if NRM(verbosity): bmEchoResults(runStat, verbosity, suiteName, runName, cyclesPerSec)

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmLoop(nameRun: string, loopCount: int, runStat: var RunningStat,
                      runBody: stmt): stmt {.dirty.} =
      ## Run the runBody loopcount times, optionally each time bmLoop is invoked
      ## it will invoke bmSetup or bmTeardown if they've been overridden.
      block:
        var runName {.inject.} = nameRun
        try:
          bmSetupImpl()
          runStat = measureLoops(loopCount, verbosity, runBody)
        except:
          if NRM(verbosity): echo "bmLoop ", suiteName, ".", runName, ": exception=", getCurrentExceptionMsg()
        finally:
          bmTeardownImpl()
          if NRM(verbosity): bmEchoResults(runStat, verbosity, suiteName, runName, cyclesPerSec)

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmRunX(nameRun: string, seconds: float, runStats: var openarray[RunningStat],
                    runBody: stmt): stmt {.dirty.} =
      ## Run the runBody using cycles by using an interger for timeOrCycles or using
      ## time by passing a float in timeOrCycles. Optionally each time bmRun is invoked
      ## it will invoke bmSetup or bmTeardown if they've been overridden.
      block:
        var runXName {.inject.} = nameRun
        #var rslt: RunningStat
        try:
          bmSetupImpl()
          measureForX(seconds, verbosity, runStats, runBody)
        except:
          if NRM(verbosity): echo "bmRun ", suiteName, ".", runXName, ": exception=", getCurrentExceptionMsg()
        finally:
          bmTeardownImpl()
          if NRM(verbosity):
            for i in 0..runStats.len-1:
              bmEchoResults(runStats[i], verbosity, suiteName, runXName, cyclesPerSec)

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

    test "cyclesToRun":
      const runTime = 5.0
      var cycles = cyclesToRun(runTime)
      var cps = cyclesPerSecond(0.25)
      check((cycles.float > (runTime * cps  * 0.95)) and
            (cycles.float < (runtime * cps  * 1.05)))


  suite "test bm":
    ## Some simple tests
    test "bmSuite":

      bmSuite "bmLoop":
        var
          rs: RunningStat
          loops = 0
          bmSetupCalled = 0
          bmTearDownCalled = 0

        bmSetup:
          loops = 0
          bmSetupCalled += 1

        bmTearDown:
          bmTearDownCalled += 1

        bmLoop "loop 1", 1, rs:
          check(bmSetupCalled == 1)
          check(bmTearDownCalled == 0)
          loops += 1
        checkpoint("loop 1 rs=" & $rs)
        check(loops == 1)
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 1)
        check(rs.n == 1)
        check(rs.min >= 0.0)

      bmSuite "bmRun":
        var
          rs: RunningStat
          loops = 0
          bmSetupCalled = 0
          bmTearDownCalled = 0

        bmSetup:
          loops = 0
          bmSetupCalled += 1

        bmTearDown:
          bmTearDownCalled += 1

        bmRun "run 0.001 seconds ", 0.001, rs:
          loops += 1
          check(bmSetupCalled == 1)
          check(bmTearDownCalled == 0)

        checkpoint("run 0.001 seconds rs=" & $rs)
        check(loops > 100)
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 1)
        check(rs.n > 1)
        check(rs.min >= 0.0)

        var cyclesToRunHalfSecond = cyclesToRun(0.5)
        bmRun "run 0.5 seconds of cycles", cyclesToRunHalfSecond, rs:
          loops += 1
          check(bmSetupCalled == 2)
          check(bmTearDownCalled == 1)

        checkpoint("run 0.5 seconds of cycles rs=" & $rs)
        check(loops > 1)
        check(bmSetupCalled == 2)
        check(bmTearDownCalled == 2)
        check(rs.n > 1)
        check(rs.min >= 0.0)

      bmSuite "bmRunX":
        var
          rss: array[0..10, RunningStat]
          loops = 0
          bmSetupCalled = 0
          bmTearDownCalled = 0

        bmSetup:
          loops = 0
          bmSetupCalled += 1

        bmTearDown:
          verbosity = Verbosity.dbg
          bmTearDownCalled += 1

        bmRunX "run 2 seconds", 2.0, rss:
          atomicInc(loops)
          check(bmSetupCalled == 1)
          check(bmTearDownCalled == 0)

        check(loops > 100)
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 1)

