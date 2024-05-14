%% -----定位所有血管段端点-----
load ARIA_prefs.mat
% OCTA_seg=imread('OCTA_seg.tif');
% mask_resize=zeros(354,354);                                                %边缘扩充使能检测到所有血管区域
% mask_resize(26:329,26:329)=OCTA_seg;
% octa_seg=logical(mask_resize);
% imwrite(octa_seg,'octa_seg.tif');
seg_octa=imread('octa_seg.tif');
[vessel_data, process_time] = Vessel_Data_IO.load_from_image(seg_octa, ...
    'DRIVE.vessel_processor', settings);
Adjacency_num = 0;
for i=1:vessel_data.num_vessels
    int = vessel_data.vessel_list(i);
    x =Adjacency_num+1:Adjacency_num+length(int.centre)-1;
    y = Adjacency_num+2:Adjacency_num+length(int.centre);
    end_point(i,:) = [x(1),y(end),i];                                      %血管起始点位置索引在邻接矩阵中的编号,血管段编号
    for t = 1:length(int.centre)
        Adjacency_num = Adjacency_num+1;
        V(Adjacency_num,:) = [int.centre(t,2),int.centre(t,1)];            %V:保存了所有血管段中心点的坐标(图像坐标系)    
    end
end
t = 1;
for i = 1:length(end_point)
    point_local(t,:) = [V(end_point(i,1),:),end_point(i,1),end_point(i,3)];% 统计血管段起始点的坐标（i,1）
    t=t+1;
    point_local(t,:) = [V(end_point(i,2),:),end_point(i,2),end_point(i,3)];% 统计血管段终结点的坐标（i,2）
    %邻接矩阵内点的编号（3），血管段编号（4）
    t=t+1;
end
%% -----定位关键点-----
endpoint=point_local;
MD2=createns(endpoint(:,1:2),'NSMethod','kdtree','Distance','euclidean');
for i =1:size(MD2.X,1)
    point = endpoint(i,1:2);                                               % 某个端点
    check_point=rangesearch(MD2,point,5);                                  % 查找某个端点周围指定距离内的所有邻居(为point点找到距离RADIUS(5)范围内的X中的所有点)
    neighbor{1,i} = check_point{1};                                        % 在endpoint里的索引位置
end
%% -----建立全连接的图(邻接矩阵)-----
son_index = [];
parent_index = [];
for i = 2:2:size(point_local,1)                                            %每个血管段的两个端点
    son_index = [son_index,i-1];                                           %Son:小到大（端点索引）
    parent_index = [parent_index,i];                                       %Parent:大到小（端点索引）
    son_index = [son_index,i];
    parent_index = [parent_index,i-1];
end
for i = 1:length(neighbor)
    if length(neighbor{i})>1
        for j = 1:length(neighbor{i})
            for k = 1:length(neighbor{i})
                if j~=k
                    son_index = [son_index,neighbor{i}(j)];
                    parent_index = [parent_index,neighbor{i}(k)];
                end
            end
        end
    end
end
originl_link = [son_index;parent_index]';
originl_link=unique(originl_link,'rows');   
link_point = originl_link;
link_point = double(link_point);
link = ones(1,size(link_point,1));
A_matric = sparse(link_point(:,1),link_point(:,2),link);                   % 建立稀疏邻接矩阵
A = full(A_matric);
G.A = A_matric;                                                            % 建立对称无向图
G.V = point_local(:,1:2);
figure,plot_graph_1(G,1,vessel_data.im_orig);                              %在血管分割图上可视化建立的图
%% -----定位边缘起点-----
h=size(seg_octa);
w=size(seg_octa);
mask_OCTA=zeros(size(seg_octa));
mask_OCTA(35:h-35,35:w)=1;
fusion=uint8(255*seg_octa);
fusion1=zeros(size(fusion));
fusionseg=double(cat(3,mask_OCTA,fusion,fusion1));
figure,imshow(fusionseg)
[OCTA_start,~]=Find_squre_start(point_local,mask_OCTA,vessel_data);
start_point = OCTA_start;      
%% -----基于方向连接一级血管树-----
for i =1:length(start_point)
    seed_point{i} = start_point(i);
