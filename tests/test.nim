import benchmark, unittest

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
    bmSuite "bmLoop":
      bmSuiteCount += 1

      var bmsArray: array[0..0, BmStats]
      var loops = 0
      var bmSetupCalled = 0
      var bmTearDownCalled = 0

      bmSetup:
        loops = 0
        bmSetupCalled += 1

      bmTearDown:
        bmTearDownCalled += 1

      bmLoop "loop 10", 10, bmsArray:
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 0)
        loops += 1
      checkpoint("loop 10 bms=" & $bmsArray[0])
      check(loops == 10)
      check(bmSetupCalled == 1)
      check(bmTearDownCalled == 1)
      check(bmsArray[0].n == 10)
      check(bmsArray[0].min >= 0.0)

      bmLoop "loop 1", 1, bmsArray:
        loops += 1
        check(loops == 1)
        check(bmSetupCalled == 2)
        check(bmTearDownCalled == 1)

      checkpoint("loop 1 bms=" & $bmsArray[0])
      check(loops == 1)
      check(bmSetupCalled == 2)
      check(bmTearDownCalled == 2)
      check(bmsArray[0].n == 1)
      check(bmsArray[0].min >= 0.0)

    check(bmSuiteCount == 1)

    bmSuite "bmTime":
      bmSuiteCount += 1

      var bmsArray: array[0..0, BmStats]
      var loops = 0
      var bmSetupCalled = 0
      var bmTearDownCalled = 0

      bmSetup:
        loops = 0
        bmSetupCalled += 1

      bmTearDown:
        bmTearDownCalled += 1

      bmTime "run 0.001 seconds ", 0.001, bmsArray:
        loops += 1
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 0)

      checkpoint("run 0.001 seconds bms=" & $bmsArray[0])
      check(loops > 100)
      check(bmSetupCalled == 1)
      check(bmTearDownCalled == 1)
      check(bmsArray[0].n > 1)
      check(bmsArray[0].min >= 0.0)

      bmSetup:
        discard
      bmTearDown:
        discard

      loops = 0
      bmLoop "loop 2", 2, bmsArray:
        loops += 1
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 1)

      checkpoint("loops 2 bms=" & $bmsArray[0])
      check(loops == 2)
      check(bmSetupCalled == 1)
      check(bmTearDownCalled == 1)
      check(bmsArray[0].n == 2)
      check(bmsArray[0].min >= 0.0)

    # Verify both suites executed
    check(bmSuiteCount == 2)
