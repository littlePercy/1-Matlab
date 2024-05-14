%% 
function xy_k_all = cur_seg(adj_cell)
xy_k_all = [];
for ii = 1:size(adj_cell,2)
    segment_part = adj_cell{1,ii};
    x=segment_part(:,2);
    y=segment_part(:,1);                   %定义x，y
    p=polyfit(x,y,3);                      %使用3次多项式拟合
    y_=polyval(p,x);                       %求出预测值
    % plot(x,y_,'r')
    % set(gca,'ydir','reverse','xaxislocation','top');
    %legend('拟合函数')
    dif_matrix = [];
    dif_matrix_2 = [];
    for num = 2:length(y)-1
        df = (y_(num+1)-y_(num-1))/2;
        df_2 = y_(num+1)+y_(num-1)-2*y_(num);
        dif_matrix = [dif_matrix;df];
        dif_matrix_2 = [dif_matrix_2;df_2];
    end
    dif_matrix = dif_matrix';
    dif_matrix_2 = dif_matrix_2';
    k = abs(dif_matrix_2) ./ (1+dif_matrix.^2).^(3/2);
    xy_k = segment_part(2:end-1,:);
    xy_k(:,3) = k';
    xy_k_all = [xy_k_all;xy_k];
end
