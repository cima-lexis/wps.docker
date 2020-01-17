gfortran TEST_1_fortran_only_fixed.f &&
./a.out &&
gfortran TEST_2_fortran_only_free.f90 &&
./a.out &&
gcc TEST_3_c_only.c &&
./a.out &&
gcc -c -m64 TEST_4_fortran+c_c.c &&
./a.out &&
gfortran -c -m64 TEST_4_fortran+c_f.f90 &&
./a.out &&
gfortran -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o &&
./a.out &&
./TEST_csh.csh &&
./TEST_perl.pl &&
./TEST_sh.sh


#ar             head              sed
#awk          hostname      sleep
#cat            ln                  sort
#cd             ls                  tar
#cp             make            touch
#cut            mkdir            tr
#expr          mv                uname
#file             nm                wc
#grep          printf             which
#gzip           rm                   m4
#
