import benchmark

bmSuite "testing echo":
  var rs: RunningStat
  var loops = 0

  bmLoops "loop 10 times", 10, rs:
    loops += 1
    echo "loop ", loops
  echo "rs=", rs
