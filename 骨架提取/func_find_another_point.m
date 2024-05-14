function nextPoint = func_find_another_point(indexPoint,indexList,pointNum)
% indexList = cell_1{2, clusPoints(j, 3)};
% indexPoint = clusPoints(j,1:2);
[~, loc] = ismember(indexPoint, indexList, 'rows');                % 找出端点在血管段的位置，首/尾
if loc==1
    if length(indexList)>pointNum
        nextPoint = indexList(pointNum, :);
    else
        nextPoint = indexList(end, :);
    end
else
    if length(indexList)>pointNum
        nextPoint = indexList(end-pointNum+1, :);
    else
        nextPoint = indexList(1, :);
    end
end



