# Usage "include bmSuite"
#
# To allow use of the benchmark inside a proc/block it must
# not have any globals (i.e. suite*(...) gets a compile error)
template bmSuite(nameSuite: string, warmupSeconds: untyped,
    bmSuiteBody: untyped): untyped =
  ## Begin a benchmark suite. May contian one or more of setup, teardown,
  ## test, these are detailed below:
  ##::
  ##  var suiteObj {.inject.}: SuiteObj
  ##  ## Suite object
  ##::
  ##  template setup(setupBody: untyped): untyped =
  ##    ## This is executed prior to each test
  ##::
  ##  template teardown(teardownBody: untyped): untyped =
  ##    ## This is executed after to each test
  ##::
  ##  template test(name string, loopCount: int,
  ##                   tsArray: var openarray[TestStats],
  ##                   testBody: untyped): untyped {.dirty.} =
  ##    ## Run the testBody loopCount * tsArray.len times. Upon termination
  ##    ## tsArray contains the results.
  ##::
  ##  template test(name string, loopCount: int,
  ##                   ts: var TestStats,
  ##                   testBody: untyped): untyped {.dirty.} =
  ##    ## Run the testBody loopCount times. Upon termination ts
  ##    ## contains the result.
  ##::
  ##  template test(name string, seconds: float,
  ##                   tsArray: var openarray[TestStats],
  ##                   testBody: untyped): untyped {.dirty.} =
  ##    ## Run the testBody in a loop for seconds and the number of loops will be
  ##    ## modulo the length of tsArray. Upon termination tsArray contiains
  ##    ## the results.
  ##::
  ##  template test(name string, seconds: float,
  ##                   ts: var TestStats,
  ##                   testBody: untyped): untyped {.dirty.} =
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
    for i in 0..2:
      suiteObj.cyclesPerSec = cyclesPerSecond(suiteObj)
      if suiteObj.cyclesPerSec > 0.0:
        break

    if suiteObj.cyclesPerSec < 0.0:
      echo suiteObj.suiteName & " BAD cyclesPerSecond stopping " &
           "suiteObj=" & $suiteObj
      break

    # Warmup the CPU
    bmWarmupCpu(suiteObj, float(warmupSeconds))

    # Measure overhead
    measureSecs(suiteObj, DEFAULT_OVERHEAD_RUNTIME, tsa, (discard))
    suiteObj.overhead = tsa[0].min
    if DBGV(suiteObj): echo "suiteObj", suiteObj


    # The implementation of setup/teardown when invoked by test
    template setupImpl: untyped = discard
    template teardownImpl: untyped = discard

    template setup(setupBody: untyped): untyped =
      ## This is executed prior to each test
      template setupImpl: untyped = setupBody

    template teardown(teardownBody: untyped): untyped =
      ## This is executed after to each test
      template teardownImpl: untyped = teardownBody

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test(name: string, loopCount: int,
                     tsArray: var openarray[TestStats],
                     testBody: untyped): untyped {.dirty.} =
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
    template test(name: string, loopCount: int,
        ts: var TestStats, testBody: untyped): untyped {.dirty.} =
      ## Run the testBody loopCount times. Upon termination ts
      ## contains the result.
      block:
        var tsArray: array[0..0, TestStats]
        test(name, loopCount, tsArray, testBody)
        ts = tsArray[0]

    # {.dirty.} is needed so setup/TeardownImpl are invokable???
    template test(name: string, seconds: float,
        tsArray: var openarray[TestStats], testBody: untyped): untyped {.dirty.} =
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
    template test(name: string, seconds: float, ts: var TestStats,
        testBody: untyped): untyped {.dirty.} =
      ## Run the testBody in a loop for seconds and the number of loops will be
      ## modulo the length of tsArray with ts containing the results.
      block:
        var tsArray: array[0..0, TestStats]
        test(name, seconds, tsArray, testBody)
        ts = tsArray[0]

    # Instanitate the suite body
    bmSuiteBody
