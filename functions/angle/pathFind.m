% 输入原始二值化骨架图像I
% 输入分叉点bifurPoints_mean和端点endPoints坐标矩阵
% 输出：
%%
point = bifurPoints_mean(1,:);
adj_cell={};
[adj_matrix,num] = adj_search(point,I); %返回邻接像素数目和坐标矩阵
seen = [point;adj_matrix];
%% test

% for n=1:num
% 开始条件：随机？选取一个分叉点作为起始索引点
n=3;
adj_cell{3,1}=[point;point_];
point_=adj_matrix(3,:);
[adj_,num_] = adj_search(point_,I);
C = setdiff(adj_,seen,'rows'); % 理想状态下能索引到唯一的中间点setdiff函数能够adj_中在seen中出现过的元素，'rows'按行
seen = [seen;C]; 
adj_cell{3,1} = [adj_cell{3,1};C];    
% ==========================一个操作流程====================================                                                                   % 
[adj_1,num_1] = adj_search(C,I);                                          %
C_1 = setdiff(adj_1,seen,'rows');                                         %
adj_cell{3,1} = [adj_cell{3,1};C_1];                                      %
seen = [seen;C_1];                                                        %
% =========================================================================
% ==========================一个操作流程====================================                                                                   % 
[adj_2,num_2] = adj_search(C_1,I);                                          %
C_2 = setdiff(adj_2,seen,'rows');                                         %
adj_cell{3,1} = [adj_cell{3,1};C_2];                                      %
seen = [seen;C_2];                                                        %
% =========================================================================
% 终止条件：遇到端点或者分叉点
%% 可视化
figure,imshow(I)
hold on
plot(point(1,2),point(1,1),'ro','MarkerFaceColor','cyan');
plot(searchPoints(:,2),searchPoints(:,1),'ro','MarkerFaceColor','green');

figure,imshow(I)
hold on
plot(point(1,2),point(1,1),'ro','MarkerFaceColor','cyan');
plot(adj_cell{3,1}(:,2),adj_cell{3,1}(:,1),'ro','MarkerFaceColor','red');
