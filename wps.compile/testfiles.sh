ifort TEST_1_fortran_only_fixed.f &&
./a.out &&
ifort TEST_2_fortran_only_free.f90 &&
./a.out &&
icc TEST_3_c_only.c &&
./a.out &&
icc -c -m64 TEST_4_fortran+c_c.c &&
./a.out &&
ifort -c -m64 TEST_4_fortran+c_f.f90 &&
./a.out &&
ifort -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o &&
./a.out &&
./TEST_csh.csh &&
./TEST_perl.pl &&
./TEST_sh.sh
