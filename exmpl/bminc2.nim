import benchmark

suite "increment", 1.0:
  var
    bms: array[0..4, BmStats]
    loops = 0

  test "inc", 0.5, bms:
    inc(loops)

  test "atomicInc", 0.5, bms:
    atomicInc(loops)
