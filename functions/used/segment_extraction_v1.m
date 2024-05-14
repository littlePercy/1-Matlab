function adj_cell=segment_extraction(SkelImg)
% 功能：
% 输入：原始二值化骨架图像SkelImg
% 输出：分段像素元组adj_cell，每一列存储代表一个中心线段像素位置
I = SkelImg;
[H,W] = size(I);
endPoints = []; midPoints = []; bifurPoints = [];
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
    elseif num==1
        endPoints = [endPoints;[pointX,pointY]];     % 端点
    end
end
%% ==========最近邻搜索求每个分叉点群的平均==========
neighbors = neighborFind(bifurPoints,5);%在所有分叉点列表中找到属于同一个分叉的点的索引
bifurPoints_mean = neighborMean(neighbors,bifurPoints);%用其中一个点代替一个分叉点群
bifurPointsNum = size(bifurPoints_mean,1);                                 % √ 分叉点个数
% 可视化分叉点和端点
% figure,imshow(I)
% hold on
% plot(bifurPoints_mean(:,2),bifurPoints_mean(:,1),'ro','MarkerFaceColor','cyan');
% plot(endPoints(:,2),endPoints(:,1),'ro','MarkerFaceColor','green');
%% 
segNum = 0;%记录中心线段数目 没约束没有中心线的情况
seen = [];%用于存储所有已经被索引过的像素点
adj_cell={};%用于存储所有已经被索引过的像素点
for i=1:bifurPointsNum %从每个分叉点开始索引
    point = bifurPoints_mean(i,:);
    pointSave = [];
    pointSave = [pointSave;point];
    seen = [seen;point];
    [adj_matrix,num] = adj_search(point,I); %返回邻接像素数目和坐标矩阵
    adj_matrix = setdiff(adj_matrix,seen,'rows');
    cursegNum = size(adj_matrix,1); %当前轮需要存储的中心线段数目
    seen = [seen;adj_matrix];
    for kk = 1:cursegNum
        pointNow = adj_matrix(kk,:);%当前点，相当于一个cur指针
        pointSave = [pointSave;pointNow];
        % 开始内部迭代索引
        while 1
            [adj_,num_] = adj_search(pointNow,I);%返回当前点的邻接像素数目和坐标矩阵
            C = setdiff(adj_,seen,'rows'); %这里有问题！！！！！！没考虑到更复杂的情况 这里假设C解出来只有一个点 理想化了
            if size(C,1)>1
                [c, ia, ib] = intersect(C,bifurPoints_mean,'rows'); %找出两个矩阵中相同行的行号
                C = C(ia,:);
            end
            pointSave = [pointSave;C]; 
            seen = [seen;C];
            pointNow = C;
            % 终止条件：遇到端点或者分叉点
            if ismember(pointNow,bifurPoints_mean,'rows') ||...
                    ismember(pointNow,endPoints,'rows')
                segNum = segNum+1;
                adj_cell{1,segNum}=pointSave;
                adj_cell{2,segNum}=segNum;
                pointSave = [];
                break
            end
        end
    end
end
% %% -------------定义显示-------------
% figure,imshow(I)
% title('中心线分段显示')
% hold on
% L = size(adj_cell,2);
% cc=mat2cell(0+.75*rand(L,3),ones(1,L),3 );
% c=cell2mat(cc);%定义显示颜色
% for ii = 1:size(adj_cell,2)
%     plot(adj_cell{1,ii}(:,2),adj_cell{1,ii}(:,1),'.','color',c(ii,:));
% end
