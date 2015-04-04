import benchmark

#bmDefaultVerbosity = Verbosity.verbose

suite "increment", 1.0:
  var
    ts: array[0..9, TestStats]
    loops = 0

  echo "suiteObj=", suiteObj

  test "inc", 0.5, ts:
    inc(loops)

  test "atomicInc", 0.5, ts:
    atomicInc(loops)
