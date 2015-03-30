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

      var bms: BmStats
      var loops = 0
      var bmSetupCalled = 0
      var bmTearDownCalled = 0

      bmSetup:
        loops = 0
        bmSetupCalled += 1

      bmTearDown:
        bmTearDownCalled += 1

      bmLoop "loop 10", 10, bms:
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 0)
        loops += 1
      checkpoint("loop 10 bms=" & $bms)
      check(loops == 10)
      check(bmSetupCalled == 1)
      check(bmTearDownCalled == 1)
      check(bms.n == 10)
      check(bms.min >= 0.0)

      bmLoop "loop 1", 1, bms:
        loops += 1
        check(loops == 1)
        check(bmSetupCalled == 2)
        check(bmTearDownCalled == 1)

      checkpoint("loop 1 bms=" & $bms)
      check(loops == 1)
      check(bmSetupCalled == 2)
      check(bmTearDownCalled == 2)
      check(bms.n == 1)
      check(bms.min >= 0.0)

    check(bmSuiteCount == 1)

    bmSuite "bmTime":
      bmSuiteCount += 1

      var bms: BmStats
      var loops = 0
      var bmSetupCalled = 0
      var bmTearDownCalled = 0

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

      bmSetup:
        discard
      bmTearDown:
        discard

      loops = 0
      bmLoop "loop 2", 2, bms:
        loops += 1
        check(bmSetupCalled == 1)
        check(bmTearDownCalled == 1)

      checkpoint("loops 2 bms=" & $bms)
      check(loops == 2)
      check(bmSetupCalled == 1)
      check(bmTearDownCalled == 1)
      check(bms.n == 2)
      check(bms.min >= 0.0)

    # Verify both suites executed
    check(bmSuiteCount == 2)
