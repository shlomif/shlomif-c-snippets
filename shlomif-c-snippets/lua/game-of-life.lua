width = 20
height = 10

board = {}
for y=1,height do
    line = {}
    for x=1,width do
        line[x] = false
    end
    board[y] = line
end

function render_cell(cell)
    if cell then
        return "*"
    else
        return " "
    end
end

function print_board(b)
    print("<board>");
    for y=1,height do
        line = b[y]
        for x=1,width do
            io.write(render_cell(line[x]))
        end
        io.write("\n");
    end
    print ("</board>\n");
end

board[5][5] = true
board[5][6] = true
board[5][7] = true
board[4][5] = true
board[6][6] = true

num_steps = 10

function calc_new_cell(orig_cell_val, count)
    --[[
    --For debugging
    print("orig_cell_val = " ..
        (orig_cell_val and "true" or "false") .. " ;
        count = " .. count)
    ]]
    if orig_cell_val then
        return (count == 2 or count == 3)
    else
        return (count == 3)
    end
end

function transform_board(orig)
    new = {}
    for y=1,height do
        new_line = {}
        for x=1,width do
            count = 0
            for x_off=-1,1 do
                for y_off=-1,1 do
                    vicinity_x = x_off+x
                    vicinity_y = y_off+y

                    if (vicinity_x >= 1 and vicinity_x <= width and
                        vicinity_y >= 1 and vicinity_y <= height
                        and (not (x_off == 0 and y_off == 0))) then
                        if (orig[vicinity_y][vicinity_x]) then
                            count = count + 1
                        end
                    end
                end
            end
            new_line[x] = calc_new_cell(orig[y][x], count)
        end
        new[y] = new_line
    end
    return new
end

for step=1,num_steps do
    print_board(board)
    board= transform_board(board)
end
