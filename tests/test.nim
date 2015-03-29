import benchmark
import math, times, os, unittest, posix, strutils

const
  DBG = false

proc work() =
  var val = 0
  for i in 0..1_000:
    val = atomic_add_fetch(addr val, 1, ATOMIC_RELAXED)

suite "bmTests":

  test "bmSuite":
    var bmSuiteCount = 0

    check(bmSuiteCount == 0)
    bmSuite "bmLoops":
      bmSuiteCount += 1

      var rs: RunningStat
      var loops = 0
      var bmSetupCalled = 0
      var bmTearDownCalled = 0

      bmSetup:
        loops = 0
        bmSetupCalled += 1

      bmTearDown:
        bmTearDownCalled += 1

      bmLoops "loop 10", 10, rs:
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 0)
        loops += 1
      checkpoint("loop 10 rs=" & $rs)
      check(loops == 10)
      check(bmSetupCalled == 1)
      check(bmTearDownCalled == 1)
      check(rs.n == 10)
      check(rs.min >= 0.0)

      bmLoops "loop 1", 1, rs:
        loops += 1
        check(loops == 1)
        check(bmSetupCalled == 2)
        check(bmTearDownCalled == 1)

      checkpoint("loop 1 rs=" & $rs)
      check(loops == 1)
      check(bmSetupCalled == 2)
      check(bmTearDownCalled == 2)
      check(rs.n == 1)
      check(rs.min >= 0.0)

    check(bmSuiteCount == 1)
    bmSuite "bmRun":
      bmSuiteCount += 1

      var rs: RunningStat
      var loops = 0
      var bmSetupCalled = 0
      var bmTearDownCalled = 0

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

      bmRun "run 1 cycle", 1, rs:
        loops += 1
        check(bmSetupCalled == 2)
        check(bmTearDownCalled == 1)

      checkpoint("run 1 cycle rs=" & $rs)
      check(loops == 1)
      check(bmSetupCalled == 2)
      check(bmTearDownCalled == 2)
      check(rs.n == 1)
      check(rs.min >= 0.0)

      var cyclesToRunHalfSecond = cyclesToRun(0.5)
      bmRun "run 0.5 seconds of cycles", cyclesToRunHalfSecond, rs:
        loops += 1
        check(bmSetupCalled == 3)
        check(bmTearDownCalled == 2)

      checkpoint("run 0.5 seconds of cycles rs=" & $rs)
      check(loops > 1)
      check(bmSetupCalled == 3)
      check(bmTearDownCalled == 3)
      check(rs.n > 1)
      check(rs.min >= 0.0)

      bmSetup:
        discard
      bmTearDown:
        discard

      loops = 0
      bmLoops "loop 2", 2, rs:
        loops += 1
        check(bmSetupCalled == 3)
        check(bmTearDownCalled == 3)

      checkpoint("loops 2 rs=" & $rs)
      check(loops == 2)
      check(bmSetupCalled == 3)
      check(bmTearDownCalled == 3)
      check(rs.n == 2)
      check(rs.min >= 0.0)

    # Verify both suites executed
    check(bmSuiteCount == 2)
