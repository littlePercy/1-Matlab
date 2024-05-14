function final_neighbors_ = angleVector(final_neighbors,adj_cell)
final_neighbors_ = final_neighbors;
for i=1:size(final_neighbors,2)
%     connectPts=[];
    vectors=[];
    angles=[];
    for j=1:size(final_neighbors{1,i},1)
        indexNum = final_neighbors{2,i}(j,:);
        indexPoint = final_neighbors{1,i}(j,:);
        indexList = adj_cell{1,indexNum};
        rowIndex = find(ismember(indexList, indexPoint,'rows'));%找出端点在血管段的位置，首/尾
        if rowIndex==1
            nextPoint = indexList(5,:);
        else
            nextPoint = indexList(end-4,:);
        end
        vec_ = [nextPoint(2)-indexPoint(2),-(nextPoint(1)-indexPoint(1))];%图像坐标系和计算坐标系之间的转换需要注意
        vectors = [vectors;vec_];
        angle = 360-(atan2(vec_(2),vec_(1))*180/pi); 
        angles = [angles;angle];
    end
    [~,index]=sort(angles);
    sigmas=[];
    for jj=1:length(index)
        if jj~=length(index)
            sigma=180*(acos(dot(vectors(index(jj),:),vectors(index(jj+1),:))...
                /(norm(vectors(index(jj),:))*norm(vectors(index(jj+1),:)))))/pi;
        else
            sigma=180*(acos(dot(vectors(index(jj),:),vectors(index(1),:))...
                /(norm(vectors(index(jj),:))*norm(vectors(index(1),:)))))/pi;
        end
        sigmas=[sigmas;sigma];
    end
    sigmas_=sigmas(index,:);%每个段和顺时针下一个段之间对应的夹角
    final_neighbors_{4,i} = sigmas_;
    if length(sigmas_)==3
        final_neighbors_{5,i} = min(sigmas_);
    else
        lsss = sort(sigmas_);
        final_neighbors_{5,i} = lsss(1:2);
    end
end



% figure,imshow(SkelImg)
% hold on
% text(final_neighbors{1,i}(:,2)-1,final_neighbors{1,i}(:,1)-1,string(sigmas_),'FontSize',8,'Color','g')
