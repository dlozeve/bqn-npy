⟨SaveNpy,LoadNpy⟩←•Import"npy.bqn"

a←3‿4‿5•rand.Range 0
"testbqn.npy"SaveNpy a
b←LoadNpy"testbqn.npy"
! a≡○≢b
! a≡b
