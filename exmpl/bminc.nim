import benchmark

suite "increment", 0.0:
  var
    bms: BmStats
    loops = 0

  test "inc", 0.5, bms:
    inc(loops)

  test "atomicInc", 0.5, bms:
    atomicInc(loops)
