import benchmark

bmSuite "testing atomicInc":
  var bmsArray: array[0..2, BmStats]
  var loops = 0

  bmSetup:
    # Start with normal verbosity
    verbosity = Verbosity.normal
    loops = 0

  bmTeardown:
    # Setting verbosity to dbg outputs the bmsArray
    verbosity = Verbosity.dbg

  bmLoop "loop 10 times", 10, bmsArray:
    atomicInc(loops)

  bmTime "run 0.5 seconds", 0.5, bmsArray:
    atomicInc(loops)
