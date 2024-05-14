function endPoints_ = segIndex(endPoints,adj_cell)
endPoints_ = endPoints;
endPoints_(:,3)=nan;
for i = 1:size(adj_cell,2)
    seg = adj_cell{1,i};
    rowIndex=find(ismember(endPoints, seg,'rows')); %按行索引血管段端点在endPoints中的位置
    endPoints_(rowIndex,3)=adj_cell{2,i};
end
