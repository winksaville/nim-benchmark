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

  test "measureFor 0.5 seconds":
    var
      runTime = 0.1
      startTime = epochTime()
      rs = measureFor(runTime, work())
      duration = epochTime() - startTime

    checkpoint("runTime=" & $runTime)
    checkpoint("startTime=" & $startTime)
    checkpoint("duration=" & $duration)
    checkpoint("rs=" & $rs)
    check(rs.n >= 0)
    check(rs.min >= 0.0)
    check(duration * 0.80 <= runTime)
    check(duration * 1.20 >= runTime)
    when DBG: fail()

  test "measureFor 0.5 seconds of cycles":
    var
      runTime = 0.1
      cycles = cyclesToRun(runTime)
      startTime = epochTime()
      rs = measureFor(cycles, work())
      duration = epochTime() - startTime

    checkpoint("runTime=" & $runTime)
    checkpoint("cycles=" & $cycles)
    checkpoint("startTime=" & $startTime)
    checkpoint("duration=" & $duration)
    checkpoint("rs=" & $rs)
    check(rs.n >= 0)
    check(rs.min >= 0.0)
    check(duration * 0.80 <= runTime)
    check(duration * 1.20 >= runTime)
    when DBG: fail()

bmSuite "testing echo":
  var rs: RunningStat
  var loops = 0

  bmLoops "loop 10 times", 10, rs:
    loops += 1
    echo "loop ", loops
  echo "rs=", rs


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

