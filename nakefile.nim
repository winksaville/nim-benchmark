import nake

const
  buildArtifacts = @["benchmark.html", "nimcache", "t", "tests/test", "tests/test.html", "tests/nimcache"]
  buildFlags = "-d:release --verbosity:0 --hints:off --warnings:off --threads:on"
  #buildFlags = "-d:release --verbosity:3 --hints:off --warnings:on --threads:on --parallelBuild:1"

  docFlags = ""
  docFiles = @["benchmark.nim"]

task defaultTask, "Clean, Compile and run the tests":
  runTask "clean"
  runTask "build-tests"
  runTask "run-tests"

task "build-docs", "Buiild the documents":
  for file in docFiles:
    if shell(nimExe, "doc", docFlags, file):
      echo "success"
    else:
      echo "error generating docs"
      quit 1

task "build-tests", "Build the tests":
  if shell(nimExe, "c",  buildFlags, "tests/test.nim"):
    echo "success"
  else:
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

