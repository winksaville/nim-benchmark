Benchmark will measure the duration it takes for some arbitrary
code to excute in the body of templates bmLoop or bmTime and
returns the information for the runs in BmStats.

The template bmTime executes the body for the specified number
of seconds. The template bmLoop executes the body loopCount * N
times where N is the number of statistic buckets desired.

The number of statistic buckets is defined by the BmStats parameter.
If array is passed then each run will consist of N sub runs where
N is the length of the array passed. The duration of the sub runs
are sorted from fastest to slowest and pushed into the corresponding
BmStats entry.  An array gives you a beter overview of the spread of
the performance as it's very difficult to get consistent data on modern
computers where there is a lot of contention for resources. Such as
interrupts, mutliple cores both logical and physical, multiple threads,
migration of threads to different cores, the list is endless.

The measurements are taken each loop and is measured in cycles as
defined by the CPU. On an X86 the RDTSC instruction is used to read
the value and the routine cyclesPerSecond will return the approximate
frequency. The cycle values displayed will be in cycles "cy" if the
number of cycles is less-than BmSuiteObj.cyclesToSecThreshold or
time ("s", "ms", ## "us", "ps") if greater-than.

Example use with exmpl/bminc.nim
```nim
$ cat examples/bminc.nim
import benchmark

bmSuite "increment", 0.0:
  var
    bms: BmStats
    loops = 0

  bmTime "inc", 0.5, bms:
    inc(loops)

  bmTime "atomicInc", 0.5, bms:
    atomicInc(loops)
```
And then compiling and running we see some odd data. The
atomicInc(loops) is faster, 48cy, then inc(loops) which is
unexpected. Also minC was only 1 which means that for the
400,000+ executions of the inc(loops) and atomicInc(loops)
only 1 was at min value, 50cy or 48cy respectively. This
doesn't give you a lot confidence in the data.
```
$ nim c --hints:off exmpl/bminc.nim
CC: benchmark_bminc2
CC: stdlib_system
CC: benchmark_benchmark
CC: stdlib_algorithm
CC: stdlib_math
CC: stdlib_times
CC: stdlib_strutils
CC: stdlib_parseutils
CC: stdlib_os
CC: stdlib_posix
[Linking]
$ exmpl/bminc
increment.inc: bms={min=50cy mean=78cy minC=1 n=452276}
increment.atomicInc: bms={min=48cy mean=81cy minC=1 n=431060}
```
So lets make two changes to the code we'll change the warmup
time for bmSuite from 0.0 to 1.0 second. And we'll change
bms to an array of 5 BmStats rather than just one.
```nim
$ cat exmpl/bminc2.nim
bmSuite "increment", 1.0:
  var
    bms: array[0..4, BmStats]
    loops = 0

  bmTime "inc", 0.5, bms:
    inc(loops)

  bmTime "atomicInc", 0.5, bms:
    atomicInc(loops)
```
With these change we still see the atomicInc being faster
but we also see min ranging from 50cy to 68cy and the
mean 75cy to 91cy giving us a better idea of the range of
data. But we still have this oddity of atomicInc being
faster than inc.
```
$ nim c --hints:off exmpl/bminc.nim
CC: benchmark_bminc2
$ exmpl/bminc2
[Linking]
$ exmpl/bminc2
increment.inc: bms[0]={min=50cy mean=74cy minC=2 n=169482}
increment.inc: bms[1]={min=52cy mean=78cy minC=45 n=169482}
increment.inc: bms[2]={min=52cy mean=80cy minC=1 n=169482}
increment.inc: bms[3]={min=56cy mean=81cy minC=10 n=169482}
increment.inc: bms[4]={min=68cy mean=91cy minC=76 n=169482}
increment.atomicInc: bms[0]={min=48cy mean=71cy minC=2 n=175137}
increment.atomicInc: bms[1]={min=52cy mean=73cy minC=61 n=175137}
increment.atomicInc: bms[2]={min=52cy mean=76cy minC=3 n=175137}
increment.atomicInc: bms[3]={min=54cy mean=78cy minC=1 n=175137}
increment.atomicInc: bms[4]={min=68cy mean=84cy minC=3780 n=175137}
```
Lets turn on threading and see what happens maybe that will
make a difference. And sure enough we now see that inc is
faster than atomic but the performance slowed down to 138cy
instead of 50cy. So turning on threading can hurt performance
at least in this configuration.
```
$ nim c --threads:on --hints:off exmpl/bminc2.nim
CC: benchmark_bminc2
CC: stdlib_system
CC: benchmark_benchmark
CC: stdlib_algorithm
CC: stdlib_math
CC: stdlib_times
CC: stdlib_strutils
CC: stdlib_parseutils
CC: stdlib_os
CC: stdlib_posix
[Linking]
$ exmpl/bminc2
increment.inc: bms[0]={min=138cy mean=164cy minC=2 n=116542}
increment.inc: bms[1]={min=146cy mean=165cy minC=26 n=116542}
increment.inc: bms[2]={min=148cy mean=167cy minC=48 n=116542}
increment.inc: bms[3]={min=150cy mean=170cy minC=2 n=116542}
increment.inc: bms[4]={min=152cy mean=183cy minC=1 n=116542}
increment.atomicInc: bms[0]={min=150cy mean=177cy minC=1 n=115241}
increment.atomicInc: bms[1]={min=158cy mean=180cy minC=37 n=115241}
increment.atomicInc: bms[2]={min=158cy mean=183cy minC=1 n=115241}
increment.atomicInc: bms[3]={min=160cy mean=185cy minC=1 n=115241}
increment.atomicInc: bms[4]={min=170cy mean=194cy minC=254 n=115241}
```
Lets make one final change lets make this a release build. What
a huge difference the cycles is now 16cy for inc and 26cy for
atomicInc and we see that  minC is not a miniscule number
so we have a very high confidence that in a release build even
with threading enabled an inc takes 16cy and atomicInc is 26cy.
```
$ nim c -d:release --threads:on --hints:off exmpl/bminc2.nim
CC: benchmark_bminc2
CC: stdlib_system
CC: benchmark_benchmark
CC: stdlib_algorithm
CC: stdlib_math
CC: stdlib_times
CC: stdlib_strutils
CC: stdlib_parseutils
CC: stdlib_os
CC: stdlib_posix
[Linking]
$ exmpl/bmrun2
increment.inc: bms[0]={min=16cy mean=18cy minC=314358 n=390304}
increment.inc: bms[1]={min=16cy mean=20cy minC=256916 n=390304}
increment.inc: bms[2]={min=16cy mean=22cy minC=151829 n=390304}
increment.inc: bms[3]={min=16cy mean=27cy minC=65869 n=390304}
increment.inc: bms[4]={min=16cy mean=30cy minC=16848 n=390304}
increment.atomicInc: bms[0]={min=26cy mean=31cy minC=116704 n=355885}
increment.atomicInc: bms[1]={min=26cy mean=37cy minC=12701 n=355885}
increment.atomicInc: bms[2]={min=26cy mean=42cy minC=986 n=355885}
increment.atomicInc: bms[3]={min=26cy mean=44cy minC=2 n=355885}
increment.atomicInc: bms[4]={min=28cy mean=48cy minC=2733 n=355885}
```
