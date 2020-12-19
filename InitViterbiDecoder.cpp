/*
* @ Driver File of the program 
*/
#include "vitdec.h"
#include <cstdlib>
#include <cassert>
#include <iostream>
using namespace std;

Trellis* getTrellis();
void tesTrellis(Trellis* trellis);
void testSmallSample(Trellis* trellis);

int main()
{
    Trellis* trellis = getTrellis();
    trellis->build();

    testSmallSample(trellis);

    delete trellis;

    return 0;
}

/*
 * From MATLAB:
 * trel = poly2trellis(3,[7 5]);
 * trel.nextStates = [
     0    32
     0    32
     1    33
     1    33
     2    34
     2    34
     3    35
     3    35
     4    36
     4    36
     5    37
     5    37
     6    38
     6    38
     7    39
     7    39
     8    40
     8    40
     9    41
     9    41
    10    42
    10    42
    11    43
    11    43
    12    44
    12    44
    13    45
    13    45
    14    46
    14    46
    15    47
    15    47
    16    48
    16    48
    17    49
    17    49
    18    50
    18    50
    19    51
    19    51
    20    52
    20    52
    21    53
    21    53
    22    54
    22    54
    23    55
    23    55
    24    56
    24    56
    25    57
    25    57
    26    58
    26    58
    27    59
    27    59
    28    60
    28    60
    29    61
    29    61
    30    62
    30    62
    31    63
    31    63];

 * trel.outputs    = 
   [ 0     3
     3     0
     2     1
     1     2
     3     0
     0     3
     1     2
     2     1
     3     0
     0     3
     1     2
     2     1
     0     3
     3     0
     2     1
     1     2
     0     3
     3     0
     2     1
     1     2
     3     0
     0     3
     1     2
     2     1
     3     0
     0     3
     1     2
     2     1
     0     3
     3     0
     2     1
     1     2
     1     2
     2     1
     3     0
     0     3
     2     1
     1     2
     0     3
     3     0
     2     1
     1     2
     0     3
     3     0
     1     2
     2     1
     3     0
     0     3
     1     2
     2     1
     3     0
     0     3
     2     1
     1     2
     0     3
     3     0
     2     1
     1     2
     0     3
     3     0
     1     2
     2     1
     3     0
     0     3]
 */
Trellis* getTrellis()
{
    Trellis* trellis = new Trellis();
    trellis->push_back(0, 32, 0, 3);
    trellis->push_back(0, 32, 3, 0);
    trellis->push_back(1, 33, 2, 1);
    trellis->push_back(1, 33, 1, 2);
    trellis->push_back(2, 34, 3, 0);
    trellis->push_back(2, 34, 0, 3);
    trellis->push_back(3, 35, 1, 2);
    trellis->push_back(3, 35, 2, 1);
    trellis->push_back(4, 36, 3, 0);
    trellis->push_back(4, 36, 0, 3);
    trellis->push_back(5, 37, 1, 2);
    trellis->push_back(5, 37, 2, 1);
    trellis->push_back(6, 38, 0, 3);
    trellis->push_back(6, 38, 3, 0);
    trellis->push_back(7, 39, 2, 1);
    trellis->push_back(7, 39, 1, 2);
    trellis->push_back(8, 40, 0, 3);
    trellis->push_back(8, 40, 3, 0);
    trellis->push_back(9, 41, 2, 1);
    trellis->push_back(9, 41, 1, 2);
    trellis->push_back(10, 42, 3, 0);
    trellis->push_back(10, 42, 0, 3);
    trellis->push_back(11, 43, 1, 2);
    trellis->push_back(11, 43, 2, 1);
    trellis->push_back(12, 44, 3, 0);
    trellis->push_back(12, 44, 0, 3);
    trellis->push_back(13, 45, 1, 2);
    trellis->push_back(13, 45, 2, 1);
    trellis->push_back(14, 46, 0, 3);
    trellis->push_back(14, 46, 3, 0);
    trellis->push_back(15, 47, 2, 1);
    trellis->push_back(15, 47, 1, 2);
    trellis->push_back(16, 48, 1, 2);
    trellis->push_back(16, 48, 2, 1);
    trellis->push_back(17, 49, 3, 0);
    trellis->push_back(17, 49, 0, 3);
    trellis->push_back(18, 50, 2, 1);
    trellis->push_back(18, 50, 1, 2);
    trellis->push_back(19, 51, 0, 3);
    trellis->push_back(19, 51, 3, 0);
    trellis->push_back(20, 52, 2, 1);
    trellis->push_back(20, 52, 1, 2);
    trellis->push_back(21, 53, 0, 3);
    trellis->push_back(21, 53, 3, 0);
    trellis->push_back(22, 54, 1, 2);
    trellis->push_back(22, 54, 2, 1);
    trellis->push_back(23, 55, 3, 0);
    trellis->push_back(23, 55, 0, 3);
    trellis->push_back(24, 56, 1, 2);
    trellis->push_back(24, 56, 2, 1);
    trellis->push_back(25, 57, 3, 0);
    trellis->push_back(25, 57, 0, 3);
    trellis->push_back(26, 58, 2, 1);
    trellis->push_back(26, 58, 1, 2);
    trellis->push_back(27, 59, 0, 3);
    trellis->push_back(27, 59, 3, 0);
    trellis->push_back(28, 60, 2, 1);
    trellis->push_back(28, 60, 1, 2);
    trellis->push_back(29, 61, 0, 3);
    trellis->push_back(29, 61, 3, 0);
    trellis->push_back(30, 62, 1, 2);
    trellis->push_back(30, 62, 2, 1);
    trellis->push_back(31, 63, 3, 0);
    trellis->push_back(31, 63, 0, 3);

    return trellis;
}

void testSmallSample(Trellis* trellis)
{
    DataType outBits[] = { 0b01}; 
    const int numStages = sizeof(outBits) / sizeof(outBits[0]);

    vector<Bit> decoded;
    viterbiDecode(outBits, trellis, numStages, decoded);

    for (size_type i = 0; i < decoded.size(); i++)
        cout << decoded[i] << ' ';

    cout.flush();

}