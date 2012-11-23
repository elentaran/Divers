#include "randLSfinder.h"


LS* randLSfinder::findLS(int nbTry /*=100*/, double time /*=0*/) {


    LS* curLS = new LS(_dim,_size);
    LS* res;
    double bestDistMax=0;
    double currentDist;

    for (int i=0; i<nbTry; i++) {
        curLS->genRand();
        currentDist = curLS->computeMinDist();
        if (currentDist > bestDistMax) {
            bestDistMax = currentDist;
            res = new LS(*curLS);
        }
        
    }
    return res;

}
