import benchmark

bmSuite "increment", 0.0:
  var
    bms: BmStats
    loops = 0

  bmTime "inc", 0.5, bms:
    inc(loops)

  bmTime "atomicInc", 0.5, bms:
    atomicInc(loops)
