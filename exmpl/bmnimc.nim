import benchmark, os

suite "test compile", 1.0:
  var
    tsArray : array[0..4, TestStats]

  test "bminc.nim", 3.0, tsArray:
    discard execShellCmd("nim c -d:release --verbosity:0 --hints:off --warnings:off --threads:on exmpl/bminc.nim")
