import benchmark

bmSuite "testing atomicInc", 1.0:
  var bmsArray: array[0..5, BmStats]
  var loops = 0

  bmTime "run 0.5 seconds", 5.0, bmsArray:
    atomicInc(loops)
