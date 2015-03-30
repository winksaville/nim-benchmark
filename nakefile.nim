import nake

const
  buildArtifacts =
    @["benchmark", "benchmark.html", "nimcache", "t",
      "tests/test", "tests/test.html", "tests/nimcache",
      "examples/bmrun", "examples/bmloop", "examples/nimcache"]
  buildFlags = "-d:release --verbosity:0 --hints:off --warnings:off --threads:on"
  #buildFlags = "-d:release --verbosity:3 --hints:off --warnings:on --threads:on --parallelBuild:1"

  docFlags = ""
  docFiles = @["benchmark.nim"]
  exampleFiles = @["examples/bmloop.nim", "examples/bmrun.nim"]

task defaultTask, "Clean, Compile and run the tests":
  runTask "clean"
  runTask "build-tests"
  runTask "run-tests"

task "bm", "Build and run benchmark for its tests":
  if not shell(nimExe, "c -r",  buildFlags, "benchmark.nim"):
    echo "error compiling"
    quit 1

task "docs", "Buiild the documents":
  for file in docFiles:
    if not shell(nimExe, "doc", docFlags, file):
      echo "error generating docs"
      quit 1

task "examples", "Build and run the examples":
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