end
for i = 1:length(seed_point)
    next_point=seed_point{i};
    nuture_tree{i} = [next_point];
    while ~isnan(next_point)
        point_list=find(A(next_point,:)==1);
        if length(point_list)==1
            if ~ismember(point_list(1),nuture_tree{i})
                next_point=point_list(1);
                nuture_tree{i} = [nuture_tree{i},next_point];
            else
                next_point=NaN;
            end
        else
            vessel_start=vessel_data.vessel_list(point_local(next_point,4));
            centre_list=vessel_start.centre;
            %%-----确定方向象限-----
            if rem(next_point,2)==0
                direct=(centre_list(end,1)-centre_list(end-1,1))/(centre_list(end,2)-centre_list(end-1,2));
                if ((centre_list(end,2)-centre_list(end-1,2))>0)&&((centre_list(end,1)-centre_list(end-1,1))>0)==1
                    direct(2,1)=1;
                elseif ((centre_list(end,2)-centre_list(end-1,2))<0)&&((centre_list(end,1)-centre_list(end-1,1))>0)==1
                    direct(2,1)=2;
                elseif ((centre_list(end,2)-centre_list(end-1,2))<0)&&((centre_list(end,1)-centre_list(end-1,1))<0)==1
                    direct(2,1)=3;
                elseif ((centre_list(end,2)-centre_list(end-1,2))>0)&&((centre_list(end,1)-centre_list(end-1,1))<0)==1
                    direct(2,1)=4;
                end
            else
                direct=(centre_list(1,1)-centre_list(2,1))/(centre_list(1,2)-centre_list(2,2));
                if ((centre_list(1,2)-centre_list(2,2))>0)&&((centre_list(1,1)-centre_list(2,1))>0)==1
                    direct(2,1)=1;
                elseif ((centre_list(1,2)-centre_list(2,2))<0)&&((centre_list(1,1)-centre_list(2,1))>0)==1
                    direct(2,1)=2;
                elseif ((centre_list(1,2)-centre_list(2,2))<0)&&((centre_list(1,1)-centre_list(2,1))<0)==1
                    direct(2,1)=3;
                elseif ((centre_list(1,2)-centre_list(2,2))>0)&&((centre_list(1,1)-centre_list(2,1))<0)==1
                    direct(2,1)=4;
                end
            end
            direct_list=[];
            for j=1:length(point_list)
                if ~ismember(point_list(j),nuture_tree{i})
                    vessel=vessel_data.vessel_list(point_local(point_list(j),4));
                    centre=vessel.centre;
                    %%-----确定方向象限-----
                    if rem(point_list(j),2)==0
                        direct_list(1,j)=(centre(end-1,1)-centre(end,1))/(centre(end-1,2)-centre(end,2));
                        if ((centre(end-1,2)-centre(end,2))>0)&&((centre(end-1,1)-centre(end,1))>0)==1
                            direct_list(2,j)=1;
                        elseif ((centre(end-1,2)-centre(end,2))<0)&&((centre(end-1,1)-centre(end,1))>0)==1
                            direct_list(2,j)=2;
                        elseif ((centre(end-1,2)-centre(end,2))<0)&&((centre(end-1,1)-centre(end,1))<0)==1
                            direct_list(2,j)=3;
                        elseif ((centre(end-1,2)-centre(end,2))>0)&&((centre(end-1,1)-centre(end,1))<0)==1
                            direct_list(2,j)=4;
                        end
                    else
                        direct_list(1,j)=(centre(2,1)-centre(1,1))/(centre(2,2)-centre(1,2));
                        if ((centre(2,2)-centre(1,2))>0)&&((centre(2,1)-centre(1,1))>0)==1
                            direct_list(2,j)=1;
                        elseif ((centre(2,2)-centre(1,2))<0)&&((centre(2,1)-centre(1,1))>0)==1
                            direct_list(2,j)=2;
                        elseif ((centre(2,2)-centre(1,2))<0)&&((centre(2,1)-centre(1,1))<0)==1
                            direct_list(2,j)=3;
                        elseif ((centre(2,2)-centre(1,2))>0)&&((centre(2,1)-centre(1,1))<0)==1
                            direct_list(2,j)=4;
                        end
                    end
                end
            end
            direction=atan(direct(1,1));
            if (direct(2,1)==1)||(direct(2,1)==4)
                direct1=direction;
            elseif direct(2,1)==3
                direct1=direction-pi;
            elseif direct(2,1)==2
                direct1=direction+pi;
            end
            sub=[];
            %%-----找到最小方向-----
            for k=1:size(direct_list,2)
                if direct_list(1,k)~=0
                    temp=atan(direct_list(1,k));
                    if (direct_list(2,k)==1)||(direct_list(2,k)==4)
                        temp1=temp;
                    elseif direct_list(2,k)==3
                        temp1=temp-pi;
                    elseif direct_list(2,k)==2
                        temp1=temp+pi;
                    end
                    sub(k)=abs(direct1-temp1);
                end
            end
            sub(find(sub==0))=NaN;
            [~,n]=min(sub);
            next_point=point_list(n);
            nuture_tree{i} = [nuture_tree{i},next_point];
            if rem(next_point,2)==0
                next_point=next_point-1;
            else
                next_point=next_point+1;
            end
            nuture_tree{i} = [nuture_tree{i},next_point];
        end
    end
end
%% -------------定义显示-------------
figure,imshow(vessel_data.bw)
title('OCTA topology estimate')
hold on
L = length(nuture_tree);
cc=mat2cell(0+.75*rand(L,3),ones(1,L),3 );
c=cell2mat(cc);%定义显示颜色
for i = 1:length(nuture_tree)
    vessel_index = point_local(nuture_tree{i}(rem(nuture_tree{i},2)==1),4);
    for p = 1:length(vessel_index)
        int = vessel_data.vessel_list(vessel_index(p));
        plot(int.centre(:,2),int.centre(:,1),'.','color',c(i,:));
    end
end
