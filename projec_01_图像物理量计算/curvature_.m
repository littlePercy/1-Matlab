%% test one segment part
% segment_part = adj_cell{1,5};
% x=segment_part(:,2);
% y=segment_part(:,1);                   %定义x，y
% p=polyfit(x,y,3);                      %使用3次多项式拟合
% y_=polyval(p,x);                       %求出预测值
% % plot(x,y_,'r')
% % set(gca,'ydir','reverse','xaxislocation','top');
% %legend('拟合函数')
% dif_matrix = [];
% dif_matrix_2 = [];
% for num = 2:length(y)-1
%     h = x(num)-x(num-1);
%     df = (y_(num+1)-y_(num-1))/2;
%     df_2 = y_(num+1)+y_(num-1)-2*y_(num);
%     dif_matrix = [dif_matrix;df];
%     dif_matrix_2 = [dif_matrix_2;df_2];
% end
% dif_matrix = dif_matrix';
% dif_matrix_2 = dif_matrix_2';
% k = abs(dif_matrix_2) ./ (1+dif_matrix.^2).^(3/2);
% mean_k = mean(k);
% xy_k = segment_part(2:end-1,:);
% xy_k(:,3) = k';
% 可视化
% figure
% x_x = xy_k(:,2)';
% y_y = xy_k(:,1)';
% c_c = xy_k(:,3)';
% patch([x_x,nan],[y_y,nan],[c_c,nan],'EdgeColor','flat','LineWidth',1,'MarkerFaceColor','flat','FaceColor','none')
% colorbar
% set(gca,'ydir','reverse','xaxislocation','top');
%%
mask = imread('mask.png');
mask_binary = imbinarize(mask); %二值化mask结果
SkelImg = bwmorph(mask_binary,'skel',Inf);
figure,imshow(SkelImg)
hold on
[adj_cell,bifurPointsNum] = segment_extraction(SkelImg);
xy_k_all = cur_seg(adj_cell);
figure
plot(xy_k_all(:,2),xy_k_all(:,1),'r.')
xlim([0 1024])
ylim([0 1024])
set(gca,'ydir','reverse','xaxislocation','top');
jet_color = colormap(jet(size(xy_k_all,1)));
color_bar = xy_k_all(:,3);
[~, color_index] = sort(color_bar);
A = zeros(1024,1024);
for i=1:length(color_index)
        A(xy_k_all(i,1),xy_k_all(i,2))=xy_k_all(i,3);
end
ymax=255;ymin=0;
xmax = max(max(A));
xmin = min(min(A));
OutImg = round((ymax-ymin)*(A-xmin)/(xmax-xmin) + ymin); %归一化并取整
outImg = uint8(OutImg);
figure,imshow(outImg)








