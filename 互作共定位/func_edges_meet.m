function edges_lis = func_edges_meet(all_lis_copy, mask_561_binary)
edges_lis = [];
neiBlock_row = [-1, -1, -1,  0, 0, 1, 1, 1];
neiBlock_col = [-1,  0,  1, -1, 1,-1, 0, 1];
% 遍历每个像素点，得到其邻域数目
for m=1:size(all_lis_copy,1)
    pointX = all_lis_copy(m,1);pointY = all_lis_copy(m,2);                 % 当前搜索点
    searchPoints = [pointX+neiBlock_row;pointY+neiBlock_col]';
    for n=1:8
        if mask_561_binary(searchPoints(n,1),searchPoints(n,2))==1
            edges_lis = [edges_lis; pointX, pointY];
        end
    end
end
