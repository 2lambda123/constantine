# Constantine
# Copyright (c) 2018-2019    Status Research & Development GmbH
# Copyright (c) 2020-Present Mamy André-Ratsimbazafy
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

import
  # Internals
  ../constantine/config/curves,
  ../constantine/towers,
  # Helpers
  ../helpers/static_for,
  ./bench_fields_template,
  # Standard library
  std/strutils

# ############################################################
#
#                    Benchmark of 𝔽p6
#
# ############################################################


const Iters = 100_000
const InvIters = 1000
const AvailableCurves = [
  # Pairing-Friendly curves
  # BN254_Nogami,
  BN254_Snarks,
  BLS12_377,
  BLS12_381
  # BN446,
  # FKM12_447,
  # BLS12_461,
  # BN462
]

proc main() =
  separator()
  staticFor i, 0, AvailableCurves.len:
    const curve = AvailableCurves[i]
    addBench(Fp6[curve], Iters)
    subBench(Fp6[curve], Iters)
    negBench(Fp6[curve], Iters)
    mulBench(Fp6[curve], Iters)
    sqrBench(Fp6[curve], Iters)
    invBench(Fp6[curve], InvIters)
    separator()

main()
notes()
