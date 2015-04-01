import benchmark

bmSuite "increment", 1.0:
  var
    bms: array[0..4, BmStats]
    loops = 0

  bmTime "inc", 0.5, bms:
    inc(loops)

  bmTime "atomicInc", 0.5, bms:
    atomicInc(loops)
