import benchmark

suite "increment":
  var
    ts: TestStats
    loops = 0

  test "inc", 0.5, ts:
    inc(loops)

  test "atomicInc", 0.5, ts:
    atomicInc(loops)
