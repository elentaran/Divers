#include "LS.h"

class LSfinder {

    protected:
    int _dim;
    int _size;

    public:
    LSfinder(int dim, int size) {
        _dim = dim;
        _size = size;
    };
    virtual LS* findLS(int nbTry, double time) = 0;

};
