# Constantine
# Copyright (c) 2018-2019    Status Research & Development GmbH
# Copyright (c) 2020-Present Mamy André-Ratsimbazafy
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

# ############################################################
#
#           Benchmark of modular exponentiation
#
# ############################################################

# 2 implementations are available
# - 1 is constant time
# - 1 exposes the exponent bits to:
#   timing attack,
#   memory access analysis,
#   power analysis (i.e. oscilloscopes on embedded)
#   It is suitable for public exponents for example
#   to compute modular inversion via the Fermat method

import
  ../constantine/config/[common, curves],
  ../constantine/math/[bigints_checked, finite_fields],
  ../constantine/io/[io_bigints, io_fields],
  random, std/monotimes, times, strformat

const Iters = 10_000

randomize(1234)

proc mainCT() =
  var x: Fq[BLS12_381]
  # BN254 field modulus
  x.fromHex("0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47")
  # BLS12-381 prime - 2
  let exponent = BigInt[381].fromHex("0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaa9")

  let start = getMonotime()
  for _ in 0 ..< Iters:
    var y = x
    x.pow(exponent)
  let stop = getMonotime()

  echo &"Time for {Iters} iterations (constant-time 381-bit): {inMilliseconds(stop-start)} ms"

proc mainUnsafe() =
  var x: Fq[BLS12_381]
  # BN254 field modulus
  x.fromHex("0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47")
  # BLS12-381 prime - 2
  let exponent = BigInt[381].fromHex("0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaa9")

  let start = getMonotime()
  for _ in 0 ..< Iters:
    var y = x
    x.powUnsafeExponent(exponent)
  let stop = getMonotime()

  echo &"Time for {Iters} iterations (unsafe 381-bit): {inMilliseconds(stop-start)} ms"

mainCT()
mainUnsafe()
# 10_000 iterations with -d:danger on i9-9980XE all-core turbo 4.1GHz

# Time for 10000 iterations (constant-time 381-bit): 1349 ms
# Time for 10000 iterations (unsafe 381-bit): 1226 ms
