⟨SaveNpy,LoadNpy⟩⇐

lf←@+10
magicString←(@+147)∾"NUMPY"

# Type conversions
dtypes‿formats←⟨"<f8","<i4","<u4"⟩‿⟨64‿'f',32‿'i',32‿'u'⟩
DtypeToFormat←{(⊑dtypes⊐<𝕩)⊑formats}
ArrayToBytes←{⟨DtypeToFormat 𝕨,8‿'c'⟩•bit._cast 𝕩}
ArrayFromBytes←{⟨8‿'c',DtypeToFormat 𝕨⟩•bit._cast 𝕩}

# Saving
To_i16le←{@+256(|∾⌊∘÷˜)𝕩}
FormatShape←{'('∾(1↓∾⥊','∾˘•Fmt¨≢𝕩)∾')'}

BuildHeader←{dtype 𝕊 data:
  version←1‿0
  # Hypothesis: BQN arrays are C-contiguous
  headerData←"{'descr':'"∾dtype∾"','fortran_order':False,'shape':"∾(FormatShape data)∾",}"
  padding←' '↑˜64-64|(≠magicString)+2+2+(≠headerData)+1
  ! 0=64|(≠magicString)+2+2+(≠padding)+(≠headerData)+1
  headerDataPadded←headerData∾padding∾lf
  magicString∾(@+version)∾(To_i16le ≠headerDataPadded)∾headerDataPadded
}
DetectDtype←{(∧´⥊⌊⊸=¨𝕩)⊑⟨"<f8",(∧´⥊0≤𝕩)⊑"<i4"‿"<u4"⟩}
EncodeNpy←DetectDtype⊸(BuildHeader∾ArrayToBytes⟜⥊)
SaveNpy←•file.Bytes⟜EncodeNpy

# Loading
ParseHeader←{𝕊𝕩:
  "Not a valid NPY file"! magicString≡(≠magicString)↑𝕩
  version←@-˜(0‿1+≠magicString)⊏𝕩
  headerlen←+´1‿256×@-˜(2‿3+≠magicString)⊏𝕩
  header←(¬∊⟜(' '∾lf))⊸/headerlen↑(4+≠magicString)↓𝕩
  dtype←3↑(⌊´∘⊐⟜"<>"↓⊢) (("descr"⍷header)⊐1)↓header
  ("Unsupported dtype: "∾dtype) ! ⊑(<dtype)∊dtypes
  shapestr←(⊐⟜')'↑⊢) (1⊸+∘⊐⟜'('↓⊢) (("shape"⍷header)⊐1)↓header
  shape←•BQN¨','((⊢-˜+`×¬)∘=⊔⊢)shapestr
  ⟨version,dtype,shape,headerlen+2+2+≠magicString⟩
}

LoadNpy←{𝕊𝕩:
  bytes←•file.Bytes 𝕩
  version‿dtype‿shape‿datastart←ParseHeader bytes
  shape⥊dtype ArrayFromBytes datastart↓bytes
}
