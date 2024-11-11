⟨SaveNpy,LoadNpy⟩←•Import"npy.bqn"

floatArr←2‿3•rand.Range 0
intArr←(2⋆31)-˜2‿3•rand.Range 2⋆32
uintArr←2‿3•rand.Range 2⋆31

"test_float.npy"SaveNpy floatArr
"test_int.npy"SaveNpy intArr
"test_uint.npy"SaveNpy uintArr

! floatArr≡LoadNpy"test_float.npy"
! intArr≡LoadNpy"test_int.npy"
! uintArr≡LoadNpy"test_uint.npy"

# Supported dtypes
ref←2‿3‿4⥊0
! ref≡LoadNpy"test<f8.npy"
! ref≡LoadNpy"test<i4.npy"
! ref≡LoadNpy"test<u4.npy"
# Unsupported dtypes, should raise an error
! LoadNpy⎊1"test<f4.npy"
! LoadNpy⎊1"test<i8.npy"
! LoadNpy⎊1"test<u8.npy"
! LoadNpy⎊1"test>f4.npy"
! LoadNpy⎊1"test>f8.npy"
! LoadNpy⎊1"test>i4.npy"
! LoadNpy⎊1"test>i8.npy"
! LoadNpy⎊1"test>u4.npy"
! LoadNpy⎊1"test>u8.npy"

