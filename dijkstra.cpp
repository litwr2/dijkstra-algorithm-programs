#define RANDOM_FILL 0
#define PRINT_BOX 0

#include <iostream>
#include <iomanip>
#include <set>
#include <string>
#include <climits>
#include <cstdlib>
#include <ctime>
using namespace std;

#if RANDOM_FILL
const unsigned start_point = 0, BOX_SIZE = 200, TOPS = BOX_SIZE*BOX_SIZE, end_point = TOPS - 1, max_arc_length = 9;
#else
const unsigned ARCS = 11, TOPS = 6, start_point = 0, end_point = 5;
unsigned ini_arcs[ARCS][3] = /* start, end, length */
       {{1,2,4},
       {1,3,11},
       {2,3,5},
       {2,4,2},
       {2,5,8},
       {2,6,7},
       {3,5,5},
       {3,6,3},
       {4,5,1},
       {4,6,10},
       {5,6,3}};
#endif

set<unsigned> S;
unsigned (*lengths)[TOPS], D[TOPS], arc_count[TOPS];
string path[TOPS]; //path printed

#if RANDOM_FILL
void fill_random_box() {
	unsigned v1, v2;
	srand(time(0)%777);
	for (v1 = 0; v1 < TOPS; ++v1) {
		S.insert(v1);
		for (v2 = 0; v2 < TOPS; ++v2)
			if (v1 < v2) {
				if (v1 + 1 == v2 && v2%BOX_SIZE != 0 || v1 + BOX_SIZE == v2)
					lengths[v2][v1] = lengths[v1][v2] = rand()%max_arc_length + 1;
				else
					lengths[v2][v1] = lengths[v1][v2] = UINT_MAX;
			}
	}
}
void print_box() {
	unsigned v1, v2, w1 = 1, w2 = 2;
/*	for (v1 = 0; v1 < TOPS; ++v1)
		for (v2 = 0; v2 < TOPS; ++v2)
			if (v1 != v2)
			cout << v1 << '-' << v2 << ' ' << lengths[v1][v2] << endl;*/
        v1 = TOPS;
	while ((v1 /= 10) > 0) ++w1;
        v1 = max_arc_length;
	while ((v1 /= 10) > 0) ++w2;
	for (v1 = 0; v1 < BOX_SIZE; ++v1) {
		for (v2 = 0; v2 < BOX_SIZE - 1; ++v2)
			cout << '[' << setw(w1) << v1*BOX_SIZE + v2 << ']' << setw(w2) 
				<< lengths[v1*BOX_SIZE + v2][v1*BOX_SIZE + v2 + 1];
		cout << '[' << setw(w1) << v1*BOX_SIZE + v2 << "]\n";
                if (v1 < BOX_SIZE - 1) {
			for (v2 = 0; v2 < BOX_SIZE - 1; ++v2)
				cout << setw(w2) << lengths[v1*BOX_SIZE + v2][v1*BOX_SIZE + v2 + BOX_SIZE]
					<< setw(w1 + 2) << " ";
			cout << setw(w2) << lengths[v1*BOX_SIZE + v2][v1*BOX_SIZE + v2 + BOX_SIZE] << endl;
		}
	}
}
#else
void fill_sets() {
	unsigned i, v1, v2;
	for (v1 = 0; v1 < TOPS; ++v1)
		for (v2 = 0; v2 < TOPS; ++v2)
			lengths[v1][v2] = UINT_MAX;
	for (i = 0; i < ARCS; ++i) {
		v1 = ini_arcs[i][0] - 1;
		v2 = ini_arcs[i][1] - 1;
		S.insert(v1);
		S.insert(v2);
		lengths[v1][v2] = ini_arcs[i][2];
		//lengths[v2][v1] = ini_arcs[i][2];
	}
}
#endif

unsigned minD() {
	unsigned min, index_min;
	min = UINT_MAX;
	for (auto i: S)
		if (min > D[i]) {
			min = D[i];
			index_min = i;
		}
	return index_min;
}
int main() {
	unsigned j, l;
	lengths = (unsigned(*)[TOPS]) new unsigned [TOPS*TOPS];
#if RANDOM_FILL
	fill_random_box();
#if PRINT_BOX
        print_box();
#endif
#else
	fill_sets();
#endif
	D[start_point] = 0;
	S.erase(start_point);			//Step 1
	for (auto i: S) {				//Step 2
		D[i] = lengths[start_point][i];
		path[i] = to_string(start_point) + "-" + to_string(i);
		arc_count[i]++;
	}
	for(;;) {					//Step 3
		j = minD();
		S.erase(j);
		if (j == end_point) {			//Step 4
			cout << "min = "  << D[j] << " (" << arc_count[end_point] << ")\npath = " << path[end_point] << endl;
			return 0;
		}
		for (auto i: S)				//Step 5
			if ((l = lengths[j][i]) != UINT_MAX) {
				l += D[j];
				if (D[i] > l) {
					D[i] = l;
					path[i] = path[j] + "-" + to_string(i);
					arc_count[i] = arc_count[j] + 1;
				}
			}
	}
}

