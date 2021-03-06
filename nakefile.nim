import nake

const
  buildArtifacts =
    @["benchmark", "nimcache", "t",
      "tests/test", "tests/test.html", "tests/nimcache",
      "exmpl/bmnimc", "exmpl/bminc", "exmpl/bminc2", "exmpl/nimcache"]
  #buildFlags = "-d:release --verbosity:1 --hints:off --warnings:off --threads:on --embedsrc --lineDir:on"
  buildFlags = "-d:release --verbosity:3 --hints:off --warnings:on --threads:on --embedsrc --lineDir:on --parallelBuild:1"

  docFlags = ""
  docFiles = @["benchmark.nim"]
  exampleFiles = @["exmpl/bminc.nim", "exmpl/bminc2.nim", "exmpl/bmnimc.nim"]

task defaultTask, "Clean, Compile and run the tests":
  runTask "clean"
  runTask "docs"
  runTask "build-tests"
  runTask "run-tests"

task "bm", "Build and run benchmark for its tests":
  if not shell(nimExe, "c -r",  buildFlags, "benchmark.nim"):
    echo "error compiling"
    quit 1

task "build-bm", "Build benchmark":
  if not shell(nimExe, "c ",  buildFlags, "benchmark.nim"):
    echo "error compiling"
    quit 1

task "run-bm", "Build benchmark":
  discard shell("benchmark")

task "docs", "Buiild the documents":
  for file in docFiles:
    if not shell(nimExe, "doc", docFlags, file):
      echo "error generating docs"
      quit 1

task "exmpl", "Build and run the exmpl":
  for file in exampleFiles:
    if not shell(nimExe, "c -r",  buildFlags, file):
      echo "error compiling"
      quit 1

task "build-tests", "Build the tests":
  if not shell(nimExe, "c",  buildFlags, "tests/test.nim"):
    echo "error compiling"
    quit 1

task "run-tests", "Run the tests":
  discard shell("tests/test")

task "clean", "clean build artifacts":
  proc removeFileOrDir(file) =
    try:
      removeFile(file)
    except OSError:
      try:
        removeDir(file)
      except OSError:
        echo "Could not remove: ", file, " ", getCurrentExceptionMsg()

  for file in buildArtifacts:
    removeFileOrDir(file)

