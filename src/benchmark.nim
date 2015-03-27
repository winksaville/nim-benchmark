# The use of cpuid, rtsc, rtsp is Intel document titled
#   "How to Benchmark Code Execution Times on Intel IA-32
#   and IA-64 Instruction Set Architectures"
# Here is a short link to the document: http://goo.gl/tzKu65
import math, times, os, posix, strutils

type
  CpuId* = tuple
    eax: int
    ebx: int
    ecx: int
    edx: int

proc `$`*(r: RunningStat): string =
  "{n=" & $r.n & " sum=" & $r.sum & " min=" & $r.min & " max=" & $r.max & " mean=" & $r.mean & "}"

proc `$`*(cpuid: CpuId): string =
  "{ eax=0x" & cpuid.eax.toHex(8) & " ebx=0x" & cpuid.ebx.toHex(8) & " ecx=0x" & cpuid.ecx.toHex(8) & " edx=0x" & cpuid.edx.toHex(8) & "}"

proc cpuid*(ax_param: int, ex_param: int): CpuId =
  {.emit: """
    asm volatile (
      "movq %4, %%rax\n\t"
      "movq %5, %%rcx\n\t"
      "cpuid\n\t"
      : "=a"(`result.Field0`), "=b"(`result.Field1`), "=c"(`result.Field2`), "=d"(`result.Field3`)
      : "r"(`ax_param`), "r"(`ex_param`));
  """.}

proc cpuid*(ax_param: int): CpuId =
  {.emit: """
    asm volatile (
      "movq %4, %%rax\n\t"
      "cpuid\n\t"
      : "=a"(`result.Field0`), "=b"(`result.Field1`), "=c"(`result.Field2`), "=d"(`result.Field3`)
      : "r"(`ax_param`));
  """.}

proc cpuid*() {.inline.} =
  {.emit: """
    asm volatile (
      "cpuid\n\t"
      : /* Throw away output */
      : /* No input */
      : "%eax", "%ebx", "%ecx", "%edx");
  """.}

proc rdtsc*(): int64 {.inline.} =
  var lo, hi: uint32
  {.emit: """
    asm volatile (
      "rdtsc\n\t"
      :"=a"(`lo`), "=d"(`hi`));
  """.}
  result = int64(lo) or (int64(hi) shl 32)

proc rdtscp*(): int64 {.inline.} =
  var lo, hi: uint32
  {.emit: """
    asm volatile (
      "rdtscp\n\t"
      :"=a"(`lo`), "=d"(`hi`));
  """.}
  result = int64(lo) or (int64(hi) shl 32)

proc rdtscp*(tscAux: var int): int64 {.inline.} =
  var lo, hi, aux: uint32
  {.emit: """
    asm volatile (
      "rdtscp\n\t"
      :"=a"(`lo`), "=d"(`hi`), "=c"(`aux`));
  """.}
  tscAux = cast[int](aux)
  result = int64(lo) or (int64(hi) shl 32)

proc getBegCycles*(): int64 {.inline.} =
  cpuid()
  result = rdtsc()

proc getEndCycles*(): int64 {.inline.} =
  result = rdtscp()
  cpuid()

proc getEndCycles*(tscAux: var int): int64 {.inline.} =
  result = rdtscp(tscAux)
  cpuid()

proc initializeCycles*(tscAux: var int): int {.inline.} =
  ## Initalize as per the ia32-ia64-benchmark document returning
  ## the tsc value as exiting and the tscAux in the var param
  discard getBegCycles()
  discard getEndCycles()
  discard getBegCycles()
  result = cast[int](getEndCycles(tscAux))

proc cps(seconds: float): float =
  ## Try to determine the cycles per second of the TSC
  ## seconds is how long to meausre. return -1 if unsuccessful
  ## or its the number of cycles per second
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

proc cyclesPerSecond*(seconds: float): float =
  for i in 0..2:
    result = cps(seconds)
    if result > 0.0:
      return result
  result = -1.0

proc cyclesToRun*(seconds: float, cpsTime: float = 0.25): int =
  for i in 0..2:
    var cyclesPerSecond = cps(cpsTime)
    if cyclesPerSecond > 0.0:
      return round(cyclesPerSecond * seconds)
  result = -1

template measureFor*(cycles: int, body: stmt): RunningStat =
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

template measureFor*(seconds: float, body: stmt): RunningStat =
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

template bmSuite*(suiteName: string, bmSuiteBody: stmt): stmt {.immediate.} =
  block:
    const
      DBG = false

    var
      bmSuiteName {.inject.} = suiteName

    when DBG: echo "suiteName=", bmSuiteName

    # The implementation of setup/teardown when invoked by bmRun
    template bmSetupImpl*: stmt = discard
    template bmTeardownImpl*: stmt = discard

    # Allow overriding of setup/teardownImpl
    template bmSetup*(bmSetupBody: stmt): stmt {.immediate.} = # {.immediate.} makes {.inject.}'s availabe to setupBody
      template bmSetupImpl*: stmt = bmSetupBody
    template bmTeardown*(bmTeardownBody: stmt): stmt {.immediate.} = # {.immediate.} makes {.inject.}'s available to teardownBody
      template bmTeardownImpl*: stmt = bmTeardownBody

    template bmRun*(runName: string, timeOrCycles: expr, runStat: var RunningStat, runBody: stmt): stmt {.immediate, dirty.} = # {.dirty.} is needed so bmSetup/TeardownImpl are invokable???
      ## Run the runBody using cycles by using an interger for timeOrCycles or using
      ## time by passing a float in timeOrCycles. Optionally each time bmRun is invoked
      ## it will invoke bmSetup or bmTeardown if they've been overridden.
      block:
        var bmRunName {.inject.} = runName # This must be {.inject.} to be available to innerBody even with {.dirty.}???
        #var rslt: RunningStat
        try:
          echo bmSuiteName, ".", bmRunName
          bmSetupImpl()
          runStat = measureFor(timeOrCycles, runBody)
          when DBG: echo "bmRun: runStat=", runStat
        except:
          echo "bmRun: except ", bmSuiteName, ".", bmRunName, "e=", getCurrentExceptionMsg()
        finally:
          bmTeardownImpl()

    # Instanitate the suite body
    bmSuiteBody

