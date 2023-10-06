with Ada.Text_IO; use Ada.Text_IO;

procedure Golada is
  type Cell is (Alive, Dead);
  type BoardRow is mod 5;
  type BoardColumn is mod 5;
  type Board is array (BoardRow, BoardColumn) of Cell;
  type LiveNeighbors is range 0 .. 8;

  B : Board :=
   ((others => Dead), (others => Dead), (Dead, Alive, Alive, Alive, Dead),
    others => (others => Dead));

  procedure Print_Board (B : in Board) is
  begin
    for Row in BoardRow loop
      Put ("[");

      for Column in BoardColumn loop
        case B (Row, Column) is
          when Alive =>
            Put ("X");
          when Dead =>
            Put ("-");
        end case;
      end loop;

      Put_Line ("]");
    end loop;

    Put_Line ("");
  end Print_Board;

  function Count_Live_Neighbors
   (B : Board; Row : BoardRow; Column : BoardColumn) return LiveNeighbors
  is
    N : LiveNeighbors := 0;
  begin
    for DeltaRow in BoardRow range 0 .. 2 loop
      for DeltaColumn in BoardColumn range 0 .. 2 loop
        if DeltaRow /= 1 or else DeltaColumn /= 1 then
          if B (Row + DeltaRow - 1, Column + DeltaColumn - 1) = Alive then
            N := N + 1;
          end if;
        end if;
      end loop;
    end loop;

    return N;
  end Count_Live_Neighbors;

  function Step_Board (IB : in Board) return Board is
    Result : Board;
  begin

    for Row in BoardRow loop
      for Column in BoardColumn loop
        declare
          N : constant LiveNeighbors := Count_Live_Neighbors (IB, Row, Column);
        begin
          case IB (Row, Column) is
            when Alive =>
              -- Any live cell with two or three live neighbours survives.
              -- All other live cells die in the next generation.
              if N in 2 .. 3 then
                Result (Row, Column) := Alive;
              else
                Result (Row, Column) := Dead;
              end if;
            when Dead =>
              -- Any dead cell with three live neighbours becomes a live cell.
              -- All other dead cells stay dead.
              if N = 3 then
                Result (Row, Column) := Alive;
              else
                Result (Row, Column) := Dead;
              end if;
          end case;
        end;
      end loop;
    end loop;

    Put_Line ("");

    return Result;
  end Step_Board;
begin
  loop
    Print_Board (B);

    B := Step_Board (B);
  end loop;
end Golada;
