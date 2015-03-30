import benchmark, os


bmSuite "test compiler":
  var rs: RunningStat

  bmRun "compile", 0.5, rs:
    if execShellCMD("nim c --verbosity:0 --hints:off --warnings:off benchmark.nim") != 0:
      echo "failure"
      quit 1

  var
    val: float
    v1 = 1.3
    v2 = 2.4

  bmRun "float multiplication", cyclesToRun(3.0), rs:
    val = v1 * v2
