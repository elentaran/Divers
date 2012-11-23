#include <iostream>

#include "randLSfinder.h"

using namespace std;

int main() {
    srand(unsigned(time(NULL)));
    cout << "coucou" << endl;
    randLSfinder* myLSfinder = new randLSfinder(2,4);
    LS* test = myLSfinder->findLS();
    cout << test->toString() << endl;
    cout << test->computeMinDist() << endl;

    return 0;
}
