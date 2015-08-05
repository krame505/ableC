#!/bin/bash

PassMsg="passed"
FailMsg="failed"
AllPassed=1

echo "----------------------------------------------------------------------"
echo "-- Testing edu:umn:cs:melt:exts:ableC:adt                           --"
echo "----------------------------------------------------------------------"

if [[ $@ =~ "--no-build" ]]; then
    echo "Not building the AbleC artifact."
else
    echo "test: ./build --clean --warn-all"

    rm -f build.test.out
    ./build --clean --warn-all &> build.test.out

    if [ $? == 0 ]; then
	echo ${PassMsg}
    else
	echo ${FailMsg}
	AllPassed=0
    fi
fi


FILE="example1-expr-eval"

echo ""
echo "test: java -jar ableC.jar ${FILE}.xc"

rm -f ableC_${FILE}.test.out
java -jar ableC.jar ${FILE}.xc &> ableC_${FILE}.test.out

if [ $? == 0 ]; then
    echo ${PassMsg}
else
    echo ${FailMsg}
    AllPassed=0
fi


echo ""
echo "test: gcc ${FILE}.pp_out.c"

rm -f gcc_${FILE}.test.out
gcc ${FILE}.pp_out.c &> gcc_${FILE}.test.out

if [ $? == 0 ]; then
    echo ${PassMsg}
else
    echo ${FailMsg}
    AllPassed=0
fi


echo ""
echo "test: ./a.out"

rm -f run_${FILE}.test.out
./a.out &> run_${FILE}.test.out

if [ $? == 0 ]; then
    echo ${PassMsg}
else
    echo ${FailMsg}
    AllPassed=0
fi





FILE="example2-type-errors"

echo ""
echo "test: java -jar ableC.jar ${FILE}.xc"

rm -f ableC_${FILE}.test.out
java -jar ableC.jar ${FILE}.xc &> ableC_${FILE}.test.out

if [ $? != 0 ]; then
    echo ${PassMsg}
else
    echo ${FailMsg}
    AllPassed=0
fi




FILE="example3-corrected"

echo ""
echo "test: java -jar ableC.jar ${FILE}.xc"

rm -f ableC_${FILE}.test.out
java -jar ableC.jar ${FILE}.xc &> ableC_${FILE}.test.out

if [ $? == 0 ]; then
    echo ${PassMsg}
else
    echo ${FailMsg}
    AllPassed=0
fi


echo ""
echo "test: gcc ${FILE}.pp_out.c"

rm -f gcc_${FILE}.test.out
gcc ${FILE}.pp_out.c &> gcc_${FILE}.test.out

if [ $? == 0 ]; then
    echo ${PassMsg}
else
    echo ${FailMsg}
    AllPassed=0
fi


echo ""
echo "test: ./a.out"

rm -f run_${FILE}.test.out
./a.out &> run_${FILE}.test.out

if [ $? == 0 ]; then
    echo ${PassMsg}
else
    echo ${FailMsg}
    AllPassed=0
fi



echo ""
rm -f TESTS_FAILED
if [ ${AllPassed} = 1 ]; then
    echo "All tests passed."
else
    echo "Some tests failed."
    touch TESTS_FAILED
fi

