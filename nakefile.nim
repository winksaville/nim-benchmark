import nake

const
  buildArtifacts = @["t", "test", "tests/test", "tests/nimcache", "nimcache"]
  buildFlags = "-d:release --verbosity:2 --listcmd --hints:off --warnings:on --threads:on"
  #buildFlags = "--verbosity:9 --listCmd --hints:off --warnings:on --threads:on --parallelBuild:1"

task defaultTask, "Clean, Compile and run the tests":
  runTask "clean"
  runTask "build-tests"
  runTask "run-tests"

task "build-tests", "Build the tests":
  if shell(nimExe, "c",  buildFlags, "tests/test.nim"):
    echo "success"
  else:
    echo "error compiling"
    quit 1

task "run-tests", "Run the tests":
  discard shell("tests/test")

task "nake", "build the nakefile":
  if shell("nim c", buildFlags, "nakefile"):
    removeDir "nimcache"
    quit 0
  else:
    echo "error compiling nakefile"
    quit 1

task "clean", "clean build artifacts":
  for file in buildArtifacts:
    try:
      removeFile(file)
    except OSError:
      try:
        removeDir(file)
      except OSError:
        echo "Could not remove: ", file, " ", getCurrentExceptionMsg()

