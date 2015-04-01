import benchmark, os

bmSuite "test compile", 1.0:
  var
    bmsArray : array[0..4, BmStats]

  bmTime "bminc.nim", 3.0, bmsArray:
    discard execShellCmd("nim c -d:release --verbosity:0 --hints:off --warnings:off --threads:on exmpl/bminc.nim")
