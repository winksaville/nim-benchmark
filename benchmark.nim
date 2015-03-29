## Benchmark will measure the time it takes for some arbitrary
## code to excute in the body of templates bmLoops or bmRun.
## These templates using a processr provided funtion to measure
## the number of cycles necessary to run each iteration of the
## body and reports the results as a RunningStat object defined
## in the nim math module.
##
## Example use with the following code in t1.nim:
##
## ::
##    $ cat t1.nim
##    import benchmark
##
##    bmSuite "testing echo":
##      var rs: RunningStat
##      var loops = 0
##    
##      bmLoops "loop 10 times", 10, result:
##        loops += 1
##        echo "loop ", loops
##      echo "rs=", rs
##    
## And then compiling and running with:
##
## ::
##    $ nim c -r --verbosity:0 t1.nim
##    testing echo.loop 10 times
##    loop 1
##    loop 2
##    loop 3
##    loop 4
##    loop 5
##    loop 6
##    loop 7
##    loop 8
##    loop 9
##    loop 10
##    rs={n=10 sum=48600.0 min=3448.0 max=14424.0 mean=4859.999999999999}
##
## The fields for RunningStat are:
##
## ::
##    rs.n    = Number of loops
##    rs.sum  = sum of the time for each loop in cycles
##    rs.min  = The cycles needed for the fastest loop
##    rs.max  = The cycles needed for the slowest loop
##    rs.mean = rs.sum / rs.n
##
## The basic usage is to use the bmSuite template to define a scope for
## one or more instantiations of bmLoops and bmRun templates. In addition,
## prior to actually running the body of bmLoops or bmRun the template bmSetup
## is invoked and at the conclusion bmTeardown is invoked. See below for
## additional details.
## 
# The use of cpuid, rtsc, rtsp is Intel document titled
#   "How to Benchmark Code Execution Times on Intel IA-32
#   and IA-64 Instruction Set Architectures"
# Here is a short link to the document: http://goo.gl/tzKu65
import math, times, os, posix, strutils
export math

type
  ## The registers returned by cpuid instruction.
  CpuId* = tuple[eax: int, ebx: int, ecx: int, edx: int]

proc `$`*(r: RunningStat): string =
  ## Print the RunningStat.
  "{n=" & $r.n & " sum=" & $r.sum & " min=" & $r.min & " max=" & $r.max & " mean=" & $r.mean & "}"

proc `$`*(cpuid: CpuId): string =
  ## Print the CpuId.
  "{ eax=0x" & cpuid.eax.toHex(8) & " ebx=0x" & cpuid.ebx.toHex(8) & " ecx=0x" & cpuid.ecx.toHex(8) & " edx=0x" & cpuid.edx.toHex(8) & "}"

proc cpuid*(eax_param: int, ecx_param: int): CpuId =
  ## Execute cpuid instruction wih EAX = eax_param and ECX = ecx_param.
  {.emit: """
    asm volatile (
      "movq %4, %%rax\n\t"
      "movq %5, %%rcx\n\t"
      "cpuid\n\t"
      : "=a"(`result.Field0`), "=b"(`result.Field1`), "=c"(`result.Field2`), "=d"(`result.Field3`)
      : "r"(`eax_param`), "r"(`ecx_param`));
  """.}

proc cpuid*(ax_param: int): CpuId =
  ## Execute cpuid instruction wih EAX = eax_param.
  {.emit: """
    asm volatile (
      "movq %4, %%rax\n\t"
      "cpuid\n\t"
      : "=a"(`result.Field0`), "=b"(`result.Field1`), "=c"(`result.Field2`), "=d"(`result.Field3`)
      : "r"(`ax_param`));
  """.}

proc cpuid*() {.inline.} =
  ## Execute cpuid instruction wih no parameters. This will
  ## return arbitrary data and is used a memory barrier instruction.
  {.emit: """
    asm volatile (
      "cpuid\n\t"
      : /* Throw away output */
      : /* No input */
      : "%eax", "%ebx", "%ecx", "%edx");
  """.}

proc rdtsc*(): int64 {.inline.} =
  ## Execute the rdtsc, read Time Stamp Counter, instruction
  ## returns the 64 bit TSC value.
  var lo, hi: uint32
  {.emit: """
    asm volatile (
      "rdtsc\n\t"
      :"=a"(`lo`), "=d"(`hi`));
  """.}
  result = int64(lo) or (int64(hi) shl 32)

