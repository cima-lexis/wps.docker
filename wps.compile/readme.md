ADMS chain requires WRF to be compiled with a custom `Registry/Registry.EM_COMMON` file, in order to customize
variables emitted in output files.

Below is a diff between the original WRF 4.1.1 registry file and the custom one we need:

```
[aparodi@login2.salomon WRF-4.1.1]$ diff Registry/Registry.EM_COMMON.original Registry/Registry.EM_COMMON 
399c399,400
< state    real   PSFC             ij     misc        1         -     i01rh01du   "PSFC"                 "SFC PRESSURE"      "Pa"
---
> #state    real   PSFC             ij     misc        1         -     i01rh01du   "PSFC"                 "SFC PRESSURE"      "Pa"
> state    real   PSFC             ij     misc        1         -     i01rh0{22}{23}du   "PSFC"                 "SFC PRESSURE"      "Pa"
719c720,721
< state    real   TSLB           ilj       misc      1         Z     i02rhd=(interp_mask_field:lu_index,iswater)u=(copy_fcnm)           "TSLB"     "SOIL TEMPERATURE"   "K"
---
> #state    real   TSLB           ilj       misc      1         Z     i02rhd=(interp_mask_field:lu_index,iswater)u=(copy_fcnm)           "TSLB"     "SOIL TEMPERATURE"   "K"
> state    real   TSLB           ilj       misc      1         Z     i01rh0{22}{23}du          "TSLB"     "SOIL TEMPERATURE"   "K"
1542,1543c1544,1547
< state    real  GSW              ij      misc        1         -      rd       "GSW"                   "NET SHORT WAVE FLUX AT GROUND SURFACE"           "W m-2"      
< state    real  GLW              ij      misc        1         -      rhd      "GLW"                   "DOWNWARD LONG WAVE FLUX AT GROUND SURFACE"            "W m-2"      
---
> state    real  GSW              ij      misc        1         -      rh0{22}{23}d       "GSW"                   "NET SHORT WAVE FLUX AT GROUND SURFACE"           "W m-2"      
> #state    real  GSW              ij      misc        1         -      rd       "GSW"                   "NET SHORT WAVE FLUX AT GROUND SURFACE"           "W m-2"      
> state    real  GLW              ij      misc        1         -      rh0{22}{23}d      "GLW"                   "DOWNWARD LONG WAVE FLUX AT GROUND SURFACE"            "W m-2"      
> #state    real  GLW              ij      misc        1         -      rhd      "GLW"                   "DOWNWARD LONG WAVE FLUX AT GROUND SURFACE"            "W m-2"      
1783c1787,1789
< state    real  UST              ij      misc        1         -      rh       "UST"                   "U* IN SIMILARITY THEORY"                      "m s-1"      
---
> #state    real  UST              ij      misc        1         -      rh       "UST"                   "U* IN SIMILARITY THEORY"                      "m s-1" 
> state     real  UST              ij      misc        1         -     rh0{22}{23}      "UST"           "U* IN SIMILARITY THEORY"                "m s-1"
> 
```
