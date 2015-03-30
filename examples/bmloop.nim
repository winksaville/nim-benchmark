import benchmark

bmSuite "testing echo":
  var rs: RunningStat
  var loops = 0

  bmSetup:
    loops = 0

  bmTeardown:
    echo "rs=", rs
   
  bmLoop "loop 10 times", 10, rs:
    loops += 1
