function [bif_Points, end_Points]= points2Find(SkelImg, endPoints)
I = SkelImg;
[H,W] = size(I);
bif_Points = []; 
end_Points = [];                                                     
neiBlock_row = [-1, -1, -1,  0, 0, 1, 1, 1];                          
neiBlock_col = [-1,  0,  1, -1, 1,-1, 0, 1];
% 遍历每个像素点，得到其邻域数目
for m=1:size(endPoints, 1)
    pointX = endPoints(m, 1); pointY = endPoints(m, 2); %当前搜索点
    searchPoints = [pointX+neiBlock_row;pointY+neiBlock_col]';
    num = 0; %计算邻接像素数目
    for n=1:8
        if (searchPoints(n,1)>0 && searchPoints(n,1)<H) &&... % 注意：可能临域索引超出图像边框
                (searchPoints(n,2)>0 && searchPoints(n,2)<W)
            if I(searchPoints(n,1),searchPoints(n,2))==1
                num = num+1;
            end
        end
    end
    % 根据邻接像素数目判别当前点的属性（端点,中间点,分叉点）
    if num==1 || num==0 %也可能是孤立像素
        end_Points = [end_Points;[pointX,pointY]];     % 端点
    end
    if num>1
        bif_Points = [bif_Points;[pointX,pointY]];     % 分叉点
    end
end
