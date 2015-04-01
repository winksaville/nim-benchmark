import benchmark

bmSuite "testing", 1.0:
  var
    bmsArray: array[0..5, BmStats]
    loops = 0

  bmTime "atomicInc 0.5 seconds", 0.5, bmsArray:
    atomicInc(loops)
