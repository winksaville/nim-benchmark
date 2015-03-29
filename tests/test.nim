import benchmark
import math, times, os, unittest, posix, strutils

const
  DBG = false

proc nada() =
  (discard)

proc work() =
  var val = 0
  for i in 0..1_000:
    val = atomic_add_fetch(addr val, 1, ATOMIC_RELAXED)

proc unpackIntToStr(val: int, strg: var string) =
  var value = val
  for byteIdx in 0..3:
    strg.add(cast[char](value and 0xFF))
    value = value shr 8

suite "bmTests":
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
      name: string
      strg = ""
      offset = 0

    for eax in 0x8000_0002..0x8000_0004:
      id = cpuid(eax)
      unpackIntToStr(id.eax, strg)
      unpackIntToStr(id.ebx, strg)
      unpackIntToStr(id.ecx, strg)
      unpackIntToStr(id.edx, strg)

    # This isn't much of a check but something.Intel is correct not sure about AMD
    check(strg.startsWith("Intel") or (strg.len > 0 and strg.len < 48))

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

bmSuite "suite2":
  const
    DBG = false
  bmSetup:
    when DBG: echo "suite2:  setup"
  bmTeardown:
    when DBG: echo "suite2:  teardown "

  var
    result: RunningStat

  bmRun "bmRun for 0.5 seconds", 0.5, result:
    work()
  echo "min=", result.min

  bmSetup:
    discard
  bmTeardown:
    discard

  bmRun "bmRun for 1_000_000 cycles", 1_000_000, result:
    when DBG: echo "hi"
    work()
  echo "min=", result.min

  var loops = 0
  bmLoops "bmLoops for 2 loops", 2, result:
    loops += 1
    when DBG: echo "loop ", loops
    work()

  echo "min=", result.min

