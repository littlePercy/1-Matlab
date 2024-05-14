function [adj_matrix,num] = adj_search(point,I)
% 功能：寻找邻接像素（8连通域）
% 输入：原始二值化骨架图像I和当前像素点位置point
% 输出：point的邻接像素数目num以及坐标矩阵adj_matrix（num行2列）
neiBlock_row = [-1, -1, -1,  0, 0, 1, 1, 1];
neiBlock_col = [-1,  0,  1, -1, 1,-1, 0, 1];
searchPoints = [point(1,1)+neiBlock_row;point(1,2)+neiBlock_col]';
num = 0;%邻接像素为1的个数
adj_matrix = [];
[H,W] = size(I);
for n=1:8
    if (searchPoints(n,1)>0 && searchPoints(n,1)<H) &&... % 注意：可能临域索引超出图像边框
            (searchPoints(n,2)>0 && searchPoints(n,2)<W)
        if I(searchPoints(n,1),searchPoints(n,2))==1
            num = num+1;
            adj_matrix = [adj_matrix;[searchPoints(n,1),searchPoints(n,2)]];
        end
    end
end
