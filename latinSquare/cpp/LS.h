#include <vector>
#include <iostream>
#include <sstream>
#include <fstream>
#include <cmath>
#include <algorithm>

using namespace std;

#define RECCORD_REP "reccord/"

class LS {

    int _dim;
    int _size;
    vector< vector<int> > _values;


    public:
    LS (vector< vector<int> > values);
    LS (int dim, int size);
    string toString();
    double computeMinDist();
    double computeDist( vector<int> point1, vector<int> point2 ); 
    void writeLS(string fileName);
    void readLS(string fileName);
    void updateBest();
    void writeBest(double val, string fileName="");
    double readBest(string fileName="");
    void genRand();




};
