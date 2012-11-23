#include "LSfinder.h"

class randLSfinder: public LSfinder {

    public:
    randLSfinder(int dim, int size) : LSfinder(dim,size) {};
    LS* findLS(int nbTry=100, double time=0);

};
