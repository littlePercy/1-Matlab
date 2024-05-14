function bifurPoints=bifurFind(SkelImg)
% 功能：
% 输入：
% 输出：
I = SkelImg;
[H,W] = size(I);
bifurPoints = [];
[a,b] = find(I==1); %索引所有中心线像素点的行列坐标                                                        
neiBlock_row = [-1, -1, -1,  0, 0, 1, 1, 1];                          
neiBlock_col = [-1,  0,  1, -1, 1,-1, 0, 1];
% 遍历每个像素点，得到其邻域数目
for m=1:length(a)
    pointX = a(m);pointY = b(m); %当前搜索点
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
    if num>=3
        bifurPoints = [bifurPoints;[pointX,pointY]]; % 分叉点
    end
end
