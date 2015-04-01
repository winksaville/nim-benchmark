import benchmark

bmSuite "increment", 1.0:
  var
    bms: BmStats
    loops = 0

  bmTime "+=1", 0.1, bms:
    loops += 1

  bmTime "inc", 0.1, bms:
    inc(loops)

  bmTime "atomicInc", 0.1, bms:
    atomicInc(loops)
