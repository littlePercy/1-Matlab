tiffStack_2 = TIf_read('G:\24 重医附二鞠大鹏-线粒体平均长度统计-20240103\mask\15-561.tif');
% img1 = tiffStack_2(:,:,1);
% mask_binary = imbinarize(img1);
% [B,conNum] = connectDomain(mask_binary);                                   % conNum 连通域数量
% figure,imshow(mask_binary)
% hold on
% for i = 1:conNum
%     [row, col] = find(B==i);
%     cc=mat2cell(0+.75*rand(conNum,3),ones(1,conNum),3 );
%     c=cell2mat(cc);%定义显示颜色
%     plot(col,row,'.','color',c(i,:));
% end
% for i = 1:conNum % 遍历每个连通域求解
%     tempImg = selecRegion(B,i);
%     STATS = regionprops(tempImg,'Centroid','BoundingBox');
%     center = STATS.Centroid;                                               % √√ 质心坐标（图像坐标系）
%     text(center(1),center(2), num2str(i),'Color',...
%         'r','FontSize',8,'FontWeight','bold');
% end
% BW=bwmorph(mask_binary,'thin',Inf);
% figure,imshow(BW),title('显示骨架化图像')
% mean_length =  sum(BW(:)==1)/conNum;                                       % 线粒体平均长度
%% TXT统计
fid = fopen('result1.txt','w');
fprintf(fid,'%s \t  %s \t %s\n','帧数', '数量', '平均长度');
for i = 1:size(tiffStack_2 ,3)
    img1 = tiffStack_2(:,:,i);
    mask_binary = imbinarize(img1);
    [B,conNum] = connectDomain(mask_binary);
    BW=bwmorph(mask_binary,'thin',Inf);
    mean_length =  sum(BW(:)==1)/conNum;
    frame = sprintf('%04d', i);
    fprintf(fid,'%s \t %d \t %.4f \n', frame, conNum, mean_length*0.0325);
end
fclose(fid);
%% 作散点图
TXT1 = importdata('result1.txt');
Data1 = TXT1.data;
t = 13/60 : 13/60 : 291*13/60;
y_1 = Data1(:,2); y_1=y_1'; %信号平均荧光强度
figure,
% plot(t, y_1, 'k-', 'LineWidth', 1);
scatter(t, y_1, '.');
xlabel('time (h)'), ylabel('number of mitochondria')
box off;               % 去除右上坐标标记
set(gca,'linewidth',1) % 设置坐标轴线宽
set(gca,'FontSize',14);
ax = gca;             % current axes
ax.TickDir = 'out';   % 表头向外
% set(ax, 'Color', 'none');
saveas(ax,'线粒体数量统计.png');
%%
y_2 = Data1(:,3); y_2=y_2'; %信号平均荧光强度
figure,
% plot(t, y_1, 'k-', 'LineWidth', 1);
scatter(t, y_2, '.');
xlabel('time (h)'), ylabel('average length of mitochondria')
box off;               % 去除右上坐标标记
set(gca,'linewidth',1) % 设置坐标轴线宽
set(gca,'FontSize',14);
ax = gca;             % current axes
ax.TickDir = 'out';   % 表头向外
% set(ax, 'Color', 'none');
saveas(ax,'线粒体平均长度统计.png');
