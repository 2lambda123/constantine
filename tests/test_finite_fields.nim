# Constantine
# Copyright (c) 2018-2019    Status Research & Development GmbH
# Copyright (c) 2020-Present Mamy André-Ratsimbazafy
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

import  unittest, random,
        ../constantine/math/finite_fields,
        ../constantine/io/io_fields,
        ../constantine/config/curves

import ../constantine/io/io_bigints

static: doAssert defined(testingCurves), "This modules requires the -d:testingCurves compile option"

proc main() =
  suite "Basic arithmetic over finite fields":
    test "Addition mod 101":
      block:
        var x, y, z: Fq[Fake101]

        x.fromUint(80'u32)
        y.fromUint(10'u32)
        z.fromUint(90'u32)

        x += y

        var x_bytes: array[8, byte]
        x_bytes.serializeRawUint(x, cpuEndian)

        check:
          # Check equality in the Montgomery domain
          bool(z == x)
          # Check equality when converting back to natural domain
          90'u64 == cast[uint64](x_bytes)

      block:
        var x, y, z: Fq[Fake101]

        x.fromUint(80'u32)
        y.fromUint(21'u32)
        z.fromUint(0'u32)

        x += y
        check: bool(z == x)

      block:
        var x, y, z: Fq[Fake101]

        x.fromUint(80'u32)
        y.fromUint(22'u32)
        z.fromUint(1'u32)

        x += y

        var x_bytes: array[8, byte]
        x_bytes.serializeRawUint(x, cpuEndian)

        check:
          # Check equality in the Montgomery domain
          bool(z == x)
          # Check equality when converting back to natural domain
          1'u64 == cast[uint64](x_bytes)

    test "Substraction mod 101":
      block:
        var x, y, z: Fq[Fake101]

        x.fromUint(80'u32)
        y.fromUint(10'u32)
        z.fromUint(70'u32)

        x -= y

        var x_bytes: array[8, byte]
        x_bytes.serializeRawUint(x, cpuEndian)

        check:
          # Check equality in the Montgomery domain
          bool(z == x)
          # Check equality when converting back to natural domain
          70'u64 == cast[uint64](x_bytes)

      block:
        var x, y, z: Fq[Fake101]

        x.fromUint(80'u32)
        y.fromUint(80'u32)
        z.fromUint(0'u32)

        x -= y

        var x_bytes: array[8, byte]
        x_bytes.serializeRawUint(x, cpuEndian)

        check:
          # Check equality in the Montgomery domain
          bool(z == x)
          # Check equality when converting back to natural domain
          0'u64 == cast[uint64](x_bytes)

      block:
        var x, y, z: Fq[Fake101]

        x.fromUint(80'u32)
        y.fromUint(81'u32)
        z.fromUint(100'u32)

        x -= y

        var x_bytes: array[8, byte]
        x_bytes.serializeRawUint(x, cpuEndian)

        check:
          # Check equality in the Montgomery domain
          bool(z == x)
          # Check equality when converting back to natural domain
          100'u64 == cast[uint64](x_bytes)

main()
