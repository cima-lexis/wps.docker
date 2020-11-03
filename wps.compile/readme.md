ADMS chain requires WRF to be compiled with a custom `Registry/Registry.EM_COMMON` file, in order to customize
variables emitted in output files.

Below is a diff between the original WRF 4.1.1 registry file and the custom one we need:

```
398,399c398,399
< state    real   TH2              ij     misc        1         -     irhdu     "TH2"                  "POT TEMP at 2 M"   "K"
< state    real   PSFC             ij     misc        1         -     i01rh01du   "PSFC"                 "SFC PRESSURE"      "Pa"
---
> state    real   TH2              ij     misc        1         -     irh{22}{23}du     "TH2"                  "POT TEMP at 2 M"   "K"
> state    real   PSFC             ij     misc        1         -     i01rh01{22}{23}du   "PSFC"                 "SFC PRESSURE"      "Pa"
406c406
< state    real   LPI              ij     misc        1         -     rhdu   "LPI"                 "Lightning Potential Index"      "m^2 s-2"
---
> state    real   LPI              ij     misc        1         -     rh01{22}{23}du   "LPI"                 "Lightning Potential Index"      "m^2 s-2"
782c782
< state    real   GRDFLX           ij     misc        1         -      rh                                         "GRDFLX"           "GROUND HEAT FLUX" "W m-2"
---
> state    real   GRDFLX           ij     misc        1         -      rh{22}{23}                                         "GRDFLX"           "GROUND HEAT FLUX" "W m-2"
786c786
< state    real   ACSNOW           ij     misc        1         -      rd=(interp_mask_field:lu_index,iswater)u=(copy_fcnm)       "ACSNOW"           "ACCUMULATED SNOW"         "kg m-2"
---
> state    real   ACSNOW           ij     misc        1         -      rh0{22}{23}d=(interp_mask_field:lu_index,iswater)u=(copy_fcnm)       "ACSNOW"           "ACCUMULATED SNOW"         "kg m-2"
1159c1159
< state  real   DUST2    idjf aerosolc    2    -   -     "DUST2"        "DUST2 aerosol concentration"
---
> P
1245c1245
< state   real    ht             ij      misc         1         -     i012rh056dus  "HGT"              "Terrain Height"   "m"
---
> state   real    ht             ij      misc         1         -     i012rh01{22}{23}56dus  "HGT"              "Terrain Height"   "m"
1255c1255
< state   real    TSK            ij      misc         1         -     i012rhd=(interp_mask_field:lu_index,iswater)u=(copy_fcnm)    "TSK"                   "SURFACE SKIN TEMPERATURE"                  "K"
---
> state   real    TSK            ij      misc         1         -     i012rh{22}{23}d=(interp_mask_field:lu_index,iswater)u=(copy_fcnm)    "TSK"         "SURFACE SKIN TEMPERATURE"                  "K"
1416,1418c1416,1418
< state    real  RAINC            ij      misc        1         -      rh01du   "RAINC"                 "ACCUMULATED TOTAL CUMULUS PRECIPITATION"                 "mm"      
< state    real  RAINSH           ij      misc        1         -      rh01du   "RAINSH"                "ACCUMULATED SHALLOW CUMULUS PRECIPITATION"               "mm"
< state    real  RAINNC           ij      misc        1         -      rh01du   "RAINNC"                "ACCUMULATED TOTAL GRID SCALE PRECIPITATION"              "mm"      
---
> state    real  RAINC            ij      misc        1         -      rh01{22}{23}du   "RAINC"                 "ACCUMULATED TOTAL CUMULUS PRECIPITATION"                 "mm"      
> state    real  RAINSH           ij      misc        1         -      rh01{22}{23}du   "RAINSH"                "ACCUMULATED SHALLOW CUMULUS PRECIPITATION"               "mm"
> state    real  RAINNC           ij      misc        1         -      rh01{22}{23}du   "RAINNC"                "ACCUMULATED TOTAL GRID SCALE PRECIPITATION"              "mm"      
1427,1429c1427,1429
< state    real  SNOWNC           ij      misc        1         -      rhdu     "SNOWNC"                "ACCUMULATED TOTAL GRID SCALE SNOW AND ICE"               "mm"
< state    real  GRAUPELNC        ij      misc        1         -      rhdu     "GRAUPELNC"             "ACCUMULATED TOTAL GRID SCALE GRAUPEL"                    "mm"
< state    real  HAILNC           ij      misc        1         -      rhdu     "HAILNC"                "ACCUMULATED TOTAL GRID SCALE HAIL"                       "mm"
---
> state    real  SNOWNC           ij      misc        1         -      rh01{22}{23}du     "SNOWNC"                "ACCUMULATED TOTAL GRID SCALE SNOW AND ICE"               "mm"
> state    real  GRAUPELNC        ij      misc        1         -      rh01{22}{23}du     "GRAUPELNC"             "ACCUMULATED TOTAL GRID SCALE GRAUPEL"                    "mm"
> state    real  HAILNC           ij      misc        1         -      rh01{22}{23}du     "HAILNC"                "ACCUMULATED TOTAL GRID SCALE HAIL"                       "mm"
1540,1541c1540,1541
< state    real  SWDOWN           ij      misc        1         -      rhd      "SWDOWN"                "DOWNWARD SHORT WAVE FLUX AT GROUND SURFACE"           "W m-2"      
< state    real  SWDOWNC          ij      misc        1         -      -        "SWDOWNC"               "DOWNWARD CLEAR-SKY SHORT WAVE FLUX AT GROUND SURFACE"           "W m-2"      
---
> state    real  SWDOWN           ij      misc        1         -      rh0{22}{23}d      "SWDOWN"                "DOWNWARD SHORT WAVE FLUX AT GROUND SURFACE"           "W m-2"      
> state    real  SWDOWNC          ij      misc        1         -      rh0{22}{23}d        "SWDOWNC"               "DOWNWARD CLEAR-SKY SHORT WAVE FLUX AT GROUND SURFACE"           "W m-2"      
1543c1543
< state    real  GLW              ij      misc        1         -      rhd      "GLW"                   "DOWNWARD LONG WAVE FLUX AT GROUND SURFACE"            "W m-2"      
---
> state    real  GLW              ij      misc        1         -      rh01{22}{23}d      "GLW"                   "DOWNWARD LONG WAVE FLUX AT GROUND SURFACE"            "W m-2"      
1674c1674
< state    real  ALBEDO           ij      misc        1         -      rh          "ALBEDO"                   "ALBEDO"
---
> state    real  ALBEDO           ij      misc        1         -      rh{22}{23}          "ALBEDO"                   "ALBEDO"
1678c1678
< state    real  EMISS            ij      misc        1         -      rh       "EMISS"                 "SURFACE EMISSIVITY"         "" 
---
> state    real  EMISS            ij      misc        1         -      rh{22}{23}       "EMISS"                 "SURFACE EMISSIVITY"         "" 
1778c1778
< state    real  ZNT              ij      misc        1         -      i3r     "ZNT"                   "TIME-VARYING ROUGHNESS LENGTH"                "m"      
---
> state    real  ZNT              ij      misc        1         -      i3rh01{22}{23}     "ZNT"                   "TIME-VARYING ROUGHNESS LENGTH"                "m"      
1783c1783,1784
< state    real  UST              ij      misc        1         -      rh       "UST"                   "U* IN SIMILARITY THEORY"                      "m s-1"      
---
> state    real  UST              ij      misc        1         -      rh01{22}{23}       "UST"                   "U* IN SIMILARITY THEORY"                      "m s-1"      
> #state    real  UST              ij      misc        1         -      rh       "UST"                   "U* IN SIMILARITY THEORY"                      "m s-1"      
1788c1789
< state    real  PBLH             ij      misc        1         -      rh       "PBLH"                  "PBL HEIGHT"         "m"      
---
> state    real  PBLH             ij      misc        1         -      rh{22}{23}       "PBLH"                  "PBL HEIGHT"         "m"      
1791,1793c1792,1794
< state    real  HFX              ij      misc        1         -      rh       "HFX"                   "UPWARD HEAT FLUX AT THE SURFACE"              "W m-2"      
< state    real  QFX              ij      misc        1         -      rh       "QFX"                   "UPWARD MOISTURE FLUX AT THE SURFACE"          "kg m-2 s-1"      
< state    real  LH               ij      misc        1         -      rh       "LH"                    "LATENT HEAT FLUX AT THE SURFACE"              "W m-2"
---
> state    real  HFX              ij      misc        1         -      rh{22}{23}       "HFX"                   "UPWARD HEAT FLUX AT THE SURFACE"              "W m-2"      
> state    real  QFX              ij      misc        1         -      rh{22}{23}       "QFX"                   "UPWARD MOISTURE FLUX AT THE SURFACE"          "kg m-2 s-1"      
> state    real  LH               ij      misc        1         -      rh{22}{23}       "LH"                    "LATENT HEAT FLUX AT THE SURFACE"              "W m-2"
1909,1916c1910,1917
< state    real    WSPD10MAX        ij     misc        1         -      rh02       "WSPD10MAX"      "WIND SPD MAX 10 M"       "m s-1"
< state    real    W_UP_MAX         ij     misc        1         -      rh02       "W_UP_MAX"       "MAX Z-WIND UPDRAFT"      "m s-1"
< state    real    W_DN_MAX         ij     misc        1         -      rh02       "W_DN_MAX"       "MAX Z-WIND DOWNDRAFT"    "m s-1"
< state    real    REFD_MAX         ij     misc        1         -      rh02       "REFD_MAX"       "MAX DERIVED RADAR REFL"  "dbZ"
< state    real    UP_HELI_MAX      ij     misc        1         -      rh02       "UP_HELI_MAX"    "MAX UPDRAFT HELICITY"    "m2 s-2"
< state    real    W_MEAN           ij     misc        1         -      rh         "W_MEAN"         "HOURLY MEAN Z-WIND"      "m s-1"
< state    real    GRPL_MAX         ij     misc        1         -      rh         "GRPL_MAX"       "MAX COL INT GRAUPEL"     "kg m-2"
< state    real    UH               ij     misc        1         -      r          "UH"             "UPDRAFT HELICITY"        "m2 s-2"
---
> state    real    WSPD10MAX        ij     misc        1         -      rh02{22}{23}       "WSPD10MAX"      "WIND SPD MAX 10 M"       "m s-1"
> state    real    W_UP_MAX         ij     misc        1         -      rh02{22}{23}       "W_UP_MAX"       "MAX Z-WIND UPDRAFT"      "m s-1"
> state    real    W_DN_MAX         ij     misc        1         -      rh02{22}{23}       "W_DN_MAX"       "MAX Z-WIND DOWNDRAFT"    "m s-1"
> state    real    REFD_MAX         ij     misc        1         -      rh02{22}{23}       "REFD_MAX"       "MAX DERIVED RADAR REFL"  "dbZ"
> state    real    UP_HELI_MAX      ij     misc        1         -      rh02{22}{23}       "UP_HELI_MAX"    "MAX UPDRAFT HELICITY"    "m2 s-2"
> state    real    W_MEAN           ij     misc        1         -      rh{22}{23}         "W_MEAN"         "HOURLY MEAN Z-WIND"      "m s-1"
> state    real    GRPL_MAX         ij     misc        1         -      rh{22}{23}         "GRPL_MAX"       "MAX COL INT GRAUPEL"     "kg m-2"
> state    real    UH               ij     misc        1         -      r{22}{23}          "UH"             "UPDRAFT HELICITY"        "m2 s-2"
1921c1922
< state    real    HAIL_MAX2D       ij     misc        1         -      rh02       "HAIL_MAX2D"     "MAX HAIL DIAMETER ENTIRE COLUMN"   "m"
---
> state    real    HAIL_MAX2D       ij     misc        1         -      rh02{22}{23}       "HAIL_MAX2D"     "MAX HAIL DIAMETER ENTIRE COLUMN"   "m"
1925,1927c1926,1928
< state   real  prec_acc_c       ij       misc        1         -     rhdu     "prec_acc_c"       "ACCUMULATED CUMULUS PRECIPITATION OVER prec_acc_dt PERIODS OF TIME"       "mm"
< state   real  prec_acc_nc      ij       misc        1         -     rhdu     "prec_acc_nc"      "ACCUMULATED GRID SCALE  PRECIPITATION OVER prec_acc_dt PERIODS OF TIME"   "mm"
< state   real  snow_acc_nc      ij       misc        1         -     rhdu     "snow_acc_nc"      "ACCUMULATED SNOW WATER EQUIVALENT OVER prec_acc_dt PERIODS OF TIME"       "mm"
---
> state   real  prec_acc_c       ij       misc        1         -     rhdu{22}{23}     "prec_acc_c"       "ACCUMULATED CUMULUS PRECIPITATION OVER prec_acc_dt PERIODS OF TIME"       "mm"
> state   real  prec_acc_nc      ij       misc        1         -     rhdu{22}{23}     "prec_acc_nc"      "ACCUMULATED GRID SCALE  PRECIPITATION OVER prec_acc_dt PERIODS OF TIME"   "mm"
> state   real  snow_acc_nc      ij       misc        1         -     rhdu{22}{23}     "snow_acc_nc"      "ACCUMULATED SNOW WATER EQUIVALENT OVER prec_acc_dt PERIODS OF TIME"       "mm"
3015,3017c3016,3018
< state    real   HAILCAST_DIAM_MAX   ij   misc        1         -      h02       "HAILCAST_DIAM_MAX"   "WRF-HAILCAST MAX Hail Diameter"        "mm"
< state    real   HAILCAST_DIAM_MEAN  ij   misc        1         -      -          "HAILCAST_DIAM_MEAN"  "WRF-HAILCAST Mean Hail Diameter"        "mm"
< state    real   HAILCAST_DIAM_STD   ij   misc        1         -      -          "HAILCAST_DIAM_STD"   "WRF-HAILCAST Stand. Dev. Hail Diameter" "mm"
---
> state    real   HAILCAST_DIAM_MAX   ij   misc        1         -      h02{22}{23}       "HAILCAST_DIAM_MAX"   "WRF-HAILCAST MAX Hail Diameter"        "mm"
> state    real   HAILCAST_DIAM_MEAN  ij   misc        1         -      rh0{22}{23}          "HAILCAST_DIAM_MEAN"  "WRF-HAILCAST Mean Hail Diameter"        "mm"
> state    real   HAILCAST_DIAM_STD   ij   misc        1         -      rh0{22}{23}          "HAILCAST_DIAM_STD"   "WRF-HAILCAST Stand. Dev. Hail Diameter" "mm"

```
