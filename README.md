# dijkstra-algorithm-programs
Dijkstra's algorithm for finding the shortest paths implementation.

These programs find the shortest path between two nodes in a graph.  They realize the classical Dijkstra's algorithm without any optimizations.  This algorithm can be described as a five step process.

Let's consider that **S** is a set that contains all vertices of a graph and **D** is an array to keep distances.  Let's consider that all vertices are named as natural numbers from 1 to **n**.  **l** is a function defined on the edges (**N** is the set of edges), it yields the weight of a chosen edge.  Let's also consider the starting point at 0 and the ending point at **n**.

1. D(1) = 0, S = {2, ... , n};
2. For all i ∈ S: if {1, i} ∈ N then D(i) = l({1, i}) else D(i) = MAX_NUMBER;
3. Choose j ∈ S so D(j) = min D(i) for all i ∈ S then remove j from S (S = S \ {j});
4. If j = n then the length of the shortest path is equal D(j);
5. For all i ∈ S: if {j, i} ∈ N then D(i) = min(D(i), D(j) + l({j,i})). Goto 3.

All the programs can work with any graph defined by a set of weighted vertices.  The programs written in C++ can also work with arbitrary mesh up to dimension of 256x256, this mesh's edge weights are taken randomly from a range defined by constants.  They also can print the mesh.  Every program writes the length of the shortest route and the route itself.  C++ programs also write the number of edges of the shortest path.

**dijkstra-m.cpp** uses the standard library containers (a map or unordered map) to keep edges.

**dijkstra.cpp** uses the standard C-array to keep edges, it is faster but requires a lot of memory - more than 8 GB for a full sized mesh.

**dijkstra.pas** can only work with a graph which contains less than 257 vertices.

**dijkstra.pro** can be used by the searching the goal **w(start,finish)**. 
