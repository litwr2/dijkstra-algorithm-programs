(* the shortest way with the path printed *)
uses
   strings;
const
   min_point = 1;
   max_point = 6;  (* at range 0..255 *)
   max_path_length = 1000;
   ARCS = 11; (* number of arcs *)
type
   range = min_point..max_point;
   bytes = set of range;
const
   ini_arcs: array[1..ARCS]of array[1..3]of integer =
      ((1,2,4),   (* start, end, length *)
       (1,3,11),
       (2,3,5),
       (2,4,2),
       (2,5,8),
       (2,6,7),
       (3,5,5),
       (3,6,3),
       (4,5,1),
       (4,6,10),
       (5,6,3));
   vertices: bytes = [];
   start_point = 1;
   end_point = 6;
var
   D: array[range] of integer;
   P: array[range] of PChar;
   ts: string;
   lengths: array[range, range] of integer;
   S: bytes;
   i, j, l: integer;
procedure fill_sets;
   var i, v1, v2: byte;
   begin
       for v1 := min_point to max_point do
          for v2 := min_point to max_point do
             lengths[v1][v2] := -1;
       for i := 0 to high(ini_arcs) do begin
          v1 := ini_arcs[i][1];
          v2 := ini_arcs[i][2];
          vertices := vertices + [v1] + [v2];
          lengths[v1][v2] := ini_arcs[i][3];
          lengths[v2][v1] := ini_arcs[i][3];
       end
   end;
function minD: integer;
   var
      min: integer;
      index_min: integer;
   begin
      min := high(integer);
      index_min := -1;
      for i := min_point to max_point do
         if i in S then
            if (D[i] >= 0) and (min > D[i]) then begin
               min := D[i];
               index_min := i
            end;
      minD := index_min
   end;
begin
   for i := min_point to  max_point do
      P[i] := StrAlloc(max_path_length);
   fill_sets;
   D[start_point] := 0;                         (* Step 1 *)
   S := vertices - [start_point];
   for i := min_point to max_point do           (* Step 2 *)
      if i in S then begin
         D[i] := lengths[start_point][i];
         str(i, ts);
         strpcopy(P[i], ts);
      end;
   repeat                                       (* Step 3 *)
      j := minD;
      S := S - [j];
      if j = end_point then begin               (* Step 4 *)
         writeln('min = ', D[j], ' ', start_point, '-', P[end_point]);
         halt
      end;
      for i := min_point to max_point do        (* Step 5 *)
         if i in S then begin
            l := lengths[j][i];
            if l >= 0 then begin
               l := D[j] + l;
               if (D[i] < 0) or (D[i] > l) then begin
                  D[i] := l;
                  str(i, ts);
                  strcopy(P[i], P[j]);
                  strcat(P[i], '-');
                  ts := ts + #0;
                  strcat(P[i], @ts[1])
               end;
            end
         end
   until false
end.

