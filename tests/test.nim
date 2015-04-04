import unittest as ut
import benchmark

ut.suite "benchmark tests":

  ut.test "benchmark test and with and without setup/teardown":
    var suiteCount = 0

    check(suiteCount == 0)
    suite "loop tests", 0.0:
      suiteCount += 1

      var
        ts : TestStats
        tsArray: array[0..2, TestStats]
        loops = 0
        setupCalled = 0
        teardownCalled = 0

      setup:
        loops = 0
        setupCalled += 1

      teardown:
        teardownCalled += 1

      test "loop 10", 10, tsArray:
        check(setupCalled == 1)
        check(teardownCalled == 0)
        loops += 1
      check(loops == 30)
      check(setupCalled == 1)
      check(teardownCalled == 1)
      for i in 0..tsArray.len-1:
        check(tsArray[i].n == 10)
        check(tsArray[i].min >= 0.0)

      test "loop 1", 1, ts:
        loops += 1
        check(loops == 1)
        check(setupCalled == 2)
        check(teardownCalled == 1)

      checkpoint(suiteObj.fullName & ": ts=" & $ts)
      check(loops == 1)
      check(setupCalled == 2)
      check(teardownCalled == 2)
      check(ts.n == 1)
      check(ts.min >= 0.0)

    check(suiteCount == 1)

    suite "timing and loop tests", 0:
      suiteCount += 1

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

      test "run 0.001 seconds ", 0.001, ts:
        loops += 1
        check(setupCalled == 1)
        check(teardownCalled == 0)

      checkpoint(suiteObj.fullName & ": ts=" & $ts)
      check(loops > 100)
      check(setupCalled == 1)
      check(teardownCalled == 1)
      check(ts.n > 1)
      check(ts.min >= 0.0)

      setup:
        discard
      teardown:
        discard

      loops = 0
      test "loop 2", 2, ts:
        loops += 1
        check(setupCalled == 1)
        check(teardownCalled == 1)

      checkpoint(suiteObj.fullName & ": ts=" & $ts)
      check(loops == 2)
      check(setupCalled == 1)
      check(teardownCalled == 1)
      check(ts.n == 2)
      check(ts.min >= 0.0)

    # Verify both suites executed
    check(suiteCount == 2)