proc rdtscp*(): int64 {.inline.} =
  ## Execute the rdtscp, read Time Stamp Counter, instruction
  ## returns the 64 bit TSC value but ignore the tscAux value.
  var lo, hi: uint32
  {.emit: """
    asm volatile (
      "rdtscp\n\t"
      :"=a"(`lo`), "=d"(`hi`));
  """.}
  result = int64(lo) or (int64(hi) shl 32)

proc rdtscp*(tscAux: var int): int64 {.inline.} =
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

proc getEndCycles*(): int64 {.inline.} =
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
    DBG = true

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
      when DBG: echo "bad tscAuxNow=0x", tscAuxNow.toHex(4), " != tscAuxInitial=0x", tscAuxInitial.toHex(4)
      return -1.0
  result = (ec - start).toFloat() / seconds

proc cyclesPerSecond(seconds: float): float =
  ## Call cps several times to maximize the chance
  ## of getting a good value
  for i in 0..2:
    result = cps(seconds)
    if result > 0.0:
      return result
  result = -1.0

proc cyclesToRun*(seconds: float, cpsTime: float = 0.25): int =
  ## Returns the number of cycles that can be passed to bmRun
  for i in 0..2:
    var cyclesPerSecond = cps(cpsTime)
    if cyclesPerSecond > 0.0:
      return round(cyclesPerSecond * seconds)
  result = -1

template measureFor(cycles: int, body: stmt): RunningStat =
  ## Meaure the execution time of body for cycles count of TSC
  ## returning the RunningStat for the loop timings. If
  ## RunningStat.n = -1 and RunningStat.min == -1 then an error occured.
  const
    DBG = false
    DBGV = false

  var
    result: RunningStat
    tscAuxInitial: int
    tscAuxNow: int
    start: int
    done: int
    bc {.inject.} : int64
    ec {.inject.} : int64

  when DBG: echo "measureFor: cycles=", cycles

  # TODO: Handle wrapping of counter!
  start = initializeCycles(tscAuxInitial)
  done = start + cycles
  when DBG: echo "tscAuxInitial=0x", tscAuxInitial.toHex(4)
  ec = 0
  while ec <= done:
    bc = getBegCycles()
    body
    ec = getEndCycles(tscAuxNow)
    var duration = float(ec - bc)
    when DBGV: echo "duration=", duration, " ec=", float(ec), " bc=", float(bc)
    if tscAuxInitial != tscAuxNow:
      when DBG: echo "bad tscAuxNow=0x", tscAuxNow.toHex(4), " != tscAuxInitial=0x", tscAuxInitial.toHex(4)
      result.n = -1
      result.min = -1
      break
    if duration < 0.0:
      when DBG: echo "ignore duration=", duration, " ec=", float(ec), " bc=", float(bc)
    else:
      result.push(duration)
  result

template measureFor(seconds: float, body: stmt): RunningStat =
  ## Meaure the execution time of body for seconds period of time
  ## returning the RunningStat for the loop timings. If
  ## RunningStat.n = -1 and RunningStat.min == -1 then an error occured.
  const
    DBG = false
    DBGV = false

  var
    result: RunningStat
    tscAuxInitial: int
    tscAuxNow: int
    endTime: float
    bc : int64
    ec : int64

  when DBG: echo "measureFor: seconds=", seconds

  endTime = epochTime() + seconds
  discard initializeCycles(tscAuxInitial)
  while epochTime() <= endTime:
    # TODO: Make the body of this loop a template
    bc = getBegCycles()
    body
    ec = getEndCycles(tscAuxInitial)
    var duration = float(ec - bc)
    when DBGV: echo "duration=", duration, " ec=", float(ec), " bc=", float(bc)
    if tscAuxInitial != tscAuxNow:
      when DBG: echo "bad tscAuxNow=0x", tscAuxNow.toHex(4), " != tscAuxInitial=0x", tscAuxInitial.toHex(4)
      result.n = -1
      result.min = -1
      break
    if duration < 0.0:
      when DBG: echo "ignore duration=", duration, " ec=", float(ec), " bc=", float(bc)
    else:
      result.push(duration)
  result

