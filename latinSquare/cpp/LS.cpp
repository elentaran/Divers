#include "LS.h"

LS::LS(vector< vector<int> > values) {
    _values = values;
    _size = _values.size();
    _dim = _values[0].size();
}

LS::LS(int dim, int size) {
    _dim = dim;
    _size = size;
    vector <int> tempVec;
    for (int i=0;i<_dim;i++)
        tempVec.push_back(0);
    for (int i=0;i<_size;i++)
        _values.push_back(tempVec);
}

string LS::toString() {
    stringstream res;
    for (int i=0;i<_size;i++) {
        res << "[";
        for (int j=0;j<_dim;j++) {
            res << _values[i][j]; 
            if (j < (_dim-1))
                res << ",";
        }
        res << "] ";
    }
    return res.str();
}

double LS::computeMinDist() {
    double minDist = 1000000;
    double curDist;
    for (int i=0;i<(_size-1);i++) {
        for (int j=(i+1); j<_size; j++) {
            curDist = computeDist(_values[i],_values[j]);
            if ( curDist < minDist)
                minDist = curDist;
        }
    }

    return minDist;
}

double LS::computeDist( vector<int> point1, vector<int> point2 ) {
    double res = 0;
    for (int i=0; i<point1.size(); i++) {
        res += (point1[i]-point2[i])*(point1[i]-point2[i]);
    }
    //res = sqrt(res);
    return res;
}

// save an LS in a file
void LS::writeLS(string fileName) {
    //todo

}

// load an LS from a file
void LS::readLS(string fileName) {
    //todo

}

// compute the value of the current LS
// update the file containing the best value if there is a new reccord
void LS::updateBest() {
    double currentVal = computeMinDist();
    double bestVal = readBest();
    if (currentVal > bestVal) {
        cout << "new reccord!!: " << currentVal << endl;
        writeBest(currentVal);
    }
}

// save the current result in a file
// used to track the current best
void LS::writeBest(double val, string fileName /*=""*/) {
    if (fileName == "") {
        stringstream res;
        res << RECCORD_REP << _dim << "_" << _size << ".best";
        fileName = res.str();
    }

    ofstream myfile(fileName.c_str());
    myfile << val << endl;
    myfile << toString() << endl;
    myfile.close();

}

// load the result from the file or return 0 if no file
double LS::readBest(string fileName /*=""*/) {
    if (fileName == "") {
        stringstream res;
        res << RECCORD_REP << _dim << "_" << _size << ".best";
        fileName = res.str();
    }

    double res=0;
    ifstream myfile(fileName.c_str());
    if (myfile.is_open())
    {
        myfile >> res;
        myfile.close();
    } else {
        cerr << "could not read the file" << endl;
    }

    return res;
}

void LS::genRand() {
    // creation of dim sequences of values
    vector < vector<int> > tempVal;
    vector <int> seq;
    for (int i=0; i<_size; i++)
        seq.push_back(i);
    for (int i=0; i<_dim; i++)
        tempVal.push_back(seq);

    // we shuffle all except the first one
    for (int i=1; i<_dim; i++)
        random_shuffle(tempVal[i].begin(),tempVal[i].end());

    // we update _values
    for (int i=0; i<_size; i++) {
        for (int j=0;j<_dim;j++) {
            _values[i][j] = tempVal[j][i]; // _values is the transposed of tempVal
        }
    }

}

