import benchmark

#bmDefaultVerbosity = Verbosity.verbose

suite "increment", 1.0:
  var
    bms: array[0..9, BmStats]
    loops = 0

  echo "bmso=", bmso

  test "inc", 0.5, bms:
    inc(loops)

  test "atomicInc", 0.5, bms:
    atomicInc(loops)