template measureLoops(loopCount: int, body: stmt): RunningStat =
  ## Meaure the execution time of body for seconds period of time
  ## returning the RunningStat for the loop timings. If
  ## RunningStat.n = -1 and RunningStat.min == -1 then an error occured.
  const
    DBG = false
    DBGV = false

  var
    result: RunningStat
    tscAuxInitial: int
    tscAuxNow: int
    bc : int64
    ec : int64

  when DBG: echo "measureFor: seconds=", seconds

  discard initializeCycles(tscAuxInitial)
  for i in 0..loopCount-1:
    # TODO: Make the body of this loop a template
    bc = getBegCycles()
    body
    ec = getEndCycles(tscAuxInitial)
    var duration = float(ec - bc)
    when DBGV: echo "duration=", duration, " ec=", float(ec), " bc=", float(bc)
    if tscAuxInitial != tscAuxNow:
      when DBG: echo "bad tscAuxNow=0x", tscAuxNow.toHex(4), " != tscAuxInitial=0x", tscAuxInitial.toHex(4)
      result.n = -1
      result.min = -1
      break
    if duration < 0.0:
      when DBG: echo "ignore duration=", duration, " ec=", float(ec), " bc=", float(bc)
    else:
      result.push(duration)
  result

template bmSuite*(suiteName: string, bmSuiteBody: stmt): stmt {.immediate.} =
  ## Begin a benchmark suite. May contian one or more of bmSetup, bmTeardowni
  ## bmRun, bmLoops which are detailed below:
  ##::
  ##  template bmSetup*(bmSetupBody: stmt): stmt {.immediate.} =
  ##    ## This is executed prior to each bmRun or bmLoops
  ##
  ##::
  ##  template bmTeardown*(bmTeardownBody: stmt): stmt {.immediate.} =
  ##    ## This is executed after to each bmRun or bmLoops
  ##
  ##::
  ##  template bmRun*(runName: string, timeOrCycles: expr, runStat: var RunningStat,
  ##    runBody: stmt): stmt
  ##    ## Run the runBody using cycles by using an interger for timeOrCycles or using
  ##    ## time by passing a float in timeOrCycles. Optionally each time bmRun is invoked
  ##    ## it will invoke bmSetup or bmTeardown if they've been overridden.
  ##
  ##::
  ##  template bmLoops*(runName: string, loopCount: int, runStat: var RunningStat,
  ##    runBody: stmt): stmt
  ##    ## Run the runBody loopcount times, optionally each time bmLoops is invoked
  ##    ## it will invoke bmSetup or bmTeardown if they've been overridden.
  block:
    const
      DBG = false

    var
      bmSuiteName {.inject.} = suiteName
      bmVerbosity {.inject.} = 0

    when DBG: echo "suiteName=", bmSuiteName

    # The implementation of setup/teardown when invoked by bmRun
    template bmSetupImpl*: stmt = discard
    template bmTeardownImpl*: stmt = discard

    template bmSetup*(bmSetupBody: stmt): stmt {.immediate.} =
      ## This is executed prior to each bmRun or bmLoops
      template bmSetupImpl*: stmt = bmSetupBody

    template bmTeardown*(bmTeardownBody: stmt): stmt {.immediate.} =
      ## This is executed after to each bmRun or bmLoops
      template bmTeardownImpl*: stmt = bmTeardownBody

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmRun*(runName: string, timeOrCycles: expr, runStat: var RunningStat,
                    runBody: stmt): stmt {.dirty.} =
      ## Run the runBody using cycles by using an interger for timeOrCycles or using
      ## time by passing a float in timeOrCycles. Optionally each time bmRun is invoked
      ## it will invoke bmSetup or bmTeardown if they've been overridden.
      block:
        var bmRunName {.inject.} = runName
        #var rslt: RunningStat
        try:
          if bmVerbosity > 0: echo bmSuiteName, ".", bmRunName
          bmSetupImpl()
          runStat = measureFor(timeOrCycles, runBody)
          when DBG: echo "bmRun: runStat=", runStat
        except:
          echo "bmRun: except ", bmSuiteName, ".", bmRunName, "e=", getCurrentExceptionMsg()
        finally:
          bmTeardownImpl()

    # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
    template bmLoops*(runName: string, loopCount: int, runStat: var RunningStat,
                      runBody: stmt): stmt {.dirty.} =
      ## Run the runBody loopcount times, optionally each time bmLoops is invoked
      ## it will invoke bmSetup or bmTeardown if they've been overridden.
      block:
        var bmRunName {.inject.} = runName # This must be {.inject.} to be available to innerBody even with {.dirty.}???
        try:
          if bmVerbosity > 0: echo bmSuiteName, ".", bmRunName
          bmSetupImpl()
          runStat = measureLoops(loopCount, runBody)
          when DBG: echo "bmRun: runStat=", runStat
        except:
          echo "bmRun: except ", bmSuiteName, ".", bmRunName, "e=", getCurrentExceptionMsg()
        finally:
          bmTeardownImpl()

    # Instanitate the suite body
    bmSuiteBody

