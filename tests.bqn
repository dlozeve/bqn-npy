⟨SaveNpy,LoadNpy⟩←•Import"npy.bqn"

a←3‿4‿5•rand.Range 0
"testbqn.npy"SaveNpy a
b←LoadNpy"testbqn.npy"
! a≡○≢b
! a≡b

floatArr←2‿3•rand.Range 0
intArr←50-˜2‿3•rand.Range 100
uintArr←2‿3•rand.Range 100

"test_float.npy"SaveNpy floatArr
"test_int.npy"SaveNpy intArr
"test_uint.npy"SaveNpy uintArr

floatArr≡LoadNpy"test_float.npy"
intArr≡LoadNpy"test_int.npy"
uintArr≡LoadNpy"test_uint.npy"
