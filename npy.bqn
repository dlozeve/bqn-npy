⟨SaveNpy,LoadNpy⟩⇐

lf←@+10
magicString←(@+147)∾"NUMPY"  # "\x93NUMPY"

To_i16le←{@+256(|∾⌊∘÷˜)𝕩}
# To_i16le←⟨16,8‿'c'⟩•bit._cast∘≍  # assumes the platform is little-endian
FloatToBytes←⟨64,8‿'c'⟩•bit._cast

FormatShape←{'('∾(1↓∾⥊','∾˘•Fmt¨≢𝕩)∾')'}

BuildHeader←{𝕊𝕩:
  version←1‿0
  # Hypothesis: BQN arrays are C-contiguous
  headerData←"{'descr': '<f8', 'fortran_order': False, 'shape': "∾(FormatShape 𝕩)∾", }"
  padding←' '↑˜64-64|(≠magicString)+2+2+(≠headerData)+1
  ! 0=64|(≠magicString)+2+2+(≠padding)+(≠headerData)+1
  headerDataPadded←headerData∾padding∾lf
  magicString∾(@+version)∾(To_i16le ≠headerDataPadded)∾headerDataPadded
}

EncodeNpy←BuildHeader∾FloatToBytes∘⥊

SaveNpy←•file.Bytes⟜EncodeNpy

ParseHeader←{𝕊𝕩:
  "Not a valid NPY file"! magicString≡(≠magicString)↑𝕩
  version←@-˜(0‿1+≠magicString)⊏𝕩
  headerlen←+´1‿256×@-˜(2‿3+≠magicString)⊏𝕩
  header←(¬∊⟜(' '∾lf))⊸/headerlen↑(4+≠magicString)↓𝕩
  shapestr←(⊐⟜')'↑⊢) (1⊸+∘⊐⟜'('↓⊢) (("shape"⍷header)⊐1)↓header
  shape←•BQN¨','((⊢-˜+`×¬)∘=⊔⊢)shapestr
  ⟨version,shape,headerlen+2+2+≠magicString⟩
}

LoadNpy←{𝕊𝕩:
  bytes←•file.Bytes 𝕩
  version‿shape‿datastart←ParseHeader bytes
  shape⥊⟨8‿'c',64‿'f'⟩•bit._cast datastart↓bytes
}
